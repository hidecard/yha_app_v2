import 'package:intl/intl.dart';

String formatKyat(num? value) {
  if (value == null) return '';
  final formatter = NumberFormat('#,###', 'en_US');
  return 'Ks ${formatter.format(value)}';
}

String formatDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  try {
    final dt = DateTime.parse(iso).toLocal();
    return DateFormat('yyyy-MM-dd').format(dt);
  } catch (_) {
    return iso;
  }
}
