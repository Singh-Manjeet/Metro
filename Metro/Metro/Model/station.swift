//
//  Station.swift
//  Metro
//
//  Created by Manjeet Singh on 2/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

enum RouteType: String, Codable {
    case blue
    case yellow
    case green
    case multiple
}

enum RouteDirection: String, Codable {
    case north
    case south
    case east
    case west
}

struct Station : Codable {
    let id: Int?
    let title: String
    let route: RouteType
    let previous: Int?
    let direction: RouteDirection
    let next: Int?
    let hasInterchange: Bool
    let fair: Double
    
    enum CodingKeys: String, CodingKey {
         case id
         case title
         case route
         case previous = "previous_station_id"
         case direction
         case next = "next_station_id"
         case hasInterchange = "interchange_available"
         case fair
    }
}
