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
}
