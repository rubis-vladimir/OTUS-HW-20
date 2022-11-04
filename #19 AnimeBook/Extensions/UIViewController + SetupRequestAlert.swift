//
//  UIViewController + SetupRequestAlert.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 26.10.2022.
//

import UIKit

extension UIViewController {
    
    /// Показывает алерт для настройки цвета
    ///  - Parameters:
    ///   - completion: захвать обновленного цвета
    func showSetupRequestAlert(completion: @escaping ([AnimeParameters: String]) -> ()) {
        
        let alert = UIAlertController(title: nil,
                                      message: "\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        let limitTF = UITextField()
        let startDatePicker = UIDatePicker()
        let endDatePicker = UIDatePicker()
        
        setupAlertContent(textField: limitTF,
                          startDatePicker: startDatePicker,
                          endDatePicker: endDatePicker,
                          alert: alert)
        
        let cancelAction = UIAlertAction(title: "Cancel".localize(),
                                         style: .cancel)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default) { _ in
            var parameters: [AnimeParameters: String] = [:]
            
            if let text = limitTF.text  {
                parameters[.limit] = text
            }
            parameters[.startDate] = startDatePicker.date.convertDateToString()
            parameters[.endDate] = startDatePicker.date.convertDateToString()
            completion(parameters)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        
        present(alert, animated: true)
    }
    
    /// Настройка внутреннего содержимого (элементов) аллерта
    private func setupAlertContent(textField: UITextField,
                                   startDatePicker: UIDatePicker,
                                   endDatePicker: UIDatePicker,
                                   alert: UIAlertController) {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Request Settings".localize()
            label.font = Constants.titleFont
            label.textAlignment = .center
            label.textColor = .white
            return label
        }()
        
        let labelsStack = UIStackView()
        let valuesStack = UIStackView()
        let stack = UIStackView()
        let generalStack = UIStackView()
        
        alert.view.subviews.first?
            .subviews.first?
            .subviews.first?.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
        alert.view.tintColor = .white
        
        ["Quantity", "Start Date", "End Date"].forEach {
            let label = UILabel()
            let text = $0.localize()
            label.text = text
            label.font = Constants.font
            label.textColor = .white
            labelsStack.addArrangedSubview(label)
        }
        
        [textField, startDatePicker, endDatePicker].forEach {
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = Constants.borderWidth
            $0.layer.cornerRadius = Constants.cornerRadius / 2
            $0.backgroundColor = .clear
            $0.tintColor = .white
            
            if let dp = $0 as? UIDatePicker  {
                dp.datePickerMode = .date
            } else if let tf = $0 as? UITextField {
                tf.textColor = .white
                tf.textAlignment = .center
            }
            valuesStack.addArrangedSubview($0)
        }
        
        startDatePicker.date = Calendar.current.date(byAdding: .day,
                                                     value: -365,
                                                     to: Date()) ?? Date()
        
        [labelsStack, valuesStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fillEqually
            stack.addArrangedSubview($0)
        }
        
        stack.spacing = 10
        generalStack.spacing = 20
        generalStack.axis = .vertical
        generalStack.translatesAutoresizingMaskIntoConstraints = false
        
        generalStack.addArrangedSubview(titleLabel)
        generalStack.addArrangedSubview(stack)
        alert.view.addSubview(generalStack)
        
        NSLayoutConstraint.activate([
            generalStack.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 15),
            generalStack.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            generalStack.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 10),
            
            valuesStack.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
