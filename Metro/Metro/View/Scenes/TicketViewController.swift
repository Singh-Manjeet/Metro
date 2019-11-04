//
//  TicketViewController.swift
//  Metro
//
//  Created by Manjeet Singh on 4/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController {
    
    //MARK: - IBOutlets & Vars
    @IBOutlet private weak var ticketImageView: UIImageView!
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    
    var ticketInformation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.cornerRadius = 22.0
        informationLabel.text = ticketInformation
    }
    
    // MARK: - Actions
    @IBAction func didTapCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
