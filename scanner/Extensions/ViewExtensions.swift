//
//  ViewExtensions.swift
//  Scan IT
//
//  Created by Slaven Radic on 2024-09-01.
//

import Foundation
import SwiftUI
import LinkPresentation
import UIKit
import ImageIO

public extension Color {
	
	static let background = Color("background")
	static let foreground = Color("foreground")
	static let accent = Color("accent")
	
	
	init(hex: UInt, alpha: Double = 1) {
		self.init(
			.sRGB,
			red: Double((hex >> 16) & 0xff) / 255,
			green: Double((hex >> 08) & 0xff) / 255,
			blue: Double((hex >> 00) & 0xff) / 255,
			opacity: alpha
		)
	}
}

enum AppPalette {
	static let bgTop = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.10, green: 0.12, blue: 0.16, alpha: 1) : UIColor(red: 0.96, green: 0.95, blue: 0.91, alpha: 1) })
	static let bgBottom = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.08, green: 0.09, blue: 0.12, alpha: 1) : UIColor(red: 0.90, green: 0.93, blue: 0.96, alpha: 1) })
	static let accent = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.95, green: 0.58, blue: 0.45, alpha: 1) : UIColor(red: 0.88, green: 0.48, blue: 0.37, alpha: 1) })
	static let accentAlt = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.47, green: 0.66, blue: 0.90, alpha: 1) : UIColor(red: 0.24, green: 0.35, blue: 0.50, alpha: 1) })
	static let ink = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1) : UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1) })
	static let muted = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.68, green: 0.72, blue: 0.80, alpha: 1) : UIColor(red: 0.42, green: 0.45, blue: 0.50, alpha: 1) })
	static let glow = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.97, green: 0.85, blue: 0.55, alpha: 1) : UIColor(red: 0.95, green: 0.80, blue: 0.56, alpha: 1) })
	static let card = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.16, green: 0.18, blue: 0.23, alpha: 0.92) : UIColor(white: 1.0, alpha: 0.78) })
	static let cardStrong = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0.18, green: 0.20, blue: 0.26, alpha: 0.98) : UIColor(white: 1.0, alpha: 0.92) })
	static let stroke = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(white: 1.0, alpha: 0.08) : UIColor(white: 0.0, alpha: 0.08) })
	static let shadow = Color(uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(white: 0.0, alpha: 0.40) : UIColor(white: 0.0, alpha: 0.12) })
}

var DefaultBackgroundGradient: LinearGradient {
	LinearGradient(
		colors: [
			AppPalette.bgTop,
			AppPalette.bgBottom],
		startPoint: .topLeading,
		endPoint: .bottomTrailing)
	
}

func getDocumentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	return paths[0]
}

func getTemporaryDirectory() -> URL {
	let previewURL = FileManager.default.temporaryDirectory.appendingPathComponent("Document")
	return previewURL
}

class ShareImage: UIActivityItemProvider {
	var image: UIImage
	
	override var item: Any {
		get {
			return self.image
		}
	}
	
	override init(placeholderItem: Any) {
		guard let image = placeholderItem as? UIImage else {
			fatalError("Couldn't create image from provided item")
		}
		
		self.image = image
		super.init(placeholderItem: placeholderItem)
	}
	
	@available(iOS 13.0, *)
	override func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
		
		let metadata = LPLinkMetadata()
		metadata.title = "Result Image"
		
		var thumbnail: NSSecureCoding = NSNull()
		if let imageData = self.image.pngData() {
			thumbnail = NSData(data: imageData)
		}
		
		metadata.imageProvider = NSItemProvider(item: thumbnail, typeIdentifier: "public.png")
		
		return metadata
	}
	
}

extension Animation {
	func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
		if expression {
			return self.repeatForever(autoreverses: autoreverses)
		} else {
			return self
		}
	}
}

extension UIImage {
	
	var aspectRatio: CGFloat {
		size.width / size.height
	}
	
	func resizeToWidth(_ width: CGFloat) -> UIImage {
		
		// Determine the scale factor that preserves aspect ratio
		let ratio = size.width / size.height
		let height = width / ratio
		
		// Compute the new image size that preserves aspect ratio
		let scaledImageSize = CGSize(
			width: width,
			height: height
		)
		
		// Draw and return the resized UIImage
		
		let format = UIGraphicsImageRendererFormat()
		format.scale = 1
		
		let renderer = UIGraphicsImageRenderer(size: scaledImageSize, format: format)
		
		let scaledImage = renderer.image { _ in
			self.draw(in: CGRect(
				origin: .zero,
				size: scaledImageSize
			))
		}
		
		return scaledImage
	}
	
