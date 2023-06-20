//
//  DeviceRotationViewModifier.swift
//  
//
//  Created by Morris Richman on 4/12/22.
//

import Foundation
import SwiftUI

public struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    public init(action: @escaping (UIDeviceOrientation) -> Void) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    /**
     Run code whenever the device rotates.
     
     - parameter action: Run this action on rotation.
     
     # Example #
     ```
     @State var orientation = UIDevice.current.orientation
     var body: some view {
         VStack {
             if orientation == .portrait {
                 Text("Hello World")
             }
         }
         .onRotate { newOrientation in
             orientation = newOrientation
         }
     }
     ```
     
     */
    public func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
