import 'package:flutter/material.dart';
import '../models/project.dart';

class SkillCategory {
  const SkillCategory({
    required this.name,
    required this.icon,
    required this.skills,
  });

  final String name;
  final IconData icon;
  final List<({String name, String level, String description})> skills;
}

abstract final class PortfolioData {
  static const name = 'Alsaeed Mohamed Mandor';
  static const role = 'Mid-Senior Flutter Developer';
  static const location = 'Cairo, Egypt';
  static const email = 'alsaidmandor8888@gmail.com';
  static const phone = '+20 1559847533';
  static const whatsapp = '+201559847533';

  static const githubUrl = 'https://github.com/alsaidmandor';
  static const linkedinUrl = 'https://www.linkedin.com/in/alsaeid-mandor-a9675a330';

  static const summary =
      'Passionate Flutter Engineer with 3+ years of enterprise mobile experience crafting scalable, robust, high-performance applications. Master of Clean Architecture, SOLID principles, BLoC/Cubit state management, and seamless integrations across REST APIs, Firebase, Google Maps, offline persistence, and multi-gateway payments.';

  static const keyMetrics = [
    (value: '3+', label: 'Years Experience', highlight: 'Enterprise & Startups'),
    (value: '9+', label: 'Production Apps', highlight: 'Consultation, Education, Rides'),
    (value: '100%', label: 'Clean Architecture', highlight: 'Testable & Maintainable'),
    (value: '60 FPS', label: 'Smooth UX', highlight: 'Zero Lag & Leak-Free'),
  ];

  static const skillCategories = <SkillCategory>[
    SkillCategory(
      name: 'Architecture & Patterns',
      icon: Icons.account_tree_rounded,
      skills: [
        (
          name: 'Clean Architecture',
          level: 'Expert',
          description: 'Strict separation of Presentation, Domain (pure Dart usecases), and Data layers.',
        ),
        (
          name: 'SOLID Principles',
          level: 'Expert',
          description: 'Single responsibility, open-closed, Liskov substitution, interface segregation, DI.',
        ),
        (
          name: 'Design Patterns',
          level: 'Advanced',
          description: 'Factory, Singleton, Repository, Adapter, Observer, and Strategy implementations.',
        ),
        (
          name: 'Repository Pattern',
          level: 'Expert',
          description: 'Abstract contracts decoupling business logic from concrete remote/local data sources.',
        ),
      ],
    ),
    SkillCategory(
      name: 'State Management',
      icon: Icons.stream_rounded,
      skills: [
        (
          name: 'BLoC / Cubit',
          level: 'Expert',
          description: 'Predictable stream-based reactive state management, event transformation & testing.',
        ),
        (
          name: 'Provider',
          level: 'Advanced',
          description: 'Dependency injection and pragmatic scoped state propagation.',
        ),
        (
          name: 'Reactive Programming',
          level: 'Advanced',
          description: 'RxDart, Streams, ValueNotifiers, and state selectors for optimal rebuilds.',
        ),
      ],
    ),
    SkillCategory(
      name: 'Networking & Backend',
      icon: Icons.cloud_sync_rounded,
      skills: [
        (
          name: 'REST APIs & Dio',
          level: 'Expert',
          description: 'Interceptors, automated token refresh, custom retry strategies, and request caching.',
        ),
        (
          name: 'Retrofit & CodeGen',
          level: 'Advanced',
          description: 'Type-safe API clients generated via build_runner with robust error handling.',
        ),
        (
          name: 'Firebase & FCM',
          level: 'Advanced',
          description: 'Cloud Firestore, Auth, Push Notifications, Background messages & Crashlytics.',
        ),
      ],
    ),
    SkillCategory(
      name: 'Storage & Native Tools',
      icon: Icons.storage_rounded,
      skills: [
        (
          name: 'Hive / SQLite',
          level: 'Expert',
          description: 'Lightning-fast NoSQL local database caching with encrypted box support.',
        ),
        (
          name: 'Google Maps API',
          level: 'Advanced',
          description: 'Live polylines, custom marker clustering, geolocation, and geocoding.',
        ),
        (
          name: 'Local Notifications',
          level: 'Advanced',
          description: 'Scheduled reminders, actionable heads-up notifications, and background triggers.',
        ),
        (
          name: 'Localization (i18n)',
          level: 'Expert',
          description: 'RTL/LTR dynamic switching (Arabic/English) with pluralization and locale cache.',
        ),
      ],
    ),
    SkillCategory(
      name: 'Payments & Delivery',
      icon: Icons.payments_rounded,
      skills: [
        (
          name: 'Stripe Integration',
          level: 'Advanced',
          description: 'Payment intents, 3D-Secure authentication, and tokenized checkout sheets.',
        ),
        (
          name: 'HyperPay Gateway',
          level: 'Advanced',
          description: 'Custom checkout UI with Mada, Visa, and Apple Pay payment widgets.',
        ),
        (
          name: 'Git & CI/CD',
          level: 'Advanced',
          description: 'Feature branching, git flow, automated builds, release management.',
        ),
      ],
    ),
  ];

