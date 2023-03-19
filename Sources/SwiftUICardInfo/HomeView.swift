//
//  HomeView.swift
//  TicketOverwiew
//
//  Created by Jakub Slawecki on 21/02/2020.
//  Copyright © 2020 Jakub Slawecki. All rights reserved.
//

import SwiftUI
import SwiftUIX

/**
 Similar to the cards in the App Store.
 
 - parameter showHeader: Wheather header should be visible.
 - parameter cards: All the cards in the view.
 - parameter showCreateButton: Wheather create button should be visible
 - parameter maxWidth: The maximum width for cards.
 - parameter selectedCards: Action called on selection of a card.
 - parameter deselectedCards: Action called on deselection of a card.
 
 # Example #
 ```
 CardView(
     showHeader: .yes(
         headerTitle: "Title",
         headerSubtitle: "Subtitle",
         headerSubtitleLocation: .below
     ),
     cards: $cards,
     showCreateButton: .yes(
         create: {
             showCreateTicket.toggle()
         }
     ),
     maxWidth: 428,
     selectedCards: {
         print("Selected Card")
     },
     deselectedCards: {
         print("Deselected Card")
     }
 )                    
 ```
 
 */
public struct CardView: View {
    let screen = UIScreen.main.bounds
    
    @ObservedObject var control = TicketCardView_Control()
    @State var showHeader: ShowHeader
    //change cardData to real tickets
    @Binding var cards: [Card]
    @State var showCreateButton: ShowCreateButton
    @State var maxWidth: CGFloat
    var selectedCards: () -> Void
    var deselectedCards: () -> Void
    
    public init(showHeader: ShowHeader, cards: Binding<[Card]>, showCreateButton: ShowCreateButton, selectedCards: @escaping () -> Void, deselectedCards: @escaping () -> Void) {
        self.showHeader = showHeader
        self._cards = cards
        self.showCreateButton = showCreateButton
        self.selectedCards = selectedCards
        self.deselectedCards = deselectedCards
        self.maxWidth = screen.width - (20 * 2)
    }
    public init(showHeader: ShowHeader, cards: Binding<[Card]>, showCreateButton: ShowCreateButton, maxWidth: CGFloat, selectedCards: @escaping () -> Void, deselectedCards: @escaping () -> Void) {
        self.showHeader = showHeader
        self._cards = cards
        self.showCreateButton = showCreateButton
        self.selectedCards = selectedCards
        self.deselectedCards = deselectedCards
        self.maxWidth = maxWidth
    }
    public init(showHeader: ShowHeader, cards: Binding<[Card]>, showCreateButton: ShowCreateButton) {
        self.showHeader = showHeader
        self._cards = cards
        self.showCreateButton = showCreateButton
        self.selectedCards = {}
        self.deselectedCards = {}
        self.maxWidth = screen.width - (20 * 2)
    }
    public init(showHeader: ShowHeader, cards: Binding<[Card]>, showCreateButton: ShowCreateButton, maxWidth: CGFloat) {
        self.showHeader = showHeader
        self._cards = cards
        self.showCreateButton = showCreateButton
        self.selectedCards = {}
        self.deselectedCards = {}
        self.maxWidth = maxWidth
    }
    
    public var body: some View {
        
        ZStack {
            ScrollView(.vertical) {
                switch showHeader {
                case .yes(let headerTitle, let headerSubtitle, let headerSubtitleLocation):
                        ScrollViewTitleView(headerTitle: headerTitle, headerSubtitile: headerSubtitle, headerSubtitleLocation: headerSubtitleLocation, showCreateButton: showCreateButton)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .blur(radius: control.anyTicketTriggered ? 20 : 0)
                case .no:
                    EmptyView()
                }
                
                ForEach(self.cards) { card in
                    ExpandableCardView(maxWidth: maxWidth, selectedCard: selectedCards, deselectedCard: deselectedCards, card: card)
                            .environmentObject(self.control)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                }
                
            }
            
            VStack {
                SystemMaterialView(style: .regular)
                    .frame(height: self.control.anyTicketTriggered ? 0 : 40)
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .environmentObject(control)
        .statusBar(hidden: self.control.anyTicketTriggered)
    }
    
}

struct ScrollViewTitleView: View {
    @State var headerTitle: String
    @State var headerSubtitile: String
    @State var headerSubtitleLocation: SubtitleLocation
    @State var showCreateButton: ShowCreateButton
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if headerSubtitleLocation == .above {
                Text(LocalizedStringKey(headerSubtitile))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.bottom, -5)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            HStack(alignment: .center) {
                Text(LocalizedStringKey(headerTitle))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.label))
                Spacer()
                
                switch showCreateButton {
                case .yes(let create):
                    ShowActionButton(systemSymbol: "plus") {
                        create()
                    }
                case .no:
                    EmptyView()
                }
                
            }
            if headerSubtitleLocation == .below {
                Text(LocalizedStringKey(headerSubtitile))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
        }
        .padding(.bottom, -5)
        
    }
    
}


//Ticket to -> Card
public struct Card : Identifiable, Equatable {
    public var id = UUID()
    
    public var title: String
    public var subtitle: String
    public var subtitleLocation: SubtitleLocation
    public var titleColor: Color
    public var briefSummary: String
    public var summaryColor: Color
    public var enableSummaryInCard: Bool
    public var description: String
    public var image: GlyphImage
    public var featureCells: [FeatureCell]
    
    public init(title: String, subtitle: String, subtitleLocation: SubtitleLocation, titleColor: Color, briefSummary: String, summaryColor: Color, enableSummaryInCard: Bool, description: String, image: GlyphImage) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleLocation = subtitleLocation
        self.titleColor = titleColor
        self.briefSummary = briefSummary
        self.summaryColor = summaryColor
        self.enableSummaryInCard = enableSummaryInCard
        self.description = description
        self.image = image
        self.featureCells = []
    }
    public init(title: String, subtitle: String, subtitleLocation: SubtitleLocation, titleColor: Color, briefSummary: String, summaryColor: Color, enableSummaryInCard: Bool, image: GlyphImage, featureCells: [FeatureCell]) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleLocation = subtitleLocation
        self.titleColor = titleColor
        self.briefSummary = briefSummary
        self.summaryColor = summaryColor
        self.enableSummaryInCard = enableSummaryInCard
        self.description = ""
        self.image = image
        self.featureCells = featureCells
    }
}

public enum SubtitleLocation: Hashable, Equatable {
    case above
    case below
    case none
}
///Wheather create button should be visible
public enum ShowCreateButton {
    ///- parameter create: Action when create (Plus Button) is tapped
    case yes(create: () -> Void)
    case no
}
/// Wheather header should be visible
public enum ShowHeader {
    /**
     - parameter headerTitle: Title on the header.
     - parameter headerSubtitle: Subtitle on the header.
     - parameter headerSubtitleLocation: If Subtitle is above or below the Title.
     */
    case yes(headerTitle: String, headerSubtitle: String, headerSubtitleLocation: SubtitleLocation)
    case no
}
