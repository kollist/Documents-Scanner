//
//  ScanStartPicker.swift
//  Scan IT
//
//  Created by Slaven Radic on 2024-09-01.
//

import SwiftUI

struct ScanStartPicker: View {
	
	@State private var bottomBarExpanded = false
	
	@State private var darkLinearGradient = LinearGradient(
		colors: [
			Color(hex: 0x868f96),
			Color(hex: 0x596164)],
		startPoint: .bottomLeading,
		endPoint: .topTrailing)
	
	@State private var lightLinearGradient = LinearGradient(
		colors: [
			Color(hex: 0xf9eef8),
			Color(hex: 0xfbfcfb)],
		startPoint: .bottomLeading,
		endPoint: .topTrailing)
	
	var body: some View {
		Button { switchView(.Page) } label: {
			HStack(spacing: 10) {
				Image(systemName: "plus.viewfinder")
					.symbolRenderingMode(.palette)
					.foregroundStyle(Color.black, Color.black)
					.font(.system(size: 22, weight: .semibold))
					.padding(8)
					.background(
						Circle()
							.fill(Color.white.opacity(0.9))
					)
				Text("Scan")
					.font(.custom("AvenirNextCondensed-DemiBold", size: 20))
					.foregroundColor(Color.black)
					.padding(.trailing, 8)
			}
			.padding(.horizontal, 12)
			.padding(.vertical, 10)
		}
		.accessibilityLabel("Start scanning")
		.background(
			RoundedRectangle(cornerRadius: 22, style: .continuous)
				.fill(
					LinearGradient(
						colors: [AppPalette.cardStrong, AppPalette.card],
						startPoint: .topLeading,
						endPoint: .bottomTrailing)
				)
				.overlay(
					RoundedRectangle(cornerRadius: 22, style: .continuous)
						.stroke(AppPalette.stroke, lineWidth: 1)
				)
		)
		.shadow(color: AppPalette.shadow, radius: 12, x: 0, y: 8)
	}
	
	func switchView(_ viewState: ViewState) {
		withAnimation(.easeInOut) {
			AppState.shared.viewState = viewState
		}
	}
	
}

struct ScanStartPicker_Previews: PreviewProvider {
	static var previews: some View {
		ScanStartPicker()
	}
}
