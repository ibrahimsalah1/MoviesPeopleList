//
//  PopularPeopleViewController.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/15/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PopularPeopleViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var peopleListTableView: UITableView!
    
    //MARK:- VARIABLES
    let popualrPeopleViewModel = PopularPeopleViewModel()
    let disposeBag = DisposeBag()
    
    //MARK:- FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        popualrPeopleViewModel.getPopularPeople()
        bind()
        subscribeToWillDisplayCell()
        subscribeToPeopleDidSelectItem()
    }
    
    // Changing navigation bar title
    func setupNavigationBar() {
        navigationItem.title = "Popular People"
    }
    
    func bind() {
        //Bind peopleListTableView
        popualrPeopleViewModel.peopleCellViewModel.bind(to: peopleListTableView.rx.items(cellIdentifier:PersonTableViewCell.identifier, cellType: PersonTableViewCell.self)) { row, model, personCell in
            personCell.configure(withPersonCellViewModel: model)
        }.disposed(by: disposeBag)
    }
    
    func subscribeToWillDisplayCell() {
        //MARK:- Infinite scrolling
        //When reach to the end of table view request next people list
        peopleListTableView.rx.willDisplayCell.subscribe(onNext: { [weak self] _, indexPath in
            guard let self = self else { return }
            let lastRow = self.peopleListTableView.numberOfRows(inSection: 0) - 1
            if lastRow == indexPath.row {
                self.popualrPeopleViewModel.getPopularPeople()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToPeopleDidSelectItem(){
        peopleListTableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self else {return}
            if let personDetailsViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "PersonDetailsViewController") as? PersonDetailsViewController {
                personDetailsViewContoller.person = self.popualrPeopleViewModel.getPerson(for: indexPath.row)
                self.navigationController?.pushViewController(personDetailsViewContoller, animated: true)
            }
        }).disposed(by: disposeBag)
    }
}

extension PopularPeopleViewController : UITableViewDelegate {
    // Setup tableView configuration
    func setupTableView() {
        peopleListTableView.delegate = self
        peopleListTableView.register(PersonTableViewCell.self, forCellReuseIdentifier:PersonTableViewCell.identifier)
        peopleListTableView.register(PersonTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: PersonTableViewFooterView.identifier)
        peopleListTableView.separatorStyle = .none
        peopleListTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8)
        peopleListTableView.contentInset = .init(top: 2.5, left: 0, bottom: 2.5, right: 0)
    }
    
    // TableView Cell Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PersonTableViewFooterView.identifier) as! PersonTableViewFooterView
        footerView.shouldAnimate = !popualrPeopleViewModel.isFinishingLoading
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}

