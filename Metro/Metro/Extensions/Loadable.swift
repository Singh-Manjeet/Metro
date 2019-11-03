//
//  Loadable.swift
//  Metro
//
//  Created by Manjeet Singh on 4/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

protocol Loadable {
    func showLoadingView()
    func hideLoadingView()
}

private struct LoadingViewConstants {
    static let tag = 1234
}

/// Default implementation for UIViewController
extension Loadable where Self: UIViewController {
    
    func showLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.animate()
        
        loadingView.tag = LoadingViewConstants.tag
    }
    
    func hideLoadingView() {
        view.subviews.forEach { subview in
            if subview.tag == LoadingViewConstants.tag {
                subview.removeFromSuperview()
            }
        }
    }
}
