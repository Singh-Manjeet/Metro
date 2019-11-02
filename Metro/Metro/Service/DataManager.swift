//
//  DataManager.swift
//  Metro
//
//  Created by Manjeet Singh on 2/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation
import Alamofire

struct Constants {
    struct Service {
        // using a temporary working rest api and mapping a local stations.json file using Charles web debugging proxy
        static let getStations = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    }
}

typealias completionBlock = (Result<[Station], APIError>) -> Void
class DataManager {
    
    // MARK: - Singleton
    static let shared = DataManager()
    private var stations: [Station]?
    
    /* To load a local json containing stations data
     It communicate the result using a completion block
     */
    func loadMetroStations(filename fileName: String, onCompletion :@escaping completionBlock) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let stations = try decoder.decode([Station].self, from: data)
                onCompletion(.success(stations))
            } catch {
                onCompletion(.failure(APIError()))
            }
        }
        
        onCompletion(.failure(APIError()))
    }
    
    /* To elaborate how we map a local json file using
       Charles Web Debugging Proxy
    */
    func fetchMetroStations(onCompletion :@escaping completionBlock) {
       
        guard isConnectedToInternet(),
              let url = URL(string: Constants.Service.getStations) else {
                onCompletion(.failure(APIError()))
                return
        }
        
        AF.request(url)
            .responseDecodable(queue: .global(qos: .background)) { (response: (DataResponse<[Station], AFError>)) in

                switch response.result {
                case .success(let stations):
                   onCompletion(.success(stations))
                case .failure(let error):
                    onCompletion(.failure(APIError(message: error.localizedDescription)))
                }
        }
    }
}

private extension DataManager {
    func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
