//
//  UICollectionView + Register.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 29.10.2022.
//

import UIKit

extension UICollectionView {
    
    /// Регистрирует ячейку коллекции
    func register<T: UICollectionViewCell>(_ classType: T.Type) {
        let string = String(describing: classType)
        register(classType,
                 forCellWithReuseIdentifier: string)
    }
    
    /// Переиспользование ячейки коллекции
    func dequeueReusableCell<T: UICollectionViewCell>(_ classType: T.Type,
                                                      indexPath: IndexPath) -> T {
        let string = String(describing: classType)
        return dequeueReusableCell(withReuseIdentifier: string,
                                   for: indexPath) as! T
    }
}
