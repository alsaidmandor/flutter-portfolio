class PortfolioProject {
  const PortfolioProject({
    required this.title,
    required this.category,
    required this.description,
    required this.tags,
    required this.icon,
    this.arabicTitle,
    this.role = 'Mobile Developer',
    this.architecture = 'Clean Architecture + BLoC',
    this.keyHighlights = const [],
    this.challengesAndSolutions = const [],
    this.metrics = const [],
    this.isFeatured = false,
    this.playStoreUrl,
    this.appStoreUrl,
    this.demoUrl,
  });

  final String title;
  final String? arabicTitle;
  final String category;
  final String description;
  final List<String> tags;
  final String icon;
  final String role;
  final String architecture;
  final List<String> keyHighlights;
  final List<String> challengesAndSolutions;
  final List<String> metrics;
  final bool isFeatured;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? demoUrl;
}

