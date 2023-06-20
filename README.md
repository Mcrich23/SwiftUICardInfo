# SwiftUICardInfo

Use the App Store Cards (stories) in your app!

# Requirements 

- iOS 14, macOS 10.16, tvOS 14, or watchOS 6.7
- Swift 5.5+
- Xcode 12.5+

# Installation

The preferred way of installing Mcrich23 Toolkit is via the [Swift Package Manager](https://swift.org/package-manager/).


1. In Xcode, open your project and navigate to **File** → **Add Packages...**
2. Paste the repository URL (`https://github.com/Mcrich23/Mcrich23-Toolkit`) and click **Next**.
3. For **Rules**, select **Up To Next Minor Version** (With base version set to 0.6.1).
4. Click **Finish**.
5. Check **Mcrich23-Toolkit**
6. Click **Add To Project**

# **Table Of Contents**

[Requirements](#requirements)

[Installation](#installation)


- [CardView](#cardview)

- [ConvertedGlyphImage](#convertedglyphimage)

- [GlyphImage](#glyphimage)

# **CardView**

## **Type:**

SwiftUI View

## **Description:**

Similar to the cards in the App Store.

## **Image:**

<img height="277" alt="CardView" src="https://user-images.githubusercontent.com/81453549/160887712-a05ae6b2-4915-448f-bca8-a6aba111a2fe.png"><img height="277" alt="OpenCard" src="https://user-images.githubusercontent.com/81453549/160888175-f886d89a-cd37-4b79-8c06-30c4b273a8d3.png">


## **Example:**
```
CardView(
    showHeader: .yes( // Wheather header should be visible
        headerTitle: "Title", // Title on the header
        headerSubtitle: "Subtitle", // Subtitle on the header
        headerSubtitleLocation: .below // If Subtitle is above or below the Title
    ),
    cards: $cards, // All the cards in the view
    showCreateButton: .yes( // Wheather create button should be visible
        create: { // Action when create (Plus Button) is tapped
            showCreateTicket.toggle()
        }
    ),
    maxWidth: 428, // The maximum width for cards
    selectedCards: { // Action called on selection of a card
        print("Selected Card")
    },
    deselectedCards: { // Action called on deselection of a card
        print("Deselected Card")
    }
)
```

# **ConvertedGlyphImage**

## **Type:**

SwiftUI Image

## **Description:**

Converts GlyphImage into a SwiftUI Image

## **Example:**

 ```
 ConvertedGlyphImage(GlyphImage: $GlyphImage, defaultIcon: Image(systemSymbol: .apps.iphone") { image in
     image
         .resizable()
         .aspectRatio(contentMode: .fit)
         .foregroundColor(.primary)
 }
 ```

# **GlyphImage**

## **Type:**

Enum

## **Description:**
Different types of glyphs, whether it be icons, or images. one variable for all the types.


Convert it to an image with `ConvertedGlyphImage`
 
 ## **Cases**
 
 ```
 GlyphImage.systemImage(named: "x.circle") // Uses SF Symbols
 GlyphImage.systemImage(named: "person1") // Uses Assets.xcassets
 GlyphImage.remoteImage(url: self.url) // Fetches from url and displays image
 GlyphImage.defaultIcon // The default icon that you specify
```
