//
//  ExpandableCardView.swift
//  TicketOverwiew
//
//  Created by Jakub Slawecki on 21/02/2020.
//  Copyright © 2020 Jakub Slawecki. All rights reserved.
//

import SwiftUI
import SFSafeSymbols
import Kingfisher

public class TicketCardView_Control: ObservableObject {
    @Published public var anyTicketTriggered = false
    @Published var isSelectedHeight = UIScreen.main.bounds.height
    @Published var isSelectedWidth = UIScreen.main.bounds.width
    public init() {
    }
}

struct ExpandableCardView: View {
    
    let screen = UIScreen.main.bounds
    @EnvironmentObject var control: TicketCardView_Control
    @State var viewState = CGSize.zero
    @State var isDetectingLongPress = false
    @State var isSelected = false
    @State var maxWidth: CGFloat
    var selectedCard: () -> Void
    var deselectedCard: () -> Void
    
    var card: Card
    
    //MARK: Card size
    let normalCardHeight: CGFloat = 350
    let normalCardHorizontalPadding: CGFloat = 20

    let openCardAnimation = Animation.timingCurve(0.7, -0.35, 0.2, 0.9, duration: 0.45)
    
    //MARK: Gestures
    var press: some Gesture {
        TapGesture()
            .onEnded { finished in
                withAnimation(self.openCardAnimation) {
                    self.isDetectingLongPress = true
                    self.isSelected = true
                    selectedCard()
                    self.control.anyTicketTriggered = true
                    self.isDetectingLongPress = false
                    Mcrich23_Toolkit.getTopVC { vc in
                        vc.nearestNavigationController?.setNavigationBarHidden(true, animated: false)
                    }
                }
            }
    }
    
    var longPressAndRelese: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { _ in
                withAnimation(.easeIn(duration: 0.15)) {
                    self.isDetectingLongPress = true
               }
            }
            .onEnded { _ in
                withAnimation(self.openCardAnimation) {
                    self.isSelected = true
                    selectedCard()
                    self.control.anyTicketTriggered = true
                    self.isDetectingLongPress = false
                }
            }
    }

    var dragSelectedCard: some Gesture {
        DragGesture()
            .onChanged { value in
                self.viewState = value.translation
            }
            .onEnded { value in
                self.viewState = .zero
            }
    }
    
    //MARK: View Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    TopView(isSelected: self.$isSelected, selectedCard: selectedCard, deselectedCard: deselectedCard, maxWidth: maxWidth, card: self.card)
                        .environmentObject(self.control)
                        .frame(height: self.normalCardHeight)
                    
                    if self.isSelected {
                        ExpandableView(isSelected: self.$isSelected, card: self.card)
                        
                        Spacer()
                    }
                } //VStack
                .background(Color.white.opacity(0.01))
                .offset(y: self.isSelected ? self.viewState.height/2 : 0)
                .animation(.interpolatingSpring(mass: 1, stiffness: 90, damping: 15, initialVelocity: 1))
                .gesture(self.isSelected ? (self.dragSelectedCard) : (nil))
            } //ZStack
            //.drawingGroup() //test it
                
            //MARK: Card Appearance
            .background(Color(.secondarySystemGroupedBackground))
            .environmentObject(self.control)
            .clipShape(RoundedRectangle(cornerRadius: self.isSelected ? 0 : 15, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 10)
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 7)
            
            //MARK: Animation end effect (globa/local)
            .scaleEffect(self.isDetectingLongPress ? 0.95 : 1)
///           to test on preview change (in: .global) to (in: .local)
///            .offset(x: self.isSelected ? -geometry.frame(in: .local).minX : 0,
///                 y: self.isSelected ? -geometry.frame(in: .local).minY : 0)
            .offset(x: self.isSelected ? -geometry.frame(in: .global).minX : 0,
                    y: self.isSelected ? -geometry.frame(in: .global).minY : 0)
            
            .frame(height: self.isSelected ? screen.height : nil)
            .frame(width: self.isSelected ? screen.width : nil)
            
            .gesture(self.press)
            .gesture(self.longPressAndRelese)
        } //GeometryReader
        .frame(maxWidth: self.isSelected ? (screen.width - (normalCardHorizontalPadding * 2)) : maxWidth)
        .frame(height: normalCardHeight)
            
        //MARK: Appearance of other Cards when the selected Card opens
        .opacity(control.anyTicketTriggered && !isSelected ? 0 : 1)
        .blur(radius: control.anyTicketTriggered && !isSelected ? 20 : 0)
        .onRotate { _ in
            let screen = UIScreen.main.bounds
            self.control.isSelectedHeight = screen.height
            self.control.isSelectedWidth = screen.width
        }
    }

}


