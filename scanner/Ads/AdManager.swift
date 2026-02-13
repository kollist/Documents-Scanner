import Foundation
import SwiftUI
import GoogleMobileAds

enum AdConstants {
	// Google test IDs
	static let bannerUnitID = "ca-app-pub-3940256099942544/2934735716"
	static let interstitialUnitID = "ca-app-pub-3940256099942544/4411468910"
}

final class AdManager: NSObject, FullScreenContentDelegate {
	static let shared = AdManager()
	
	private var interstitial: InterstitialAd?
	private var isLoading = false
	private var pendingShow = false
	private var blockingCompletions: [() -> Void] = []
	private var launchTimeoutWorkItem: DispatchWorkItem?
	
	func start() {
        MobileAds.shared.start(completionHandler: nil)
		loadInterstitialIfNeeded()
	}

	func preloadInterstitial() {
		loadInterstitialIfNeeded()
	}
	
	func loadInterstitialIfNeeded() {
		guard !isLoading, interstitial == nil else { return }
		isLoading = true
        let request = Request()
        InterstitialAd.load(with: AdConstants.interstitialUnitID, request: request) { [weak self] ad, error in
			guard let self = self else { return }
			self.isLoading = false
			if let error = error {
				print("AdMob interstitial failed to load: \(error.localizedDescription)")
				self.finishLaunchIfNeeded()
				return
			}
			self.interstitial = ad
			self.interstitial?.fullScreenContentDelegate = self
			if self.pendingShow {
				self.pendingShow = false
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
					self.showInterstitialIfReady()
				}
			}
		}
	}
	
	func showInterstitialIfReady() {
		guard let root = UIApplication.shared.keyWindowRootViewController else {
			pendingShow = true
			loadInterstitialIfNeeded()
			return
		}
		guard let interstitial = interstitial else {
			pendingShow = true
			loadInterstitialIfNeeded()
			return
		}
		pendingShow = false
		self.interstitial = nil
        interstitial.present(from: root)
	}

	func showBlockingInterstitial(blockingTimeout: TimeInterval = 3.0, completion: @escaping () -> Void) {
		blockingCompletions.append(completion)
		pendingShow = true
		loadInterstitialIfNeeded()
		if launchTimeoutWorkItem == nil {
			let workItem = DispatchWorkItem { [weak self] in
				self?.finishLaunchIfNeeded()
			}
			launchTimeoutWorkItem = workItem
			DispatchQueue.main.asyncAfter(deadline: .now() + blockingTimeout, execute: workItem)
		}
	}

	private func finishLaunchIfNeeded() {
		launchTimeoutWorkItem?.cancel()
		launchTimeoutWorkItem = nil
		let completions = blockingCompletions
		blockingCompletions.removeAll()
		completions.forEach { $0() }
	}
	
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
		loadInterstitialIfNeeded()
		finishLaunchIfNeeded()
	}
}

extension UIApplication {
	var keyWindowRootViewController: UIViewController? {
		let scenes = connectedScenes.compactMap { $0 as? UIWindowScene }
		let windows = scenes.flatMap { $0.windows }
		return windows.first(where: { $0.isKeyWindow })?.rootViewController
	}
}
