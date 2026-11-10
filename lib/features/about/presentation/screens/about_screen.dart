import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yha/core/theme/app_colors.dart';
import 'package:yha/core/utils/url_launcher_utils.dart';
import 'package:yha/features/courses/presentation/providers/courses_providers.dart';
import 'package:yha/shared/widgets/contact_action_button.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesState = ref.watch(coursesProvider);
    final address = coursesState.addresses.isNotEmpty ? coursesState.addresses.first : null;
    final phone = address?.yphNo ?? '09 882 328 992';
    final email = address?.yEmail ?? 'yhacomputer@gmail.com';
    final openClose = address?.openClose ?? '8 : 00 AM to 5 : 00 PM';
    final addrText = address?.address ??
        'အမှတ် (၂၉) ၊ လှည်းတန်း ၊ အင်းစိန်လမ်းမကြီး ၊ ခိုင်ရွှေဝါလမ်းထိပ် ၊ Ice Berry ဘေးတိုက် အပေါ်ထပ် (၆) လွှာ ၊ ကမာရွတ်မြို့နယ် ၊ ရန်ကုန်မြို့';

    return Scaffold(
      appBar: AppBar(title: const Text('About YHA')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          children: [
            _IntroCard(),
            const SizedBox(height: 16),
            _InfoCard(
              icon: Icons.flag_rounded,
              title: 'Our Mission',
              body:
                  'ကျောင်းသားများအား ခေတ်မီနည်းပညာဗဟုသုတနှင့် လက်တွေ့လုပ်ငန်းခွင်ကျွမ်းကျင်မှုများ ရရှိစေရန် အရည်အသွေးမြင့် သင်ကြားမှုများ ပေးအပ်ရန် ဖြစ်ပါသည်။',
            ),
            _InfoCard(
              icon: Icons.visibility_rounded,
              title: 'Our Vision',
              body:
                  'မြန်မာနိုင်ငံရှိ နည်းပညာလေ့လာသူများအတွက် ယုံကြည်စိတ်ချရသော ပညာရေးမိတ်ဖက်တစ်ဦးအဖြစ် ရပ်တည်နိုင်ရန် ရည်မှန်းပါသည်။',
            ),
            _WhyChooseCard(),
            _InfoCard(
              icon: Icons.location_city_rounded,
              title: 'Visit Our Campus',
              body: '$addrText\n\nOpening Hours: $openClose\nPhone: $phone\nEmail: $email',
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.support_agent_rounded, color: AppColors.primaryBlue),
                      SizedBox(width: 8),
                      Text('Contact Us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ContactActionButton(icon: Icons.phone_rounded, label: 'Call Now', onPressed: () => launchPhone(context, phone)),
                      ContactActionButton(icon: Icons.email_rounded, label: 'Send Email', onPressed: () => launchEmail(context, email)),
                      ContactActionButton(icon: Icons.telegram, label: 'Open Telegram', onPressed: () => openExternalUrl(context, 'https://t.me/')),
                      ContactActionButton(icon: Icons.facebook, label: 'Open Facebook', onPressed: () => openExternalUrl(context, 'https://www.facebook.com/yhacomputerhledan')),
                      ContactActionButton(
                        icon: Icons.map_rounded,
                        label: 'Open in Maps',
                        onPressed: () => openExternalUrl(context, address?.mapUrl ?? 'https://www.google.com/maps/search/?api=1&query=YHA+Computer+Training+Center+Hledan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.accentYellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.school_rounded, color: Colors.white),
          ),
          const SizedBox(height: 14),
          const Text('About YHA', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text(
            'YHA Academy of Technology သည် နည်းပညာပညာရပ်များကို လက်တွေ့အခြေခံဖြင့် သင်ကြားပေးနေသည့် သင်တန်းကျောင်းတစ်ခုဖြစ်ပါသည်။ ကျောင်းသားများအတွက် အခြေခံမှစ၍ လုပ်ငန်းခွင်အသုံးချနိုင်သော ကျွမ်းကျင်မှုများ တိုးတက်စေရန် ရည်ရွယ်ပါသည်။',
            style: TextStyle(color: Colors.white, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(color: AppColors.textSecondary, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyChooseCard extends StatelessWidget {
  static const _items = [
    (Icons.code_rounded, 'လက်တွေ့ Project-based သင်ကြားမှု'),
    (Icons.groups_rounded, 'အတွေ့အကြုံရှိ ဆရာများ၏ လမ်းညွှန်မှု'),
    (Icons.menu_book_rounded, 'အခြေခံမှ အဆင့်မြင့်အထိ သင်ရိုးများ'),
    (Icons.emoji_events_rounded, 'ကျောင်းသား Project များဖြင့် အတွေ့အကြုံတိုးတက်စေခြင်း'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.workspace_premium_rounded, color: AppColors.primaryBlue),
            SizedBox(width: 8),
            Text('Why Choose YHA', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ]),
          const SizedBox(height: 14),
          ..._items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(10)),
                      child: Icon(e.$1, size: 18, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Padding(padding: const EdgeInsets.only(top: 6), child: Text(e.$2, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
