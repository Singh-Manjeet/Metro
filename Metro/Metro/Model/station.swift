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

struct Station : Codable, Equatable {
    let id: Int?
    let title: String
    let route: RouteType
    let previousStationId: Int?
    let direction: RouteDirection
    let nextStationId: Int?
    let hasInterchange: Bool
    let fare: Double
    
    enum CodingKeys: String, CodingKey {
         case id
         case title
         case route
         case previousStationId = "previous_station_id"
         case direction
         case nextStationId = "next_station_id"
         case hasInterchange = "interchange_available"
         case fare
    }
}
