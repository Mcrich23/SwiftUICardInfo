//
//  FeatureCell.swift
//  Welcome
//
//  Created by Jordan Singer on 11/25/20.
//

import SwiftUI
import Kingfisher


/**
 The cells in the Mcrich23_Toolkit OnboardingScreen
 
 - parameter image: An icon next to the cell.
 - parameter imageColor: Color for the icon next to the cell.
 - parameter title: The title.
 - parameter subtitle: The subtitle/description (leave blank for it to dissapear).
 
 # Example #
 ```
 FeatureCell(
     image: .systemImage(named: "hand"),
     imageColor: .red,
     title: "Title",
     subtitle: "Subtitle"
 )
 ```
 */
public struct FeatureCell: View, Hashable {
    
    public var image: GlyphImage
    public var title: String
    public var subtitle: String
    public var imageColor: Color
    public var id: String
    
    public init(image: GlyphImage, imageColor: Color, title: String, subtitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.imageColor = imageColor
        self.id = String(describing: Int.random(in: 0...99999999))
    }
    
    public init(id: String, image: GlyphImage, imageColor: Color, title: String, subtitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.imageColor = imageColor
        self.id = id
    }
    
    public var body: some View {
        HStack(spacing: 24) {
            switch image {
            case .systemImage(let string):
                Image(systemName: string)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32)
                    .foregroundColor(imageColor)
            case .assetImage(let string):
                Image(systemName: string)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32)
                    .foregroundColor(imageColor)
            case .remoteImage(let named):
                KFImage(named)
                    .placeholder({
                        Image(systemSymbol: .photo)
                            .resizable()
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32)
                    .foregroundColor(imageColor)
            case .defaultIcon:
                EmptyView()
            }
                    
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                if subtitle != "" {
                    Text(subtitle)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }
            
            Spacer()
        }
    }
}

struct FeatureCell_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCell(image: .systemImage(named: "text.badge.checkmark"), imageColor: .yellow, title: "Title", subtitle: "Subtitle")
    }
}
