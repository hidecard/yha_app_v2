# YHA Academy of Technology - Flutter App

Mobile application for **YHA Academy of Technology** (`https://yit-edu.com/`), built as a responsive adaptation of the existing website using Flutter, Material 3, Riverpod, GoRouter, and Dio.

## Tech Stack
- Flutter / Dart (null safety)
- Material 3
- Dio (REST API)
- Riverpod (state management)
- GoRouter (navigation)
- cached_network_image, flutter_html, url_launcher, intl, shimmer

## Project Structure
Feature-based architecture:
```text
lib/
  core/        # config, theme, network, errors, utils
  routing/     # GoRouter + shell navigation
  shared/      # shared models/widgets
  features/
    home/
    courses/
    course_detail/
    projects/
    project_detail/
    about/
    contact/
  main.dart
```
Flow: `UI -> Provider/Controller -> Repository -> API Service -> Dio`

## API Configuration
Configured in `lib/core/constants/api_config.dart`:
```dart
class ApiConfig {
  static const String baseUrl = 'https://yit-edu.com/api/v1';
  // Configurable because API returns image filenames
  static const String imageBaseUrl = 'https://yit-edu.com/storage/';
}
```
- Do not hardcode API URLs in widgets.
- Image URLs are built via `lib/core/utils/image_url.dart` (`buildImageUrl`). If the website serves images from a different path, change only `ApiConfig.imageBaseUrl`.

## Endpoints Used
- `GET /courses` – course list (+ address in response)
- `GET /courses/{id}` – course detail, subjects, related courses
- `GET /projects` – student projects with course/student relations

## Run & Test
```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Notes
- No fake course/project data when API data is available.
- Nullable-safe parsing for API fields; HTML `about` rendered via `flutter_html`.
- Loading/empty/error/retry states, pull-to-refresh, search/filter supported.
- External actions (phone/email/maps/video/links) use `url_launcher` with user-friendly fallback messages.
- Burmese content displayed with wrapping-friendly layouts (no fixed-height text containers).
