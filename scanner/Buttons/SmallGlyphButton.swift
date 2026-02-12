//
//  SmallGlyphButton.swift
//  Scan IT
//
//  Created by Slaven Radic on 2024-09-01.
//

import SwiftUI

struct SmallGlyphButton: View {
	
	var systemImage: String
	var destructive: Bool = false
	
	var body: some View {
		ZStack {
			Circle()
				.foregroundColor(AppPalette.cardStrong)
			Circle()
				.foregroundColor(destructive ? Color.red : AppPalette.ink)
				.padding(2)
			Image(systemName: systemImage)
				.font(.system(size: 16))
				.foregroundColor(Color.white)
				.padding(2)
		}
		.frame(width: 32, height: 32)
	}
}

struct SmallGlyphButton_Previews: PreviewProvider {
	static var previews: some View {
		SmallGlyphButton(systemImage: "doc")
	}
}


struct SmallThumbnail: View {
	
	var image: UIImage?
	var size: CGSize = CGSize(width: 80, height: 80)
	var borderColor: Color = Color.background
	
	var body: some View {
		ZStack {
			if image != nil {
				Image(uiImage: image ?? UIImage())
					.resizable()
					.scaledToFill()
					.frame(width: size.width, height: size.height)
					.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
				
			}
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.stroke(borderColor, lineWidth: 2)
		}
		.foregroundColor(AppPalette.ink)
		.padding(2)
		.frame(width: size.width, height: size.height)
	}
}

struct CaptureThumbnail: View {
	
	@State var capture: ScanCapture?
	
	// Letter-sized page aspect ratio
	@State var aspectRatio = 0.77
	
	var body: some View {
		ZStack {
			
			if image != nil {
				Image(uiImage: image ?? UIImage())
					.resizable()
					.scaledToFill()
					.frame(width: rotate ? height : height * aspectRatio, height: rotate ? height * aspectRatio : height)
					.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
					.rotationEffect(Angle(degrees: rotate ? -90 : 0))
			} else {
				RoundedRectangle(cornerRadius: 10, style: .continuous)
					.fill(AppPalette.cardStrong)
					.opacity(0.9)
			}
		}
		.frame(width: height * aspectRatio, height: height)
		.foregroundColor(AppPalette.ink)
		.overlay(
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.stroke(image != nil ? Color.white.opacity(0.6) : Color.clear, lineWidth: 1)
		)
		.frame(height: height)
		.shadow(color: AppPalette.shadow, radius: 10, x: 0, y: 6)
	}
	
	var height: CGFloat {
		return 100
	}
	
	var rotate: Bool {
		guard let image = image else { return false }
		
		return image.size.width > image.size.height
	}
	
	var image: UIImage? {
		if let capture = capture {
			return capture.thumbnail
		} else {
			return nil
		}
	}
}

struct FlexyThumbnail: View {
	
	var image: UIImage?
	var borderColor: Color = Color.background
	
	var body: some View {
		ZStack {
			Color.clear
			
			if image != nil {
				Image(uiImage: image ?? UIImage())
					.resizable()
					.scaledToFill()
					.clipShape(RoundedRectangle(cornerRadius: 8))
				
			}
			RoundedRectangle(cornerRadius: 8)
				.stroke(borderColor, lineWidth: 2)
		}
		.foregroundColor(Color.primary)
		.padding(8)
	}
}

struct SmallThumbnail_Previews: PreviewProvider {
	static var previews: some View {
		SmallThumbnail(image: nil)
	}
}
