//
//  AboutView.swift
//  Scan IT
//

import SwiftUI

struct AboutView: View {
	
	@State var justAppeared = true
	@State var showingRestoreError = false
	
	
	static let supportBody: String = "%0A%0A%0A----------%0APlease%20write%20your%20message%20above%20this%20section."
	
	var body: some View {
		ZStack {
			VStack(alignment: .leading, spacing: 16) {
				HStack(spacing: 12) {
					ZStack {
                        OpenScannerButton(
                            caption: "",
                            image: "scanner.fill",
                            exactHeight: 70,
                            justAppeared: $justAppeared
                        )
							.frame(width: 70, height: 70)
					}
					
					VStack(alignment: .leading, spacing: 4) {
						Text("Scan It")
							.font(.custom("AvenirNextCondensed-DemiBold", size: 30))
							.foregroundColor(AppPalette.ink)
						Text("Scan. Save. Sync.")
							.font(.custom("Georgia", size: 14))
							.foregroundColor(AppPalette.muted)
					}
				}
				
				Text("Built for clean captures, quiet storage, and fast sharing.")
					.font(.custom("Georgia", size: 15))
					.foregroundColor(AppPalette.ink)
				
				HStack(spacing: 12) {
					Image(systemName: "ellipsis.bubble")
					Button {
						UIApplication.shared.open(URL(string: "mailto:support@example.com?subject=Scan%20It%20support%20request&body=\(AboutView.supportBody)")!,
												  options: [:],
												  completionHandler: nil)
					} label: {
						Text("Need help?")
							.font(.custom("Georgia", size: 14))
							.contentShape(Rectangle())
					}
				}
				.foregroundColor(AppPalette.accentAlt)
				
				HStack(spacing: 8) {
					Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "•.•")")
					Text("•")
					Text("Privacy Policy")
				}
				.font(.custom("Georgia", size: 12))
				.foregroundColor(AppPalette.muted)
			}
			.appCard()
		}
		.onAppear {
			withAnimation(.easeOut(duration: 0.5)) {
				justAppeared = false
			}
		}
		.padding()
		.ignoresSafeArea(.all)
	}
}

struct AboutView_Previews: PreviewProvider {
	static var previews: some View {
		AboutView()
	}
}
