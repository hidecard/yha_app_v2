import '../constants/api_config.dart';

String buildImageUrl(String? fileName) {
  if (fileName == null || fileName.isEmpty) {
    return '';
  }

  if (fileName.startsWith('http://') || fileName.startsWith('https://')) {
    return fileName;
  }

  final base = ApiConfig.imageBaseUrl;
  if (base.endsWith('/')) {
    return '$base$fileName';
  }
  return '$base/$fileName';
}
