import 'package:flutter_test/flutter_test.dart';
import 'package:yha/core/utils/formatters.dart';
import 'package:yha/core/utils/image_url.dart';

void main() {
  test('buildImageUrl returns empty for null/empty', () {
    expect(buildImageUrl(null), '');
    expect(buildImageUrl(''), '');
  });

  test('buildImageUrl keeps absolute urls', () {
    expect(buildImageUrl('https://example.com/a.jpg'), 'https://example.com/a.jpg');
  });

  test('buildImageUrl prefixes relative filenames', () {
    final url = buildImageUrl('photo.jpg');
    expect(url.contains('photo.jpg'), true);
    expect(url.startsWith('http'), true);
  });

  test('formatKyat formats values', () {
    expect(formatKyat(300000), 'Ks 300,000');
    expect(formatKyat(null), '');
  });
}
