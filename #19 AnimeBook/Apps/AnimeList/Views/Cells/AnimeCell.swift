//
//  AnimeCell.swift
//  #19 AnimeBook
//
//  Created by Владимир Рубис on 21.10.2022.
//

import UIKit
import SnapKit

class AnimeCell: UICollectionViewCell {
    
    var animeImageView = UIImageView()
    var animeTitleView = UILabel()
    var container = UIStackView()
    
    /// Конфигурация элементов 
    func configure(with model: AnimeModel) {
        if let data = model.imageData,
           let image = UIImage(data: data) {
            animeImageView.image = image
        }
        
        animeImageView.contentMode = .scaleAspectFill
        animeImageView.clipsToBounds = true
        animeImageView.layer.cornerRadius = Constants.cornerRadius
        
        animeTitleView.text = model.title.localize()
        animeTitleView.textColor = .white
        animeTitleView.textAlignment = .center
        animeTitleView.numberOfLines = 2
        animeTitleView.adjustsFontSizeToFitWidth = true
        animeTitleView.minimumScaleFactor = 0.5
        animeTitleView.font = Constants.font
        
        container.distribution = .fill
        container.axis = .vertical
        container.clipsToBounds = true
        container.layer.cornerRadius = Constants.cornerRadius
        
        setupConstraints()
    }
    
    /// Настройка констрейнтов
    private func setupConstraints() {
        container.addArrangedSubview(animeImageView)
        container.addArrangedSubview(animeTitleView)
        addSubview(container)
        
        container.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
        }
        
        animeTitleView.snp.makeConstraints { make in
            make.height.size.equalTo(45)
        }
    }
}
