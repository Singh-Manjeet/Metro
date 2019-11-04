//
//  Router.swift
//  Metro
//
//  Created by Manjeet Singh on 5/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

enum RouterSegue {
    case ticket
}

protocol Routing {
    func route(to seque: RouterSegue, from context: UIViewController, parameters: Any?)
}

// MARK: - A Common place to navigate in between the app
class Router: Routing {
    
    func route(to seque: RouterSegue, from context: UIViewController, parameters: Any?) {
        
        switch seque {
        case .ticket:
            
            guard let ticketInformation = parameters as? String else { return }
            let ticketViewController = Router.makeTicketViewController()
            ticketViewController.ticketInformation = ticketInformation
            ticketViewController.modalPresentationStyle = .popover
            context.navigationController?.present(ticketViewController, animated: true)
        }
    }
}

// MARK: - Helper Functions
private extension Router {
    static func makeTicketViewController() -> TicketViewController {
        return UIStoryboard(storyboard: .ticket).instantiateViewController()
    }
}
