//
//  ViewController.swift
//  Metro
//
//  Created by Manjeet Singh on 2/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
//        DataManager.shared.loadMetroStations(filename: "stations") { result in
//
//            switch result {
//            case .success(let stations):
//                print(stations)
//            case .failure:break
//            }
//        }
        
        
        DataManager.shared.fetchMetroStations { result in

            switch result {
            case .success(let stations):
                print(stations)
            case .failure:break
            }
        }
    }


}

