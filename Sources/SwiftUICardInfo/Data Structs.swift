//
//  Data Structs.swift
//  
//
//  Created by Morris Richman on 3/28/22.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS) || targetEnvironment(macCatalyst)
import UIKit
#elseif os(macOS)
import Cocoa
#endif
import SwiftUI
import URLImage
import Kingfisher
/**
 Different types of glyphs, whether it be icons, or images. one variable for all the types.
 
 Convert it to an image with ```ConvertedGlyphImage```
 
 - parameter systemImage: Uses SF Symbols.
 - parameter assetImage: Uses Assets.xcassets.
 - parameter remoteImage: Fetches from url and displays image.
 - parameter defaultIcon: The default icon that you specify.
 */
public enum GlyphImage: Hashable, Equatable {
    /// SF Symbol
    case systemImage(named: String)
    /// Image From Assets
    case assetImage(named: String)
    /// Image From Remote Location
    case remoteImage(url: URL)
    case defaultIcon
}

/**
 Converts GlyphImage into a SwiftUI Image
 
 - parameter GlyphImage: The GlyphImage
 - parameter defaultIcon: The default icon for a view.
 - parameter modifiers: All of the modifiers for your image.
 - returns: Image
 
 # Example #
 ```
 ConvertedGlyphImage(GlyphImage: $GlyphImage, defaultIcon: Image(systemSymbol: .apps.iphone") { image in
     image
         .resizable()
         .aspectRatio(contentMode: .fit)
         .foregroundColor(.primary)
 }
 ```
 
 */
public struct ConvertedGlyphImage<Content: View, Modifier: View>: View {
    @Binding public var glyphImage: GlyphImage
    @State public var defaultIcon: Content
    @State public var modifiers: (Image) -> Modifier
    public init(glyphImage: Binding<GlyphImage>, defaultIcon: Content, modifiers: @escaping (Image) -> Modifier) {
        self._glyphImage = glyphImage
        self._defaultIcon = State(initialValue: defaultIcon)
        self._modifiers = State(initialValue: modifiers)
    }
    public init(glyphImage: Binding<GlyphImage>, defaultIcon: Content) {
        self._glyphImage = glyphImage
        self._defaultIcon = State(initialValue: defaultIcon)
        self._modifiers = State(initialValue: {image in return image as! Modifier})
    }
    public var body: some View {
        HStack {
            switch glyphImage {
            case .systemImage(let named):
                modifiers(Image(systemName: named))
            case .assetImage(let named):
                modifiers(Image(named))
            case .remoteImage(let url):
                if #available(iOS 15, *) {
                    AsyncImage(url: url) { image in
                        modifiers(image)
                    } placeholder: {
                        modifiers(Image(systemSymbol: .photo))
                    }
                } else {
                    URLImage(url) { image in
                        modifiers(image)
                    }
                }
            case .defaultIcon:
                defaultIcon
            }
        }
    }
}
/**
Class for all the free floating functions
 */
public class Mcrich23_Toolkit {
    /**
     Opens a url
     
     - parameter url: The url you would like to open.
     
     # Example #
     ```
     Mcrich23_Toolkit.openUrl(url: url)
     ```
     
     */
    public static func openUrl(url: String) {
        guard let url = URL(string: url) else { return }
        #if os(iOS) || os(tvOS) || os(watchOS) || targetEnvironment(macCatalyst)
            UIApplication.shared.open(url)
        #elseif os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }
}
