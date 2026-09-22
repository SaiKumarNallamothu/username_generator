import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 16),
          
          // Premium Card (glowing borders, gold gradient)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isPremium
                  ? CustomTheme.goldGradient
                  : const LinearGradient(
                      colors: [CustomTheme.secondaryColor, CustomTheme.cardColor],
                    ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isPremium ? CustomTheme.accentColor : Colors.white10,
                width: 1.5,
              ),
              boxShadow: isPremium
                  ? [
                      BoxShadow(
                        color: CustomTheme.accentColor.withValues(alpha: 0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPremium ? 'PREMIUM STUDIO ACTIVE' : 'UPGRADE TO PREMIUM',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isPremium ? CustomTheme.primaryColor : CustomTheme.accentColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Icon(
                      isPremium ? Icons.star : Icons.star_border,
                      color: isPremium ? CustomTheme.primaryColor : CustomTheme.accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isPremium
                      ? 'Thank you for supporting Gaming Username Studio! All categories and premium filters are unlocked.'
                      : 'Unlock exclusive clan designs, esports style packs, and remove all ads.',
                  style: GoogleFonts.inter(
                    color: isPremium ? CustomTheme.primaryColor.withValues(alpha: 0.8) : CustomTheme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: isPremium ? Colors.white : CustomTheme.primaryColor,
                      backgroundColor: isPremium ? CustomTheme.primaryColor : CustomTheme.accentColor,
                    ),
                    onPressed: () {
                      ref.read(premiumProvider.notifier).togglePremium();
                    },
                    child: Text(isPremium ? 'Simulate Downgrade' : 'Simulate Upgrade'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Options List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'DATA CONTROLS',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: CustomTheme.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: CustomTheme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history, color: CustomTheme.accentColor),
                  title: Text('Clear History', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: CustomTheme.cardColor,
                        title: Text('Clear History?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        content: Text('Are you sure you want to clear your copied names history?', style: GoogleFonts.inter()),
                        actions: [
                          TextButton(
                            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text('Clear', style: TextStyle(color: CustomTheme.errorColor)),
                            onPressed: () {
                              ref.read(historyProvider.notifier).clearHistory();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('History cleared successfully.')),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'INFO',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: CustomTheme.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: CustomTheme.cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: CustomTheme.accentColor),
                  title: Text('Version', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  trailing: Text('3.0.0 (Build 3)', style: GoogleFonts.inter(color: CustomTheme.textSecondary)),
                ),
                const Divider(height: 1, color: Colors.white10),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: CustomTheme.accentColor),
                  title: Text('Help & Support', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Support email: support@gamingstudio.app')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Footer
          Center(
            child: Text(
              'Designed & Developed for Gamers 🎮',
              style: GoogleFonts.poppins(color: Colors.white24, fontSize: 11),
            ),
          ),
          const SizedBox(height: 120), // Spacing for floating capsule navigation bar
        ],
      ),
    );
  }
}
