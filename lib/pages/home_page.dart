import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/architecture_visualizer.dart';
import '../widgets/cairo_clock_widget.dart';
import '../widgets/cursor_glow_tracker.dart';
import '../widgets/hero_visual.dart';
import '../widgets/magic_particles_background.dart';
import '../widgets/project_card.dart';
import '../widgets/reveal.dart';
import '../widgets/section_title.dart';
import '../widgets/toast_notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _heroKey = GlobalKey();
  final _architectureKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _contactKey = GlobalKey();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _selectedSkillCategoryIndex = 0;
  double _scrollProgress = 0.0;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    setState(() {
      _scrollProgress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
      _showBackToTop = currentScroll > 400;
    });
  }

  Future<void> _goTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      alignment: 0.06,
    );
  }

  Future<void> _launch(String value) async {
    final uri = Uri.parse(value);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ToastNotification.show(
      context,
      message: '$label copied to clipboard! ✨',
      icon: Icons.copy_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return Scaffold(
          floatingActionButton: _showBackToTop
              ? _BackToTopButton(
                  progress: _scrollProgress,
                  onTap: () => _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 650),
                    curve: Curves.easeInOutCubic,
                  ),
                )
              : null,
          body: SelectionArea(
            child: CursorGlowTracker(
              child: Stack(
                children: [
                  const Positioned.fill(child: MagicParticlesBackground()),
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      _buildNavbar(context),
                      SliverToBoxAdapter(key: _heroKey, child: _hero(context)),
                      SliverToBoxAdapter(key: _architectureKey, child: _architectureSection(context)),
                      SliverToBoxAdapter(key: _projectsKey, child: _projectsSection(context)),
                      SliverToBoxAdapter(key: _skillsKey, child: _skillsSection(context)),
                      SliverToBoxAdapter(key: _experienceKey, child: _experienceSection(context)),
                      SliverToBoxAdapter(key: _contactKey, child: _contactSection(context)),
                      const SliverToBoxAdapter(child: _Footer()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavbar(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 980;

    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.background.withValues(alpha: .90),
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 78,
      titleSpacing: 0,
      title: _PageWidth(
        child: Row(
          children: [
            InkWell(
              onTap: () => _goTo(_heroKey),
              borderRadius: BorderRadius.circular(12),
              child: const _Logo(),
            ),
            const Spacer(),
            if (isDesktop) ...[
              _NavButton('Architecture', () => _goTo(_architectureKey)),
              _NavButton('Projects', () => _goTo(_projectsKey)),
              _NavButton('Skills & Stack', () => _goTo(_skillsKey)),
              _NavButton('Experience', () => _goTo(_experienceKey)),
              const SizedBox(width: 14),
              const _PaletteDropdown(),
              const SizedBox(width: 14),
              _PrimaryButton(
                label: 'Let\'s Talk',
                icon: Icons.send_rounded,
                onTap: () => _goTo(_contactKey),
              ),
            ] else ...[
              const _PaletteDropdown(),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _goTo(_contactKey),
                icon: const Icon(Icons.mail_outline_rounded, color: AppColors.text),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 1. HERO SECTION
  Widget _hero(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 960;

    return _PageWidth(
      child: Padding(
        padding: EdgeInsets.only(top: isMobile ? 50 : 100, bottom: isMobile ? 80 : 120),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _heroCopy(context, isMobile: true),
                  const SizedBox(height: 60),
                  const Center(child: HeroVisual()),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 12, child: _heroCopy(context)),
                  const SizedBox(width: 50),
                  const Expanded(flex: 10, child: Center(child: HeroVisual())),
                ],
              ),
      ),
    );
  }

  Widget _heroCopy(BuildContext context, {bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.primary.withValues(alpha: .4)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .12),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'AVAILABLE FOR FLUTTER OPPORTUNITIES',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 10.5,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alsaeed Mandor',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: isMobile ? 22 : 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              _TypewriterHeadline(isMobile: isMobile),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Reveal(
          delay: const Duration(milliseconds: 180),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              PortfolioData.summary,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: isMobile ? 15.5 : 17,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 34),
        Reveal(
          delay: const Duration(milliseconds: 260),
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _PrimaryButton(
                label: 'Explore Projects',
                icon: Icons.rocket_launch_rounded,
                onTap: () => _goTo(_projectsKey),
              ),
              _SecondaryButton(
                label: 'LinkedIn',
                icon: Icons.work_outline_rounded,
                onTap: () => _launch(PortfolioData.linkedinUrl),
              ),
              _SecondaryButton(
                label: 'GitHub',
                icon: Icons.code_rounded,
                onTap: () => _launch(PortfolioData.githubUrl),
              ),
              _SecondaryButton(
                label: 'WhatsApp',
                icon: Icons.chat_rounded,
                onTap: () => _launch('https://wa.me/${PortfolioData.whatsapp}'),
              ),
              _SecondaryButton(
                label: 'Copy Email',
                icon: Icons.copy_rounded,
                onTap: () => _copyToClipboard(PortfolioData.email, 'Email address'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Reveal(
          delay: const Duration(milliseconds: 340),
          child: Wrap(
            spacing: 28,
            runSpacing: 18,
            children: PortfolioData.keyMetrics
                .map(
                  (m) => _StatCard(
                    value: m.value,
                    label: m.label,
                    highlight: m.highlight,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // 2. CLEAN ARCHITECTURE SECTION
  Widget _architectureSection(BuildContext context) {
    return const _Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            eyebrow: 'Architecture & Engineering',
            title: 'Engineering Beyond the UI',
            description:
                'Clean separation of concerns, testable business usecases, and robust repository contracts ensure apps remain maintainable and fast as products scale.',
          ),
          SizedBox(height: 40),
          Reveal(
            delay: Duration(milliseconds: 120),
            child: ArchitectureVisualizer(),
          ),
        ],
      ),
    );
  }

  // 3. PROJECTS SECTION WITH FILTERING & SEARCH
  Widget _projectsSection(BuildContext context) {
    final categories = ['All', 'Education', 'Local Services', 'Consultation', 'Legal Tech', 'Ride-Hailing', 'E-Learning', 'Enterprise'];

    final filteredProjects = PortfolioData.projects.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          (p.arabicTitle != null && p.arabicTitle!.contains(query)) ||
          p.tags.any((tag) => tag.toLowerCase().contains(query)) ||
          p.category.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1180 ? 3 : width >= 720 ? 2 : 1;
    const gap = 22.0;

    return _Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SectionTitle(
                  eyebrow: 'Selected Work',
                  title: 'Production Applications & Systems',
                  description:
                      'A portfolio of real-world apps across Education, Legal Tech, Ride-Hailing, Consultation, and Enterprise domains.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Filters & Search Bar
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 750;
              final searchField = SizedBox(
                width: isNarrow ? double.infinity : 280,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: AppColors.text, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search stack or title (e.g. BLoC, Maps)...',
                    hintStyle: const TextStyle(color: AppColors.textDim, fontSize: 12),
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary, size: 18),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              );

              return isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        searchField,
                        const SizedBox(height: 14),
                        _buildCategoryPills(categories),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildCategoryPills(categories)),
                        const SizedBox(width: 18),
                        searchField,
                      ],
                    );
            },
          ),
          const SizedBox(height: 36),

          // Projects Grid
          if (filteredProjects.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(48),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textDim),
                  const SizedBox(height: 14),
                  Text('No projects found matching "$_searchQuery"',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 15)),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: List.generate(
                    filteredProjects.length,
                    (index) => SizedBox(
                      width: cardWidth,
                      height: 365,
                      child: Reveal(
                        delay: Duration(milliseconds: 50 * (index % columns)),
                        child: ProjectCard(project: filteredProjects[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryPills(List<String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedCategory = cat),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? AppColors.backgroundDeep : AppColors.textMuted,
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 4. SKILLS SECTION
  Widget _skillsSection(BuildContext context) {
    final categories = PortfolioData.skillCategories;
    final currentCategory = categories[_selectedSkillCategoryIndex];

    return _Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: 'Stack & Mastery',
            title: 'Technical Arsenal & Best Practices',
            description:
                'Hands-on expertise across architecture, state management, reactive streams, networking, maps, local storage, and payment integrations.',
          ),
          const SizedBox(height: 36),

          // Category Selector Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (index) {
                final c = categories[index];
                final isSelected = _selectedSkillCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () => setState(() => _selectedSkillCategoryIndex = index),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: .14) : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(c.icon, size: 18, color: isSelected ? AppColors.primary : AppColors.textDim),
                          const SizedBox(width: 10),
                          Text(
                            c.name,
                            style: TextStyle(
                              color: isSelected ? AppColors.text : AppColors.textMuted,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 28),

          // Skills Cards in Selected Category
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 780;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 2 : 1,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  mainAxisExtent: 135,
                ),
                itemCount: currentCategory.skills.length,
                itemBuilder: (context, index) {
                  final skill = currentCategory.skills[index];
                  return Reveal(
                    delay: Duration(milliseconds: index * 60),
                    child: _SkillDetailCard(skill: skill),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // 5. EXPERIENCE & EDUCATION SECTION
  Widget _experienceSection(BuildContext context) {
    return _Section(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 900;

          final experienceColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                eyebrow: 'Career Timeline',
                title: 'Professional Experience',
              ),
              const SizedBox(height: 36),
              ...List.generate(
                PortfolioData.experience.length,
                (index) {
                  final item = PortfolioData.experience[index];
                  return Reveal(
                    delay: Duration(milliseconds: index * 100),
                    child: _TimelineItem(
                      company: item.company,
                      role: item.role,
                      location: item.location,
                      period: item.period,
                      highlights: item.highlights,
                      stack: item.stack,
                      last: index == PortfolioData.experience.length - 1,
                    ),
                  );
                },
              ),
            ],
          );

          final educationCard = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(
                eyebrow: 'Academic Foundation',
                title: 'Education & Honors',
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .06),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(Icons.school_rounded, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'B.Sc. Computer Science',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Graduation: 2022',
                                style: TextStyle(color: AppColors.secondary, fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Mansoura University\nFaculty of Computers & Information',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 14),
                    const Text(
                      'CORE ACADEMIC RIGOR',
                      style: TextStyle(
                        color: AppColors.textDim,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        'Data Structures',
                        'Algorithms Analysis',
                        'OOP & SOLID',
                        'Software Engineering',
                        'Database Systems',
                        'Computer Networks',
                      ].map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const CairoClockWidget(),
            ],
          );

          return isNarrow
              ? Column(
                  children: [
                    experienceColumn,
                    const SizedBox(height: 50),
                    educationCard,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: experienceColumn),
                    const SizedBox(width: 60),
                    Expanded(flex: 2, child: educationCard),
                  ],
                );
        },
      ),
    );
  }

  // 6. CONTACT SECTION
  Widget _contactSection(BuildContext context) {
    return _Section(
      bottom: 80,
      child: Container(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 700 ? 26 : 56),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: AppColors.primary.withValues(alpha: .3)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: .12),
              AppColors.surface,
              AppColors.backgroundDeep,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .12),
              blurRadius: 50,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                _MiniLabel('LET\'S CONNECT & BUILD TOGETHER'),
                Spacer(),
                CairoClockWidget(),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Have a mobile project\nor role in mind?',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                'I am available for Mid-Senior Flutter engineering roles, enterprise architecture consulting, and high-impact product launches.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _PrimaryButton(
                  label: PortfolioData.email,
                  icon: Icons.mail_rounded,
                  onTap: () => _launch('mailto:${PortfolioData.email}'),
                ),
                _SecondaryButton(
                  label: 'LinkedIn Profile',
                  icon: Icons.work_outline_rounded,
                  onTap: () => _launch(PortfolioData.linkedinUrl),
                ),
                _SecondaryButton(
                  label: 'GitHub Profile',
                  icon: Icons.code_rounded,
                  onTap: () => _launch(PortfolioData.githubUrl),
                ),
                _SecondaryButton(
                  label: 'WhatsApp Chat',
                  icon: Icons.chat_rounded,
                  onTap: () => _launch('https://wa.me/${PortfolioData.whatsapp}'),
                ),
                _SecondaryButton(
                  label: PortfolioData.phone,
                  icon: Icons.phone_rounded,
                  onTap: () => _launch('tel:${PortfolioData.phone.replaceAll(' ', '')}'),
                ),
                _SecondaryButton(
                  label: 'Copy Email',
                  icon: Icons.copy_rounded,
                  onTap: () => _copyToClipboard(PortfolioData.email, 'Email address'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// TYPEWRITER ANIMATED HEADLINE
class _TypewriterHeadline extends StatefulWidget {
  const _TypewriterHeadline({required this.isMobile});
  final bool isMobile;

  @override
  State<_TypewriterHeadline> createState() => _TypewriterHeadlineState();
}

class _TypewriterHeadlineState extends State<_TypewriterHeadline> {
  static const _roles = [
    'Building Scalable Mobile Apps.',
    'Clean Architecture & SOLID Specialist.',
    'Reactive BLoC & High-Performance UX.',
    'Crafting Production Flutter Ecosystems.',
  ];

  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 3200), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _roles.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) {
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(anim),
            child: child,
          ),
        );
      },
      child: Text(
        _roles[_currentIndex],
        key: ValueKey(_currentIndex),
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: widget.isMobile ? 38 : 58,
              height: 1.1,
            ),
      ),
    );
  }
}

// STAT CARD
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.highlight,
  });

  final String value;
  final String label;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            highlight,
            style: const TextStyle(color: AppColors.textDim, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// SKILL DETAIL CARD
class _SkillDetailCard extends StatefulWidget {
  const _SkillDetailCard({required this.skill});
  final ({String name, String level, String description}) skill;

  @override
  State<_SkillDetailCard> createState() => _SkillDetailCardState();
}

class _SkillDetailCardState extends State<_SkillDetailCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered ? AppColors.primary.withValues(alpha: .7) : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .1),
                    blurRadius: 20,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.skill.name,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.skill.level,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                widget.skill.description,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12.5,
                  height: 1.45,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TIMELINE ITEM
