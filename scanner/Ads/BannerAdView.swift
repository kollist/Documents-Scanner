import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
		let banner = BannerView(adSize: AdSizeBanner)
		banner.adUnitID = AdConstants.bannerUnitID
		banner.rootViewController = UIApplication.shared.keyWindowRootViewController
		banner.load(Request())
		return banner
	}
	
    func updateUIView(_ uiView: BannerView, context: Context) {
		if uiView.rootViewController == nil {
			uiView.rootViewController = UIApplication.shared.keyWindowRootViewController
		}
	}
}
