//
//  Get TopView.swift
//  
//
//  Created by Morris Richman on 4/16/22.
//

import Foundation
import UIKit

extension Mcrich23_Toolkit {
    /**
     Gets the top UIViewController
     - returns: A UIViewController
     
     # Example #
     ```
     Mcrich23_Toolkit.getTopVC { topVC in
        topVC.present {
            EmptyView()
        }
     }
     ```
     */
    public static func getTopVC(completion: @escaping (_ topVC: UIViewController) -> Void) {
        guard var topVC = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first?.rootViewController else {
            return
        }
        // iterate til we find the topmost presented view controller
        // if you don't you'll get an error since you can't present 2 vcs from the same level
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        completion(topVC)
    }
    /**
     Gets the top UIViewController
     - returns: A UIViewController
     
     # Example #
     ```
     Mcrich23_Toolkit.topVC().present {
        EmmptyView()
     }
     ```
     */
    public static func topVC() -> UIViewController {
        guard var topVC = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first?.rootViewController else {
            return (UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first?.rootViewController)!
        }
        // iterate til we find the topmost presented view controller
        // if you don't you'll get an error since you can't present 2 vcs from the same level
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }
}