  static const skills = <String>[
    'Flutter',
    'Dart',
    'Java',
    'BLoC / Cubit',
    'Provider',
    'Clean Architecture',
    'SOLID',
    'Design Patterns',
    'REST APIs',
    'Dio',
    'Retrofit',
    'Firebase',
    'FCM',
    'Google Maps',
    'Hive',
    'Localization',
    'Local Notifications',
    'Stripe',
    'HyperPay',
    'Git',
  ];

  static const experience = <({
    String company,
    String role,
    String location,
    String period,
    List<String> highlights,
    List<String> stack,
  })>[
    (
      company: 'Elnooronline',
      role: 'Flutter Developer',
      location: 'Alexandria, Egypt (Remote / Hybrid)',
      period: 'Sep 2025 – Present',
      highlights: [
        'Architecting and shipping high-performance cross-platform Flutter applications using Clean Architecture and BLoC.',
        'Integrating secure payment gateways (HyperPay & Stripe) with multi-currency and tokenized transactions.',
        'Implementing real-time features including live ride-hailing tracking, push notifications, and offline caching.',
        'Refactoring legacy codebases, boosting frame rates to solid 60 FPS and reducing app bundle sizes.',
      ],
      stack: ['Flutter', 'Clean Architecture', 'BLoC', 'Dio', 'HyperPay', 'Google Maps', 'Hive'],
    ),
    (
      company: 'Rmoztec',
      role: 'Mobile Application Developer',
      location: 'Mansoura, Egypt',
      period: 'Jul 2024 – Jul 2025',
      highlights: [
        'Developed and deployed end-to-end mobile applications for education, legal services, and consultation domains.',
        'Collaborated with backend teams to design optimized RESTful contracts and secure JWT authentication workflows.',
        'Integrated Firebase Cloud Messaging (FCM), background sync, and Arabic/English localization.',
        'Maintained 99.8% crash-free session rate across released Google Play & App Store builds.',
      ],
      stack: ['Flutter', 'Dart', 'Provider', 'Cubit', 'Firebase', 'REST APIs', 'Stripe'],
    ),
  ];

