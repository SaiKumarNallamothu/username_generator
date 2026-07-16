import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService instance = AdService._internal();
  AdService._internal();

  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool _isAdLoading = false;

  // User's Production Ad Unit IDs
  static const String appId = 'ca-app-pub-9215767386390942~9088925055';
  static const String bannerAdId = 'ca-app-pub-9215767386390942/2484676616';
  static const String interstitialAdId = 'ca-app-pub-9215767386390942/3334723852';
  static const String rewardedInterstitialAdId = 'ca-app-pub-9215767386390942/4383393285';
  static const String rewardedAdId = 'ca-app-pub-9215767386390942/3961409816';
  static const String nativeAdId = 'ca-app-pub-9215767386390942/6817984936';
  static const String appOpenAdId = 'ca-app-pub-9215767386390942/3185861687';

  // Test Ad Unit IDs
  static const String _testAdUnitIdAndroid = 'ca-app-pub-3940256099942544/5354046379';
  static const String _testAdUnitIdIOS = 'ca-app-pub-3940256099942544/6978759866';

  String get _adUnitId {
    if (kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.iOS
          ? _testAdUnitIdIOS
          : _testAdUnitIdAndroid;
    }
    return rewardedInterstitialAdId;
  }

  Future<void> init() async {
    await MobileAds.instance.initialize();
    loadRewardedInterstitialAd();
  }

  void loadRewardedInterstitialAd() {
    if (_isAdLoading || _rewardedInterstitialAd != null) return;
    _isAdLoading = true;

    RewardedInterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialAd = ad;
          _isAdLoading = false;
          // Set full screen content callback
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedInterstitialAd = null;
              loadRewardedInterstitialAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedInterstitialAd = null;
              loadRewardedInterstitialAd(); // Load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isAdLoading = false;
          _rewardedInterstitialAd = null;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 10), () {
            loadRewardedInterstitialAd();
          });
        },
      ),
    );
  }

  /// Shows the Rewarded Interstitial Ad if available, then runs the [onRewardEarned] callback.
  /// If the ad is not loaded, it attempts to load and immediately runs [onRewardEarned] (fallback) so the user is not blocked.
  void showRewardedInterstitialAd({required VoidCallback onRewardEarned}) {
    if (_rewardedInterstitialAd != null) {
      _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onRewardEarned();
        },
      );
    } else {
      // Fallback in case ad is not loaded: perform the action immediately
      onRewardEarned();
      loadRewardedInterstitialAd();
    }
  }
}
