//
//  ImageCollectionViewCell.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/17/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import UIKit
class ImageCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    func configure(withImage image: Image){
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with:ImageSize.original.path(image: image.imagePath) , placeholder: nil, options: [.transition(.fade(0.5))])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