class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.company,
    required this.role,
    required this.location,
    required this.period,
    required this.highlights,
    required this.stack,
    required this.last,
  });

  final String company;
  final String role;
  final String location;
  final String period;
  final List<String> highlights;
  final List<String> stack;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!last)
          Positioned(
            top: 20,
            bottom: 0,
            left: 6,
            child: Container(
              width: 2,
              color: AppColors.border,
            ),
          ),
        Positioned(
          top: 6,
          left: 0,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: .6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 36, bottom: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              company,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              role,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          period,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(location, style: const TextStyle(color: AppColors.textDim, fontSize: 12.5)),
                  const SizedBox(height: 14),
                  ...highlights.map(
                    (h) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Icon(Icons.arrow_right_rounded, color: AppColors.primary, size: 18),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              h,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 13.5, height: 1.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: stack
                        .map(
                          (s) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              s,
                              style: const TextStyle(color: AppColors.textDim, fontSize: 10.5, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    }

// PALETTE DROPDOWN
class _PaletteDropdown extends StatelessWidget {
  const _PaletteDropdown();

  @override
  Widget build(BuildContext context) {
    final current = ThemeController.instance.palette;

    return PopupMenuButton<AccentPalette>(
      tooltip: 'Change Theme Accent',
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      initialValue: current,
      onSelected: (palette) {
        ThemeController.instance.setPalette(palette);
        ToastNotification.show(
          context,
          message: 'Switched accent to ${palette.label}! ✨',
          icon: Icons.palette_rounded,
        );
      },
      itemBuilder: (context) => AccentPalette.values
          .map(
            (p) => PopupMenuItem<AccentPalette>(
              value: p,
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    p.label,
                    style: TextStyle(
                      color: p == current ? AppColors.text : AppColors.textMuted,
                      fontWeight: p == current ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: current.primary, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.palette_outlined, size: 16, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// BACK TO TOP PROGRESS BUTTON
class _BackToTopButton extends StatelessWidget {
  const _BackToTopButton({required this.progress, required this.onTap});
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: onTap,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 2.5,
            color: AppColors.primary,
            backgroundColor: AppColors.border,
          ),
          const Icon(Icons.arrow_upward_rounded, size: 18),
        ],
      ),
    );
  }
}

// COMMON PAGE WIDTH & BUTTON HELPERS
class _PageWidth extends StatelessWidget {
  const _PageWidth({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1240),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width < 700 ? 22 : 38,
        ),
        child: child,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child, this.bottom = 120});
  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return _PageWidth(
      child: Padding(
        padding: EdgeInsets.only(top: 48, bottom: bottom),
        child: child,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withValues(alpha: .4)),
          ),
          child: const Text(
            'AM',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ALSAEED MANDOR',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                fontSize: 13,
              ),
            ),
            Text(
              'Mid-Senior Flutter Developer',
              style: TextStyle(
                color: AppColors.secondary,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textMuted,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 17),
      label: Text(label),
      style: FilledButton.styleFrom(
        foregroundColor: AppColors.backgroundDeep,
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 17),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
      ),
    );
  }
}

class _MiniLabel extends StatelessWidget {
  const _MiniLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 11,
        letterSpacing: 1.8,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return _PageWidth(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          children: [
            const Divider(color: AppColors.border),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  '© 2026 Alsaeed Mohamed Mandor. All rights reserved.',
                  style: TextStyle(color: AppColors.textDim, fontSize: 12),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Built with Flutter & Clean Architecture',
                      style: TextStyle(
                        color: AppColors.primary.withValues(alpha: .9),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
