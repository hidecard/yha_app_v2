import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternalUrl(BuildContext context, String? url) async {
  if (url == null || url.trim().isEmpty) {
    _showError(context);
    return;
  }
  final uri = Uri.tryParse(url.trim());
  if (uri == null) {
    _showError(context);
    return;
  }
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (context.mounted) _showError(context);
  }
}

Future<void> launchPhone(BuildContext context, String phone) async {
  final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
  final uri = Uri.parse('tel:$cleaned');
  if (!await launchUrl(uri)) {
    if (context.mounted) _showError(context);
  }
}

Future<void> launchEmail(BuildContext context, String email) async {
  final uri = Uri.parse('mailto:$email');
  if (!await launchUrl(uri)) {
    if (context.mounted) _showError(context);
  }
}

Future<void> openMap(BuildContext context, String? mapUrl) async {
  await openExternalUrl(context, mapUrl);
}

void _showError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('ဖွင့်၍မရပါ။ ပြန်လည်ကြိုးစားပါ။')),
  );
}
