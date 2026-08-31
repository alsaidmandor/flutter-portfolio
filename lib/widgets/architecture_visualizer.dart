import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ArchitectureVisualizer extends StatefulWidget {
  const ArchitectureVisualizer({super.key});

  @override
  State<ArchitectureVisualizer> createState() => _ArchitectureVisualizerState();
}

class _ArchitectureVisualizerState extends State<ArchitectureVisualizer> {
  int _selectedLayer = 0;

  static const _layers = [
    (
      title: 'Presentation Layer',
      subtitle: 'UI, Widgets & State Management',
      icon: Icons.phone_android_rounded,
      color: Color(0xFF00E5FF),
      description:
          'Houses Flutter UI widgets, design system tokens, and BLoC/Cubit state machines. Consumes Domain UseCases without knowing where data originates.',
      components: ['BlocBuilder / BlocConsumer', 'Custom Responsive Widgets', 'UI Event Dispatchers', 'Localization & Themes'],
      codeSample: '''// Presentation: BLoC emitting immutable UI States
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrderUseCase placeOrderUseCase;

  OrderBloc({required this.placeOrderUseCase}) : super(OrderInitial()) {
    on<SubmitOrderEvent>((event, emit) async {
      emit(OrderLoading());
      final result = await placeOrderUseCase(event.params);
      result.fold(
        (failure) => emit(OrderError(failure.message)),
        (order) => emit(OrderSuccess(order)),
      );
    });
  }
}''',
    ),
    (
      title: 'Domain Layer (Core)',
      subtitle: 'Pure Dart Business Rules & Contracts',
      icon: Icons.shield_rounded,
      color: Color(0xFF10B981),
      description:
          'The innermost layer. Contains pure Dart Business Entities, UseCases, and Repository interfaces. Has 0 external framework dependencies.',
      components: ['Pure Dart Entities', 'UseCase Interactors', 'Repository Contracts', 'Failure & Exception Types'],
      codeSample: '''// Domain: Pure Dart UseCase with zero framework coupling
abstract class OrderRepository {
  Future<Either<Failure, Order>> placeOrder(OrderParams params);
}

class PlaceOrderUseCase implements UseCase<Order, OrderParams> {
  final OrderRepository repository;
  PlaceOrderUseCase(this.repository);

  @override
  Future<Either<Failure, Order>> call(OrderParams params) {
    return repository.placeOrder(params);
  }
}''',
    ),
    (
      title: 'Data Layer',
      subtitle: 'Repositories, APIs, Dio & Hive Cache',
      icon: Icons.storage_rounded,
      color: Color(0xFFA855F7),
      description:
          'Implements Domain Repository contracts. Manages REST APIs via Dio interceptors, Firebase, WebSockets, and offline persistence via Hive/SQLite.',
      components: ['Repository Impl', 'Remote DataSource (Dio)', 'Local DataSource (Hive)', 'JSON Mappers & DTOs'],
      codeSample: '''// Data: Repository Implementation coordinating Remote & Cache
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, Order>> placeOrder(OrderParams params) async {
    try {
      final model = await remoteDataSource.postOrder(params.toModel());
      await localDataSource.cacheOrder(model);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final layer = _layers[_selectedLayer];
    final isDesktop = MediaQuery.sizeOf(context).width > 920;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .04),
            blurRadius: 36,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header / Layer Selector Tabs
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 650;
                return Flex(
                  direction: isNarrow ? Axis.vertical : Axis.horizontal,
                  children: List.generate(_layers.length, (index) {
                    final l = _layers[index];
                    final isSelected = _selectedLayer == index;
                    return Expanded(
                      flex: isNarrow ? 0 : 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: InkWell(
                          onTap: () => setState(() => _selectedLayer = index),
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.surface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? l.color.withValues(alpha: .8)
                                    : Colors.transparent,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: l.color.withValues(alpha: .15),
                                        blurRadius: 16,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  l.icon,
                                  size: 18,
                                  color: isSelected ? l.color : AppColors.textDim,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    l.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isSelected ? AppColors.text : AppColors.textMuted,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          // Content body
          Padding(
            padding: const EdgeInsets.all(28),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _buildLayerDescription(layer)),
                      const SizedBox(width: 32),
                      Expanded(flex: 6, child: _buildCodeInspector(layer)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLayerDescription(layer),
                      const SizedBox(height: 24),
                      _buildCodeInspector(layer),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerDescription(dynamic layer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (layer.color as Color).withValues(alpha: .12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(layer.icon as IconData, color: layer.color as Color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    layer.title as String,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    layer.subtitle as String,
                    style: TextStyle(
                      color: layer.color as Color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          layer.description as String,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14.5,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'KEY RESPONSIBILITIES & ARTIFACTS',
          style: TextStyle(
            color: AppColors.textDim,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: (layer.components as List<String>)
              .map(
                (c) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline_rounded,
                          size: 14, color: layer.color as Color),
                      const SizedBox(width: 7),
                      Text(
                        c,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCodeInspector(dynamic layer) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDeep,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Container(width: 9, height: 9, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 9, height: 9, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 9, height: 9, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(width: 14),
                Text(
                  '${(layer.title as String).toLowerCase().replaceAll(' ', '_')}_example.dart',
                  style: const TextStyle(
                    color: AppColors.textDim,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: SelectableText(
              layer.codeSample as String,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.5,
                height: 1.5,
                color: (layer.color as Color).withValues(alpha: .9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
