//
//  PersonDetailsViewController.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/17/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import UIKit
import RxSwift

class PersonDetailsViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var personDetailsCollectionView: UICollectionView!
    @IBOutlet weak var personPopularityLabel: UILabel!
    @IBOutlet weak var personDeparmentLabel: UILabel!
    @IBOutlet weak var personGenderLabel: UILabel!
    
    //MARK:- VARIABLES
    var person: PersonCellViewModel?
    let personDetailsViewModel = PersonDetailsViewModel()
    let disposeBag = DisposeBag()
    
    //MARK:- FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarTitle()
        setupPersonBasicInformation()
        setupCollectionView()
        personDetailsViewModel.getImages(for: person!.id)
        bindImages()
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
    
    func setupCollectionView() {
        personDetailsCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        // Collection view padding 
        personDetailsCollectionView.contentInset = .init(top: 10, left: 20, bottom: 10, right: 20)
        let flowLayout = UICollectionViewFlowLayout()
        // Set Three image per row
        let width = (view.frame.size.width / 3) - 20
        flowLayout.itemSize = CGSize(width: width, height: width)
        personDetailsCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
    
    func bindImages() {
        personDetailsViewModel.personImages.bind(to: personDetailsCollectionView.rx.items(cellIdentifier: ImageCollectionViewCell.identifier, cellType: ImageCollectionViewCell.self)) {item, model, imageCell in
            imageCell.configure(withImage: model)
        }.disposed(by: disposeBag)
    }
}
