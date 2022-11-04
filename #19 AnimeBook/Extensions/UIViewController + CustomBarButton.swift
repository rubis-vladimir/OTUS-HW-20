//
//  UIViewController + CustomBarButton.swift
//  #18 TalkingFriends
//
//  Created by Владимир Рубис on 18.10.2022.
//

import UIKit

extension UIViewController {
    
    /// Создает кастомную кнопку
    ///  - Parameters:
    ///   - imageName: название изображения
    ///   - title: текст кнопки
    ///   - selector: действие
    func createCustomBarButton(imageName: String?,
                               title: String?,
                               selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        
        if let imageName = imageName {
            button.setImage(
                UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate),
                for: .normal
            )
            button.imageView?.contentMode = .scaleAspectFit
        }
        
        if let title = title {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Constants.font
        }
        
        button.tintColor = Constants.textColor
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}
