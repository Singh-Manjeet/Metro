//
//  UIStoryboard+Extension.swift
//  Metro
//
//  Created by Manjeet Singh on 5/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

extension UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    
    // MARK: The uniform place to access all the different storyboards
    enum Storyboard: String {
        case ticket
        
        var name: String {
            return rawValue.capitalized
        }
    }
    
    // MARK: Convenience Initializer
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.name, bundle: bundle)
    }
    
    // MARK: Class Functions
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.name, bundle: bundle)
    }
    
    // MARK: View Controller Instantiation from Generics
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}