  static const projects = <PortfolioProject>[
    // 1. REWAA | رواء (MAIN FEATURED PROJECT)
    PortfolioProject(
      title: 'REWAA',
      arabicTitle: 'رواء',
      category: 'Consultation',
      role: 'Lead Flutter Developer',
      isFeatured: true,
      description:
          'منصة استشارات رائدة تتيح التواصل الفوري والمباشر مع نخبة من الخبراء والمستشارين المتخصصين في مجالات متعددة، مع واجهة مستخدم سهلة وسرية تامة للمحادثات.',
      tags: ['Flutter', 'Clean Arch', 'BLoC', 'Consultation', 'Encrypted Chat', 'Stripe', 'FCM'],
      icon: '01',
      architecture: 'Clean Architecture with BLoC Pattern & Secure WebSocket Chat',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.elnooronline.rewa&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/%D8%B1%D9%88%D8%A7%D8%A1-rewaa/id6502792487',
      keyHighlights: [
        'استشارات فورية: تواصل مع المستشارين المعتمدين في الوقت الذي يناسبك.',
        'خبراء متخصصون: اختيار سلس بين مستشارين ذوي خبرة عميقة في مجالات متعددة.',
        'سهولة الاستخدام: واجهة مستخدم حديثة وسلسة للتنقل وحجز المواعيد.',
        'سرية تامة: تشفير كامل للمحادثات وضمان الخصوصية التامة للبيانات.',
        'بوابات دفع إلكترونية متكاملة وآمنة مع إشعارات فورية للجلسات.',
      ],
      challengesAndSolutions: [
        'التحدي: ضمان الخصوصية والسرية الفائقة للمحادثات مع استجابة فورية. الحل: استخدام تشفير محلي عبر Hive AES وقنوات اتصال مشفرة مع إدارة حالة تفاعلية عبر BLoC.',
      ],
      metrics: ['متوفر على Google Play', 'متوفر على App Store', 'سرية وأمان 100%'],
    ),

    // 2. محامينا
    PortfolioProject(
      title: 'Mohamina',
      arabicTitle: 'محامينا',
      category: 'Legal Tech',
      role: 'Flutter Developer',
      description:
          'On-demand legal services platform empowering clients to submit case briefs, find specialized licensed lawyers by jurisdiction, and book legal consultations.',
      tags: ['Flutter', 'Legal Tech', 'Maps', 'Dio', 'Clean Architecture'],
      icon: '02',
      architecture: 'Clean Architecture with Domain UseCases & Token Interceptors',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.elnooronline.muhamina&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/%D9%85%D8%AD%D8%A7%D9%85%D9%8A%D9%86%D8%A7/id1419653949',
      keyHighlights: [
        'Structured case brief wizard with document attachments and confidentiality agreements.',
        'Lawyer directory with specialty filtering, rating systems, and appointment scheduler.',
        'Integrated calendar sync and legal session reminders via local notifications.',
      ],
      challengesAndSolutions: [
        'Challenge: Complex multi-step case intake flow. Solution: Unified state machine with auto-saving drafts across sessions.',
      ],
      metrics: ['200+ Verified Attorneys', 'Automated Calendar Sync'],
    ),

    // 3. Abber App | عبر
    PortfolioProject(
      title: 'Abber App',
      arabicTitle: 'عبر',
      category: 'Consultation',
      role: 'Flutter Developer',
      description:
          'Premier digital consultation platform connecting verified specialists with users for confidential vision analysis, advisory sessions, and scheduled consultations.',
      tags: ['Flutter', 'Consultation', 'Audio Notes', 'Stripe', 'Cubit'],
      icon: '03',
      architecture: 'Clean Architecture with State Machine & Encrypted Storage',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.app.abber&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/%D8%B9%D8%A8%D8%B1-abber/id6450137342?l=ar',
      keyHighlights: [
        'In-app voice recording, waveform visualization, and asynchronous audio playback.',
        'Confidential end-to-end encrypted messaging and consultation booking engine.',
        'Secure multi-tier consultation pricing with Stripe checkout integration.',
      ],
      challengesAndSolutions: [
        'Challenge: Privacy and data confidentiality. Solution: Ephemeral tokens and localized encrypted storage with Hive AES.',
      ],
      metrics: ['4.9★ Average Rating', 'Secure Payments via Stripe'],
    ),

    // 4. iQTaxi | Taxi Driver & Taxi User App
    PortfolioProject(
      title: 'iQTaxi',
      arabicTitle: 'آي كيو تاكسي',
      category: 'Ride-Hailing',
      role: 'Senior Flutter Developer',
      description:
          'Dual ride-hailing ecosystem providing real-time driver dispatching, live turn-by-turn routing, automated fare metering, and seamless payment collection.',
      tags: ['Flutter', 'Google Maps', 'WebSockets', 'BLoC', 'HyperPay'],
      icon: '04',
      architecture: 'Clean Architecture + WebSocket State Stream + Custom Painter Routes',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.elnooronline.taxi.user&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/iq-taxi/id6757102454',
      keyHighlights: [
        'Smooth driver car movement animation on map utilizing bearing interpolation.',
        'Live fare calculation engine taking traffic, duration, and surge multiplier into account.',
        'Dual app architecture sharing core domain models, repository contracts, and network layers.',
        'Payment gateway integration supporting HyperPay, Mada, and cash workflows.',
      ],
      challengesAndSolutions: [
        'Challenge: Jittery marker animation during real-time GPS tracking. Solution: Custom bezier route interpolator and heading smoothing.',
      ],
      metrics: ['Real-time 60fps Map Tracking', 'Dual Driver/Rider Codebase'],
    ),

    // 5. NOVA X
    PortfolioProject(
      title: 'NOVA X',
      arabicTitle: 'نوفا إكس',
      category: 'E-Learning',
      role: 'Mobile Developer',
      description:
          'Next-generation interactive learning platform offering curated video courses, live streaming masterclasses, quizzes, and downloadable learning certificates.',
      tags: ['Flutter', 'Video Player', 'In-App Purchase', 'Offline Mode'],
      icon: '05',
      architecture: 'Clean Architecture with Custom Video Player Controller & DRM',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.elnooreonline.elms&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/nova-x/id6761002440',
      keyHighlights: [
        'Custom interactive video player with playback speeds, bookmarks, and chapter skips.',
        'Secure encrypted offline lesson downloads preventing unauthorized video extraction.',
        'Dynamic interactive quizzes with immediate score analysis and certificate generation.',
      ],
      challengesAndSolutions: [
        'Challenge: Offline video DRM protection. Solution: Encrypted stream chunking stored in sandboxed app directory.',
      ],
      metrics: ['Offline Video Caching', 'Interactive Chapter Quizzes'],
    ),

    // 6. مدرسة الأوائل
    PortfolioProject(
      title: 'Al-Awael School',
      arabicTitle: 'مدرسة الأوائل',
      category: 'Education',
      role: 'Mobile Developer',
      description:
          'Specialized school portal for study and exam timetables, homework submissions, report cards, fee tracking, and direct teacher-parent conferences.',
      tags: ['Flutter', 'BLoC', 'Dio', 'Notifications', 'Hive'],
      icon: '06',
      architecture: 'Clean Architecture + Repository Pattern + Hive Cache',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.elnooronline.alawael&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/%D9%85%D8%AF%D8%B1%D8%B3%D8%A9-%D8%A7%D9%84%D8%A3%D9%88%D8%A7%D8%A6%D9%84-%D8%A7%D9%84%D8%A3%D9%87%D9%84%D9%8A%D8%A9/id1631025008?l=ar',
      keyHighlights: [
        'Interactive student grade report cards with dynamic visual progress charts.',
        'Document and assignment attachment uploaders with chunked retry mechanisms.',
        'Actionable local push notifications for upcoming exams and assignment deadlines.',
      ],
      challengesAndSolutions: [
        'Challenge: Large PDF syllabus rendering on low-end devices. Solution: Stream-rendered vector previews and lazy memory cleanup.',
      ],
      metrics: ['10+ Schools Onboarded', 'Zero Lag on Low-End Devices'],
    ),

    // 7. مدارسكم
    PortfolioProject(
      title: 'Madariscom',
      arabicTitle: 'مدارسكم',
      category: 'Education',
      role: 'Lead Flutter Developer',
      description:
          'Comprehensive education communication ecosystem linking students, parents, and schools with real-time academic tracking, fee settlements, exams, and instant messaging.',
      tags: ['Flutter', 'Clean Arch', 'BLoC', 'Dio', 'FCM', 'Payments'],
      icon: '07',
      architecture: 'Clean Architecture with BLoC Pattern & Dio Interceptors',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.elnooronline.madaresco&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/your-schools-%D9%85%D8%AF%D8%A7%D8%B1%D8%B3%D9%83%D9%85/id1459034556?l=ar',
      keyHighlights: [
        'Engineered live chat & announcement feed with WebSocket / FCM fallback.',
        'Integrated online fee installment processing via secure payment gateway.',
        'Built full offline timetable and homework cache with Hive local storage.',
        'Supported complete RTL/LTR localization with Arabic academic terminology.',
      ],
      challengesAndSolutions: [
        'Challenge: High latency during school announcement surges. Solution: Cached feeds with optimistic UI updates and background delta sync.',
      ],
      metrics: ['50k+ Active Users', '99.9% Crash-Free', '60 FPS Transitions'],
    ),

    // 8. دليلكم
    PortfolioProject(
      title: 'Dalilkom',
      arabicTitle: 'دليلكم',
      category: 'Local Services',
      role: 'Flutter Developer',
      description:
          'Smart daily-life discovery hub allowing users to explore local businesses, service providers, operational hours, offers, and turn-by-turn navigation.',
      tags: ['Flutter', 'Google Maps', 'Geolocation', 'Cubit', 'REST API'],
      icon: '08',
      architecture: 'Feature-First Clean Architecture with Cubit & Geolocation Service',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.elnooronline.dalilkoom&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/%D8%AF%D9%84%D9%8A%D9%84%D9%83%D9%85-%D8%A7%D9%84%D8%AF%D9%84%D9%8A%D9%84-%D8%A7%D9%84%D8%B4%D8%A7%D9%85%D9%84/id1544250802?l=ar',
      keyHighlights: [
        'Implemented clustered Google Maps markers with custom interactive pin widgets.',
        'Real-time proximity search using radius calculation and location streams.',
        'Interactive business profiles with dynamic reviews, photos, and direct booking.',
        'Fast full-text search with debounce and query caching.',
      ],
      challengesAndSolutions: [
        'Challenge: Battery drain from frequent location updates. Solution: Smart adaptive geofencing and throttle stream listeners.',
      ],
      metrics: ['Instant Nearby Search', 'Clustered 10k+ Points of Interest'],
    ),

    // 9. CHAMBER TABUK | غرفة تبوك
    PortfolioProject(
      title: 'Chamber Tabuk',
      arabicTitle: 'غرفة تبوك',
      category: 'Enterprise',
      role: 'Flutter Developer',
      description:
          'Official enterprise digital portal for Tabuk Chamber of Commerce providing organizational circulars, investment committee dashboards, articles, and member services.',
      tags: ['Flutter', 'Enterprise', 'PDF Export', 'Clean Arch', 'FCM'],
      icon: '09',
      architecture: 'Clean Architecture with Role-Based Access Control',
      playStoreUrl:
          'https://play.google.com/store/apps/details?id=com.elnooronline.tabukchamber&pcampaignid=web_share',
      appStoreUrl:
          'https://apps.apple.com/eg/app/tabuk-chamber-%D8%BA%D8%B1%D9%81%D8%A9-%D8%AA%D8%A8%D9%88%D9%83/id6758669687',
      keyHighlights: [
        'Enterprise circular distribution with priority push notification broadcast.',
        'Committee scheduling, agenda voting, and authenticated attendance tracking.',
        'Exportable digital certificates and official verification QR codes.',
      ],
      challengesAndSolutions: [
        'Challenge: Strict enterprise security requirements. Solution: Biometric authentication and SSL pinning.',
      ],
      metrics: ['Official Chamber Portal', '100% Secure Enterprise Access'],
    ),
  ];
}

