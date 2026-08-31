import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/project.dart';
import '../theme/app_theme.dart';
import 'project_detail_modal.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key, required this.project});

  final PortfolioProject project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFeatured = widget.project.isFeatured;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => ProjectDetailModal.show(context, widget.project),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0.0, _hovered ? -8.0 : 0.0, 0.0),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isFeatured
                ? (_hovered
                    ? AppColors.surfaceSoft
                    : AppColors.surface.withValues(alpha: .95))
                : (_hovered ? AppColors.surfaceSoft : AppColors.surface),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isFeatured
                  ? (_hovered
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: .5))
                  : (_hovered
                      ? AppColors.primary.withValues(alpha: .75)
                      : AppColors.border),
              width: isFeatured ? (_hovered ? 2.0 : 1.5) : (_hovered ? 1.5 : 1.0),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: isFeatured
                          ? AppColors.primary.withValues(alpha: .28)
                          : AppColors.primary.withValues(alpha: .16),
                      blurRadius: isFeatured ? 44 : 36,
                      offset: const Offset(0, 16),
                      spreadRadius: isFeatured ? 3 : 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: isFeatured
                          ? AppColors.primary.withValues(alpha: .1)
                          : Colors.black26,
                      blurRadius: isFeatured ? 18 : 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Top: Number badge + Featured Tag + Category Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isFeatured
                          ? AppColors.primary
                          : (_hovered
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: .12)),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: isFeatured
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: .4),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      widget.project.icon,
                      style: TextStyle(
                        color: isFeatured
                            ? AppColors.backgroundDeep
                            : (_hovered ? AppColors.backgroundDeep : AppColors.primary),
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isFeatured) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: .25),
                                AppColors.secondary.withValues(alpha: .25),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.primary.withValues(alpha: .6)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded, size: 12, color: Colors.amberAccent),
                              SizedBox(width: 4),
                              Text(
                                'MAIN FEATURED',
                                style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (widget.project.playStoreUrl != null || widget.project.appStoreUrl != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: .15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: .4)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.storefront_rounded, size: 12, color: Color(0xFF10B981)),
                              SizedBox(width: 4),
                              Text(
                                'LIVE APP',
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.secondary.withValues(alpha: .3)),
                        ),
                        child: Text(
                          widget.project.category,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title and Arabic Title
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.project.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: _hovered || isFeatured ? AppColors.primary : AppColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                  if (widget.project.arabicTitle != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      widget.project.arabicTitle!,
                      style: const TextStyle(
                        color: AppColors.textDim,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),

              // Description
              Expanded(
                child: Text(
                  widget.project.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 14),

              // Tech tags
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.project.tags
                    .take(4)
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDeep.withValues(alpha: .8),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Bottom Store Icons & "Explore Case Study" indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Direct Store Quick Access Buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.project.playStoreUrl != null)
                        InkWell(
                          onTap: () => _openUrl(widget.project.playStoreUrl!),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF01875F).withValues(alpha: .18),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF01875F).withValues(alpha: .4)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shop_two_rounded, size: 13, color: Color(0xFF34D399)),
                                SizedBox(width: 4),
                                Text(
                                  'Google Play',
                                  style: TextStyle(
                                    color: Color(0xFF34D399),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (widget.project.appStoreUrl != null)
                        InkWell(
                          onTap: () => _openUrl(widget.project.appStoreUrl!),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0071E3).withValues(alpha: .18),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF0071E3).withValues(alpha: .4)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.apple_rounded, size: 13, color: Color(0xFF60A5FA)),
                                SizedBox(width: 4),
                                Text(
                                  'App Store',
                                  style: TextStyle(
                                    color: Color(0xFF60A5FA),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Explore link
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Details',
                        style: TextStyle(
                          color: _hovered || isFeatured ? AppColors.primary : AppColors.textDim,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedSlide(
                        offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: _hovered || isFeatured ? AppColors.primary : AppColors.textDim,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