	func resize(newSize: CGSize) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(size: newSize)
		return renderer.image { (context) in
			self.draw(in: CGRect(origin: .zero, size: newSize))
		}
	}
	
}

struct FlippedUpsideDown: ViewModifier {
	func body(content: Content) -> some View {
		content
			.rotationEffect(.radians(CGFloat.pi))
			.scaleEffect(x: -1, y: 1, anchor: .center)
	}
}
extension View {
	func flippedUpsideDown() -> some View{
		self.modifier(FlippedUpsideDown())
	}
}

extension String {
	func truncate(to limit: Int) -> String {
		if count > limit {
			let truncated = String(prefix(limit)).trimmingCharacters(in: .whitespacesAndNewlines)
			return truncated + "\u{2026}"
		} else {
			return self
		}
	}
	
	func sanitized() -> String {
		// see for ressoning on charachrer sets https://superuser.com/a/358861
		let invalidCharacters = CharacterSet(charactersIn: "\\/:*?\"<>|")
			.union(.newlines)
			.union(.illegalCharacters)
			.union(.controlCharacters)
		
		return String(
			self
				.components(separatedBy: invalidCharacters)
				.joined(separator: "")
				.prefix(50)
		)
	}
	
	mutating func sanitize() -> Void {
		self = self.sanitized()
	}
	
	func whitespaceCondensed() -> String {
		return self.components(separatedBy: .whitespacesAndNewlines)
			.filter { !$0.isEmpty }
			.joined(separator: " ")
	}
	
	mutating func condenseWhitespace() -> Void {
		self = self.whitespaceCondensed()
	}
}

extension View {
	/// Applies the given transform if the given condition evaluates to `true`.
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - transform: The transform to apply to the source `View`.
	/// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
	@ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
		if condition() {
			transform(self)
		} else {
			self
		}
	}
}

struct ToolbarBackgroundModifier: ViewModifier {
	var color: Color
	
	func body(content: Content) -> some View {
		content
			.toolbarBackground(color, for: .navigationBar)
	}
}

struct ScrollContentBackgroundHiddenModifier: ViewModifier {
	
	func body(content: Content) -> some View {
		content
			.scrollContentBackground(.hidden)
	}
}

struct ScrollDismissesKeyboardInteractivelyModifier: ViewModifier {
	
	func body(content: Content) -> some View {
		content
#if !os(xrOS)
			.scrollDismissesKeyboard(.interactively)
#endif
	}
}

extension View {
	
	@ViewBuilder
	func ios16toolbarBackground(_ color: Color) -> some View {
		self
			.modifier(ToolbarBackgroundModifier(color: color))
	}
	
	@ViewBuilder
	func ios16scrollContentBackground() -> some View {
		self
			.modifier(ScrollContentBackgroundHiddenModifier())
	}
	
	@ViewBuilder
	func iOSScrollDismissesKeyboard() -> some View {
		self
			.modifier(ScrollDismissesKeyboardInteractivelyModifier())
	}
	
	@ViewBuilder
	func dataTagModifier() -> some View {
		self
			.modifier(DataTagModifier())
	}
}

struct AppCardModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(14)
			.background(
				RoundedRectangle(cornerRadius: 18, style: .continuous)
					.fill(AppPalette.card)
					.overlay(
						RoundedRectangle(cornerRadius: 18, style: .continuous)
							.stroke(AppPalette.stroke, lineWidth: 1)
					)
					.shadow(color: AppPalette.shadow, radius: 12, x: 0, y: 8)
			)
	}
}

extension View {
	@ViewBuilder
	func appCard() -> some View {
		self.modifier(AppCardModifier())
	}
}

struct DataTagModifier: ViewModifier {
	
	func body(content: Content) -> some View {
		content
			.padding(.vertical, 4)
			.padding(.horizontal, 8)
			.font(.system(size: 13))
			.lineLimit(1)
			.background(Capsule().fill(AppPalette.cardStrong))
		
	}
}

extension Date: RawRepresentable {
	private static let formatter = ISO8601DateFormatter()
	
	public var rawValue: String {
		Date.formatter.string(from: self)
	}
	
	public init?(rawValue: String) {
		self = Date.formatter.date(from: rawValue) ?? Date()
	}
}
