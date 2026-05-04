# Walter & Laura Wedding Invitation - Setup Instructions

## Overview
This is a beautiful Flutter wedding invitation landing page for Walter Díaz and Laura Ceballos. The app includes:
- Elegant header with couple names
- Date and time display (October 26, 2026 at 2:00 PM)
- Location information (Hacienda Arkadia, Chía)
- Google Maps and Waze navigation buttons
- Google Forms RSVP confirmation

## Romantic Color Palette Used
- Primary: `#b4947d` (Warm Taupe)
- Secondary: `#c7a49E` (Dusty Rose)
- Accent: `#e4c9b8` (Beige)
- Light: `#e0d2c7` (Light Beige)
- White: `#ffffff`

## Setup Steps

### 1. Install Dependencies
Before running the app, make sure to get the required packages:

```bash
flutter pub get
```

This will install the `url_launcher` package needed for opening URLs.

### 2. Add Google Forms URL
1. Create a Google Form for the RSVP or use an existing one
2. Get the short form URL (it will look like `https://forms.gle/YOUR_UNIQUE_ID`)
3. Open `lib/main.dart` and locate this line (around line 45):
   ```dart
   static const String googleFormsUrl =
       'https://forms.gle/'; // Replace with actual form URL
   ```
4. Replace the URL with your actual Google Forms link

### 3. Add Google Maps Location
1. Open Google Maps and search for "Hacienda Arkadia, Chía"
2. Right-click on the exact location
3. Click "Share" and copy the Google Maps link
4. Open `lib/main.dart` and locate this line (around line 48):
   ```dart
   static const String mapsUrl =
       'https://maps.app.goo.gl/'; // Replace with actual location URL
   ```
5. Replace the URL with your actual Google Maps link

### 4. Add Waze Location
1. Open Waze app on your phone
2. Search for "Hacienda Arkadia, Chía"
3. Tap the "Share" button
4. Copy the Waze link
5. Open `lib/main.dart` and locate this line (around line 51):
   ```dart
   static const String wazeUrl =
       'https://waze.com/ul/'; // Replace with actual Waze URL
   ```
6. Replace the URL with your actual Waze link

## Running the App

### Mobile (iOS/Android)
```bash
flutter run
```

### Web
```bash
flutter run -d chrome
```

### Windows
```bash
flutter run -d windows
```

### macOS
```bash
flutter run -d macos
```

### Linux
```bash
flutter run -d linux
```

## Features

### Header Section
- Displays couple names: Walter Díaz & Laura Ceballos
- Elegant gradient background with romantic colors
- Responsive design that adapts to screen size

### Date & Time Section
- Shows wedding date: October 26, 2026
- Shows time: 2:00 PM
- Beautiful card layout with semi-transparent background

### Location Section
- Shows venue: Hacienda Arkadia, Chía
- Two action buttons:
  - Google Maps button (opens map in default browser/app)
  - Waze button (opens Waze navigation)

### RSVP Section
- Prominent confirmation button
- Links to Google Forms for guests to confirm attendance
- Explains the purpose clearly

## Customization

### Change Colors
To use different colors, modify the color constants in `_WeddingInvitationPageState` class (around line 39):

```dart
static const Color primaryColor = Color(0xFFb4947d);
static const Color secondaryColor = Color(0xFFc7a49E);
static const Color accentColor = Color(0xFFe4c9b8);
static const Color lightColor = Color(0xFFe0d2c7);
static const Color whiteColor = Color(0xFFffffff);
```

### Change Wedding Details
To modify the date, time, or location text, search for these values in `lib/main.dart`:
- Date: '26 de Octubre de 2026'
- Time: '2:00 PM'
- Venue: 'Hacienda Arkadia'
- City: 'Chía, Cundinamarca'

### Modify Text (Language)
The app is currently in Spanish. To change text to English or another language, find and replace:
- '📅 Fecha y Hora' → '📅 Date & Time'
- '📍 Ubicación' → '📍 Location'
- '💌 Confirma tu Asistencia' → '💌 Confirm Your Attendance'
- 'Se unen en matrimonio' → 'Are united in marriage'
- etc.

## Deployment

### Android
1. Update app version in `pubspec.yaml`
2. Create a signed APK:
   ```bash
   flutter build apk --release
   ```

### iOS
1. Update app version in `pubspec.yaml` and `ios/Runner/Info.plist`
2. Create an IPA:
   ```bash
   flutter build ipa --release
   ```

### Web
1. Build web version:
   ```bash
   flutter build web --release
   ```
2. Deploy to your web hosting

## Troubleshooting

### URL Launcher Not Working
- Make sure you have internet connection
- Check that the URLs are properly formatted
- On Android, ensure the app has internet permissions (checked in `AndroidManifest.xml`)
- On iOS, you may need to configure LSApplicationQueriesSchemes in `Info.plist`

### Colors Not Displaying Correctly
- Ensure you're using the correct hex color format (#RRGGBB)
- Clear Flutter cache: `flutter clean`
- Rebuild: `flutter pub get && flutter run`

### Build Issues
Try these steps:
```bash
flutter clean
flutter pub get
flutter run
```

## Support

For more information about Flutter, visit: https://flutter.dev

For more about url_launcher package: https://pub.dev/packages/url_launcher

---

**Enjoy your special day!** ✨💕
