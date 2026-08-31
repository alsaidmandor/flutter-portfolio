# Alsaeed Mandor — Animated Flutter Portfolio

A responsive Flutter Web portfolio generated from the provided CV.

## Included
- Dark premium developer UI
- Animated hero + floating developer card
- Smooth navigation to sections
- Hover-animated project cards
- Animated skill chips
- Professional experience timeline
- Responsive desktop / tablet / mobile layout
- Email + phone contact actions
- GitHub and LinkedIn support once URLs are added

## Run
```bash
flutter pub get
flutter run -d chrome
```

## Build for production
```bash
flutter build web --release
```

The production files will be generated in:
`build/web/`

## Add GitHub / LinkedIn URLs
Open:
`lib/data/portfolio_data.dart`

Replace:
```dart
static const githubUrl = '';
static const linkedinUrl = '';
```

with your actual links.

## Content source
The portfolio content was structured from the supplied Flutter CV. Project store URLs were not exposed in the parsed CV, so no store links were invented.
