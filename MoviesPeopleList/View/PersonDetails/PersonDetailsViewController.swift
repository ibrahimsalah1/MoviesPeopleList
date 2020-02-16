//
//  PersonDetailsViewController.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/17/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var personDetailsCollectionView: UICollectionView!
    @IBOutlet weak var personPopularityLabel: UILabel!
    @IBOutlet weak var personDeparmentLabel: UILabel!
    @IBOutlet weak var personGenderLabel: UILabel!
    
    //MARK:- VARIABLES
    var person: PersonCellViewModel?
    
    //MARK:- FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarTitle()
        setupPersonBasicInformation()
        setupCollectionView()
    }
    
    func setupNavigationBarTitle() {
        navigationItem.title = person?.name ?? ""
    }
    
    func setupPersonBasicInformation() {
        guard let person = person else {return}
        personPopularityLabel.text = "\(person.rate ?? 0.0)%"
        personGenderLabel.text = person.gender == 1 ? "Female" : "Male"
        personDeparmentLabel.text = "Knowing for \(person.department)"
    }
}


extension PersonDetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func setupCollectionView() {
        personDetailsCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        personDetailsCollectionView.delegate = self
        personDetailsCollectionView.dataSource = self
        personDetailsCollectionView.contentInset = .init(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return .init(width: (view.frame.width / 3) - 20 , height: 100)
    }
}