//MARK: TopView
struct TopView: View {
    @EnvironmentObject var control: TicketCardView_Control
    @Binding var isSelected: Bool
    var selectedCard: () -> Void
    var deselectedCard: () -> Void
    var maxWidth: CGFloat
    
    var card: Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    VStack {
                        switch self.card.image {
                        case .systemImage(let string):
                            Image(systemName: string)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                            if !isSelected {
                                VStack {
                                    Spacer()
                                    
                                    SystemMaterialView(style: .regular)
                                        .frame(height: 45)
                                }
                            }
                        case .assetImage(let string):
                            Image(string)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                            if !isSelected {
                                VStack {
                                    Spacer()
                                    
                                    SystemMaterialView(style: .regular)
                                        .frame(height: 45)
                                }
                            }
                        case .remoteImage(let named):
                            KFImage(named)
                                .placeholder({
                                    Image(systemSymbol: .photo)
                                        .resizable()
                                })
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                        case .defaultIcon:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: (maxWidth > control.isSelectedWidth) ? control.isSelectedWidth : nil)
                }
                VStack(alignment: .center, spacing: 0) {
                    if self.isSelected {
                        Rectangle()
                            .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.clear)
                    }
                    
                    //MARK: Upper part
                    HStack {
                        VStack(alignment: .leading) {
                            if self.card.subtitleLocation == .above {
                                Text(LocalizedStringKey(self.card.subtitle))
                                    .font(.caption)
                                    .foregroundColor(self.card.titleColor)
                                    .lineLimit(1)
                            }
                            Text(LocalizedStringKey(self.card.title))
                                .font(.headline)
                                .foregroundColor(self.card.titleColor)
                                .lineLimit(2)
                            
                            if self.card.subtitleLocation == .below {
                                Text(LocalizedStringKey(self.card.subtitle))
                                    .font(.caption)
                                    .foregroundColor(self.card.titleColor)
                                    .lineLimit(1)
                            }
                            
                        }
                        
                        Spacer()
                        
                        if self.isSelected {
                            Button(action: {
                                withAnimation(Animation.timingCurve(0.7, -0.35, 0.2, 0.9, duration: 0.45)) {
                                    Mcrich23_Toolkit.getTopVC { vc in
                                        vc.nearestNavigationController?.setNavigationBarHidden(false, animated: true)
                                    }
                                    self.isSelected = false
                                    deselectedCard()
                                    self.control.anyTicketTriggered = false }}) {
                                        Image(systemSymbol: .xmarkCircleFill)
                                            .foregroundColor(self.card.titleColor)
                                            .font(.system(size: 30, weight: .medium))
                                            .opacity(0.7)
                            }
                        }
                    } //HStack
                    .padding(.top)
                    .padding(.horizontal)
                    
                    
                    Spacer()
                    //MARK: Middle part
                    Spacer()
                    
                    
                    //MARK: Bottom part
                    if !isSelected || self.card.enableSummaryInCard {
                        HStack(alignment: .center) {
                            Text(LocalizedStringKey(self.card.briefSummary))
                                .foregroundColor(self.card.summaryColor)
                                .font(.caption)
                                .lineLimit(3)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                    }
                }
            }
        }
        .gesture(DragGesture(minimumDistance: 2, coordinateSpace: .local)
                    .onChanged({ dragGesture in
                        if dragGesture.predictedEndLocation.y > dragGesture.startLocation.y {
                            withAnimation(Animation.timingCurve(0.7, -0.35, 0.2, 0.9, duration: 0.45)) {
                                Mcrich23_Toolkit.getTopVC { vc in
                                    vc.nearestNavigationController?.setNavigationBarHidden(false, animated: true)
                                }
                                self.isSelected = false
                                deselectedCard()
                                self.control.anyTicketTriggered = false
                            }
                        }
        })
        )
    }
}

//MARK: BottomView

struct ExpandableView: View {
    @Binding var isSelected: Bool
    
    var card: Card
    
    
    var body: some View {
            if card.description == "" { // If using feature cell
                VStack(alignment: .center) {
                    ForEach(card.featureCells, id: \.self) { cell in
                        cell
                            .padding()
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 50)
            } else { // Using standard description
                VStack(alignment: .leading) {
                    Text(LocalizedStringKey(self.card.description))
                        .font(.body)
                        .foregroundColor(Color(.label))
                        .padding()
            }
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
