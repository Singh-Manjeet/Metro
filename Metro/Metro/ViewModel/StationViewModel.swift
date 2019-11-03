//
//  StationViewModel.swift
//  Metro
//
//  Created by Manjeet Singh on 2/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation

// MARK: - Data State
enum DataState<T, E> {
    case loading
    case loaded(T)
    case error(E)
}

enum SearchMode {
    case forward
    case backward
}

// MARK: - Container
struct Container {
    let stations: [Station]
}

// MARK: - StationViewModelDelegate
protocol StationViewModelDelegate: class {
    func stateDidChange(_ state: APIDataState<Container>)
}

typealias APIDataState<T> = DataState<T, APIError>

// MARK: - StationViewModel
final class StationViewModel {
    
    // MARK: - Vars
    var stations: [Station]?
    var journeyStartedAt: Station?
    var journeyEndedAt: Station?
    var searchMode: SearchMode = .forward
    
    weak var delegate: StationViewModelDelegate?
    
    private(set) var state: APIDataState<Container> = .loading {
        didSet {
            delegate?.stateDidChange(state)
        }
    }
    
    // MARK: - View LifeCycle
    init(delegate: StationViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func loadStations() {
        DataManager.shared.loadMetroStations(filename: "stations") { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let stations):
                strongSelf.stations = stations
                strongSelf.delegate?.stateDidChange(.loaded(Container(stations: stations)))
            case .failure(let error):
                strongSelf.delegate?.stateDidChange(.error(APIError(message: error.message)))
            }
        }
    }
    
    var isValidJourney: Bool {
        guard journeyStartedAt != journeyEndedAt else { return false }
        return true
    }
    
    var totalFare: Double {
        
        guard isValidJourney,
            let allStations = stations,
            let firstStation = journeyStartedAt,
            let lastStation = journeyEndedAt else { return 0.0 }
        
        var totalFare = 0.0
        var currentStation = lastStation
        var previousStation: Station!
        
        while currentStation.id != firstStation.id {
            var previousStations = [Station]()
            
            switch searchMode {
            case .forward:
                previousStations = allStations.filter { $0.nextStationId == currentStation.id }
                if previousStations.count == 0 {
                    searchMode = .backward
                }else if previousStations.count > 1 {
                    totalFare += currentStation.fare
                    previousStation =  previousStations.filter { $0.route == firstStation.route && $0.direction == firstStation.direction }.first
                    if previousStation == nil {
                        previousStation =  previousStations.filter { $0.route == firstStation.route }.first
                    }
                    currentStation = previousStation!
                }else {
                    totalFare += currentStation.fare
                    previousStation = previousStations.first
                    currentStation = previousStation!
                }
            case .backward:
                if currentStation.hasInterchange {
                    previousStations = allStations.filter { $0.previousStationId == currentStation.id }
                }else {
                    previousStations = allStations.filter { $0.id == currentStation.previousStationId }
                }
                
                if previousStations.count == 0 {
                    searchMode = .forward
                }else if previousStations.count > 1 {
                    previousStation =  previousStations.filter { $0.route == firstStation.route && $0.direction == firstStation.direction }.first
                    if previousStation == nil {
                        previousStation =  previousStations.filter { $0.route == firstStation.route }.first
                    }
                    
                }else {
                    totalFare += currentStation.fare
                    previousStation = previousStations.first
                    currentStation = previousStation!
                }
            }
        }
        
        return totalFare
    }
}
