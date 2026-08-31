import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CursorGlowTracker extends StatefulWidget {
  const CursorGlowTracker({super.key, required this.child});

  final Widget child;

  @override
  State<CursorGlowTracker> createState() => _CursorGlowTrackerState();
}

class _CursorGlowTrackerState extends State<CursorGlowTracker> {
  Offset _pointerPosition = const Offset(-1000, -1000);
  bool _inside = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _pointerPosition = event.localPosition;
          _inside = true;
        });
      },
      onExit: (_) {
        setState(() => _inside = false);
      },
      child: Stack(
        children: [
          if (_inside)
            Positioned(
              left: _pointerPosition.dx - 220,
              top: _pointerPosition.dy - 220,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: ThemeController.instance,
                  builder: (context, _) {
                    return Container(
                      width: 440,
                      height: 440,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: .06),
                            AppColors.secondary.withValues(alpha: .02),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}
