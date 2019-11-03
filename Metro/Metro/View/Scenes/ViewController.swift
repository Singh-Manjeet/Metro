//
//  ViewController.swift
//  Metro
//
//  Created by Manjeet Singh on 2/11/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

enum PickerMode {
    case from
    case to
}

class ViewController: UIViewController, Loadable {
    
    //MARK: - IBOutlets & Vars
    @IBOutlet private weak var fromTextField: UITextField!
    @IBOutlet private weak var toTextField: UITextField!
    @IBOutlet private weak var generateTicketButton: UIButton!
    @IBOutlet private weak var calculateFairButton: UIButton!
    @IBOutlet private weak var stationPicker: UIPickerView!
    @IBOutlet private weak var informationLabel: UILabel!
    
    private var viewModel: StationViewModel!
    private var pickerMode: PickerMode = .from
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel = StationViewModel(delegate: self)
        showLoadingView()
        viewModel.loadStations()
    }
}

// MARK: - StationViewModelDelegate
extension ViewController: StationViewModelDelegate {
    func stateDidChange(_ state: APIDataState<Container>) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingView()
            
            switch state {
            case .loaded:
                strongSelf.stationPicker.reloadAllComponents()
            case .error(let error):
                strongSelf.showAlert(with: error.message)
            default:
                break
            }
        }
    }
}

// MARK: - Helpers
private extension ViewController {
    func setupUI() {
        [fromTextField, toTextField, generateTicketButton, calculateFairButton].forEach {
            $0?.layer.cornerRadius = ($0?.frame.height ?? 44) / 2
            $0?.layer.borderColor = UIColor.orange.cgColor
            $0?.layer.borderWidth = 1.0
        }
    }
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func animatePickerView(show: Bool) {
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.stationPicker.alpha = show ? 1.0 : 0
            strongSelf.stationPicker.isUserInteractionEnabled = show
            strongSelf.stationPicker.layoutIfNeeded()
        }, completion: nil)
    }
    
    // Actions
    @IBAction func didTapCalculateFairButton(_ sender: UIButton) {
        
        guard viewModel.isValidJourney else { return }
        informationLabel.isHidden = false
        informationLabel.text = "Total fare between \(viewModel.journeyStartedAt!.title) and \(viewModel.journeyEndedAt!.title) is $\(viewModel.totalFare.rounded())"
    }
}

// MARK: - Picker View
extension ViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        guard let stations = viewModel.stations else { return 0 }
        return stations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        guard let stations = viewModel.stations else { return }
        let stationAtRow = stations[row]
        
        switch pickerMode {
        case .from:
            fromTextField.text = stationAtRow.title
            viewModel.journeyStartedAt = stationAtRow
        case .to:
            toTextField.text = stations[row].title
            viewModel.journeyEndedAt = stationAtRow
        }
        
        animatePickerView(show: false)
        view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let stationAtRow = viewModel.stations![row]
        let myTitle = NSAttributedString(string: stationAtRow.title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange])

        return myTitle
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        informationLabel.isHidden = true
        pickerMode = textField == fromTextField ? .from : .to
        animatePickerView(show: true)
        return false
    }
}

