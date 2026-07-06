import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../theme/custom_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 16),
          
          // Premium Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isPremium
                  ? CustomTheme.premiumGradient
                  : const LinearGradient(
                      colors: [CustomTheme.secondaryColor, CustomTheme.cardColor],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPremium ? Colors.white30 : CustomTheme.accentColor.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: isPremium ? const Color(0xFFFF007F).withValues(alpha: 0.2) : Colors.transparent,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPremium ? 'PREMIUM USER' : 'UPGRADE TO PREMIUM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isPremium ? Colors.white : CustomTheme.accentColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Icon(
                      isPremium ? Icons.star : Icons.star_border,
                      color: isPremium ? Colors.white : CustomTheme.accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isPremium
                      ? 'Thank you for supporting UserNameGenerator! All premium AI categories and fonts unlocked.'
                      : 'Unlock all premium AI filters, exclusive Unicode fonts, symbol packs, and remove ads.',
                  style: TextStyle(
                    color: isPremium ? Colors.white70 : CustomTheme.textSecondary,
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
                      backgroundColor: isPremium ? CustomTheme.cardColor : CustomTheme.accentColor,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'DATA CONTROLS',
              style: TextStyle(
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
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history, color: CustomTheme.accentColor),
                  title: const Text('Clear Search & Copy History'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear History?'),
                        content: const Text('Are you sure you want to clear your copied names history?'),
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

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'INFO',
              style: TextStyle(
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
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline, color: CustomTheme.accentColor),
                  title: Text('Version'),
                  trailing: Text('1.0.0 (Build 1)', style: TextStyle(color: CustomTheme.textSecondary)),
                ),
                const Divider(height: 1, color: Colors.white10),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: CustomTheme.accentColor),
                  title: const Text('Help & Support'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Support email: support@usernamegenerator.app')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Footer
          const Center(
            child: Text(
              'Designed & Developed for Gamers 🎮',
              style: TextStyle(color: Colors.white24, fontSize: 11),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
