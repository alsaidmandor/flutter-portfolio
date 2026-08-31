import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HeroVisual extends StatefulWidget {
  const HeroVisual({super.key});

  @override
  State<HeroVisual> createState() => _HeroVisualState();
}

class _HeroVisualState extends State<HeroVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _activeTab = 0; // 0: Live App Demo, 1: Clean Code, 2: Telemetry

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, ThemeController.instance]),
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return Transform.translate(
          offset: Offset(0, math.sin(t * math.pi) * -8),
          child: child,
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Ambient Glow behind device
          Positioned(
            child: Container(
              width: 380,
              height: 480,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .18),
                    blurRadius: 70,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
          ),

          // Main Device Mockup Shell
          Container(
            width: 400,
            height: 520,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: .4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .6),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Column(
                children: [
                  // Top Device Status Bar & Tab Switcher
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceSoft,
                      border: Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        // macOS dots
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
                            const SizedBox(width: 5),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                            const SizedBox(width: 5),
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
                          ],
                        ),
                        const Spacer(),
                        // Mode Switcher Pills
                        _ModePill(
                          title: 'App Demo',
                          icon: Icons.smartphone_rounded,
                          active: _activeTab == 0,
                          onTap: () => setState(() => _activeTab = 0),
                        ),
                        const SizedBox(width: 6),
                        _ModePill(
                          title: 'Code',
                          icon: Icons.code_rounded,
                          active: _activeTab == 1,
                          onTap: () => setState(() => _activeTab = 1),
                        ),
                        const SizedBox(width: 6),
                        _ModePill(
                          title: 'Radar',
                          icon: Icons.speed_rounded,
                          active: _activeTab == 2,
                          onTap: () => setState(() => _activeTab = 2),
                        ),
                      ],
                    ),
                  ),

                  // Screen Content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      child: switch (_activeTab) {
                        0 => const _InteractiveAppDemo(),
                        1 => const _CodeCard(),
                        _ => const _TelemetryView(),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Badges around device
          const Positioned(
            left: -42,
            bottom: 48,
            child: _FloatingBadge(
              icon: Icons.architecture_rounded,
              title: 'Clean Arch',
              subtitle: 'SOLID & Pure Domain',
            ),
          ),
          const Positioned(
            right: -36,
            top: 54,
            child: _FloatingBadge(
              icon: Icons.flash_on_rounded,
              title: '60 FPS Ultra',
              subtitle: 'Smooth Reactive BLoC',
            ),
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.title,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: active ? AppColors.backgroundDeep : AppColors.textDim,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: active ? AppColors.backgroundDeep : AppColors.textDim,
                fontSize: 11,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 1. LIVE INTERACTIVE FLUTTER APP DEMO
class _InteractiveAppDemo extends StatefulWidget {
  const _InteractiveAppDemo();

  @override
  State<_InteractiveAppDemo> createState() => _InteractiveAppDemoState();
}

class _InteractiveAppDemoState extends State<_InteractiveAppDemo> {
  int _itemsCount = 3;
  bool _isProcessing = false;
  String _selectedCategory = 'All';

  void _triggerBlocAction() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _itemsCount++;
          _isProcessing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDeep,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Madariscom Dashboard',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Live BLoC State Simulator',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt_rounded, size: 12, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      'State: $_itemsCount',
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Categories Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Exams', 'Assignments', 'Fees'].map((cat) {
                final active = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCategory = cat),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary.withValues(alpha: .18) : AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: active ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: active ? AppColors.primary : AppColors.textDim,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Card List Preview
          Expanded(
            child: ListView(
              children: [
                _DemoFeedCard(
                  title: 'Term 1 Mathematics Final',
                  badge: 'Exam Alert',
                  badgeColor: AppColors.primary,
                  time: 'Tomorrow, 09:00 AM',
                ),
                const SizedBox(height: 8),
                _DemoFeedCard(
                  title: 'Clean Architecture Physics Lab',
                  badge: 'Assignment',
                  badgeColor: AppColors.secondary,
                  time: 'Due Friday',
                ),
                const SizedBox(height: 8),
                const _DemoFeedCard(
                  title: 'Tuition Fee Settlement Invoice',
                  badge: 'Paid via Stripe',
                  badgeColor: Color(0xFF10B981),
                  time: 'Confirmed',
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          // Interactive Action Button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isProcessing ? null : _triggerBlocAction,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : const Icon(Icons.touch_app_rounded, size: 16),
              label: Text(_isProcessing ? 'Dispatching BLoC Event...' : 'Dispatch Reactive Event (+1)'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.backgroundDeep,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoFeedCard extends StatelessWidget {
  const _DemoFeedCard({
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.time,
  });

  final String title;
  final String badge;
  final Color badgeColor;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  badge,
                  style: TextStyle(color: badgeColor, fontSize: 9.5, fontWeight: FontWeight.w800),
                ),
              ),
              Text(time, style: const TextStyle(color: AppColors.textDim, fontSize: 9.5)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// 2. CODE CARD
class _CodeCard extends StatelessWidget {
  const _CodeCard();

  @override
  Widget build(BuildContext context) {
    final lines = <({String text, Color color})>[
      (text: 'class AlsaeedDeveloper {', color: AppColors.primary),
      (text: '  final exp = "3+ Years Production";', color: AppColors.text),
      (text: '  final arch = "Clean Architecture";', color: AppColors.secondary),
      (text: '  final state = "BLoC / Cubit / Provider";', color: AppColors.text),
      (text: '  final payments = ["Stripe", "HyperPay"];', color: AppColors.secondary),
      (text: '  final networking = "Dio + Retrofit";', color: AppColors.text),
      (text: '', color: AppColors.text),
      (text: '  Future<void> shipApp() async {', color: AppColors.primary),
      (text: '    await applySolidPrinciples();', color: AppColors.text),
      (text: '    await ensure60FpsNoMemoryLeaks();', color: AppColors.secondary),
      (text: '  }', color: AppColors.primary),
      (text: '}', color: AppColors.primary),
    ];

    return Container(
      color: AppColors.backgroundDeep,
      padding: const EdgeInsets.all(18),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Text(
                line.text,
                style: TextStyle(
                  color: line.color,
                  fontFamily: 'monospace',
                  fontSize: 11.8,
                  height: 1.3,
                ),
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}

// 3. TELEMETRY VIEW
class _TelemetryView extends StatelessWidget {
  const _TelemetryView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundDeep,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ENGINEERING TELEMETRY',
            style: TextStyle(
              color: AppColors.textDim,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          const _MetricRow(
            label: 'Frame Rate Status',
            value: '60.0 FPS Stable',
            color: Color(0xFF10B981),
            icon: Icons.speed_rounded,
          ),
          const SizedBox(height: 10),
          _MetricRow(
            label: 'Architecture Separation',
            value: '100% Decoupled',
            color: AppColors.primary,
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(height: 10),
          _MetricRow(
            label: 'Memory Leak Audit',
            value: '0 Leaks Detected',
            color: AppColors.secondary,
            icon: Icons.memory_rounded,
          ),
          const SizedBox(height: 10),
          const _MetricRow(
            label: 'Code Coverage Ready',
            value: 'Unit & BLoC Tested',
            color: Color(0xFFF59E0B),
            icon: Icons.verified_user_rounded,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_rounded, color: AppColors.secondary, size: 18),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Production-ready mobile architecture tuned for maximum stability and instant user responsiveness.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10.5, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: .95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: .4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 11.5,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textDim, fontSize: 9.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

