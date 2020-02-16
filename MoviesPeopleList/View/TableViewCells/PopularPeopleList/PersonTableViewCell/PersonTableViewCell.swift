//
//  PersonTableViewCell.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/15/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import UIKit
import Kingfisher

class PersonTableViewCell: UITableViewCell {
    
    var containerView: CardView = {
        let view = CardView()
        view.backgroundColor = .white
        view.cornerRadius = 14
        return view
    }()
    
    var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.constrainWidth(constant: 100)
        imageView.constrainHeight(constant: 100)
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 0.8129548373).cgColor
        return imageView
    }()
    
    var personNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    var popularityLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    var departmentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    lazy var personInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personNameLabel, popularityLabel, departmentLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8)
        setupContainerView()
        setupWholeInfoStackView()
    }
    
    func configure(withPersonCellViewModel person: PersonCellViewModel) {
        personNameLabel.text = person.name
        personImageView.kf.indicatorType = .activity
        personImageView.kf.setImage(with:ImageSize.medium.path(image: person.imageProfile ?? "") , placeholder: nil, options: [.transition(.fade(0.5))])
        departmentLabel.text = "Konwing for \(person.department)"
        popularityLabel.text = "Popularity: \(person.rate ?? 0.0)%"
    }
    
    func setupContainerView() {
        addSubview(containerView)
        containerView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    func setupWholeInfoStackView() {
        let wholeStackView = UIStackView(arrangedSubviews: [personImageView, personInfoStackView])
        wholeStackView.axis = .horizontal
        wholeStackView.spacing = 10
        wholeStackView.alignment = .center
        containerView.addSubview(wholeStackView)
        wholeStackView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
