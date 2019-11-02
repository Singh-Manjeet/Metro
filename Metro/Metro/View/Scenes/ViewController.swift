//
//  ViewController.swift
//  Metro
//
//  Created by Manjeet Singh on 2/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets & Vars
    private var viewModel: StationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StationViewModel(delegate: self)
    }
}

// MARK: - StationViewModelDelegate
extension ViewController: StationViewModelDelegate {
    func stateDidChange(_ state: APIDataState<Container>) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            
            switch state {
            case .loaded: break
            case .error(let error):
                strongSelf.showAlert(with: error.message)
            default:
                break
            }
        }
    }
}

private extension ViewController {
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

