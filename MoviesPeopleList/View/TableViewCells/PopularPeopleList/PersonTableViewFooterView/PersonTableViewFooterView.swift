//
//  PersonTableViewFooterView.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/16/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import UIKit
class PersonTableViewFooterView: UITableViewHeaderFooterView {
    
    let activityIndicator : UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .gray)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    var shouldAnimate:Bool = false {
        didSet {
            shouldAnimate ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupActivityIndicator()
    }
    
    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
