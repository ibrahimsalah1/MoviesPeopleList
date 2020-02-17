//
//  PeopleSearchViewController.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/17/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import UIKit
import RxSwift

class PeopleSearchViewController: UIViewController {
    @IBOutlet weak var peopleSearchTableView:UITableView!
    let peopleSearchViewModel = PeopelSearchViewModel()
    
    let searchController = UISearchController()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupTableView()
        bind()
        subscribeToWillDisplayCell()
        subscribeToPeopleDidSelectItem()
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    func bind() {
        //Bind peopleSearchViewModel
        peopleSearchViewModel.peopleCellViewModel.bind(to: peopleSearchTableView.rx.items(cellIdentifier:PersonTableViewCell.identifier, cellType: PersonTableViewCell.self)) { row, model, personCell in
            personCell.configure(withPersonCellViewModel: model)
        }.disposed(by: disposeBag)
    }
    
    func subscribeToWillDisplayCell() {
        //MARK:- Search Infinite scrolling
        peopleSearchTableView.rx.willDisplayCell.subscribe(onNext: { [weak self] _, indexPath in
            guard let self = self else { return }
            let lastRow = self.peopleSearchTableView.numberOfRows(inSection: 0) - 1
            if lastRow == indexPath.row {
                guard let searchText = self.searchController.searchBar.text , searchText != "" else {return}
                self.peopleSearchViewModel.searchPeople(withQuery: searchText)
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToPeopleDidSelectItem(){
        peopleSearchTableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let self = self else {return}
            if let personDetailsViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "PersonDetailsViewController") as? PersonDetailsViewController {
                personDetailsViewContoller.person = self.peopleSearchViewModel.getPerson(for: indexPath.row)
                self.navigationController?.pushViewController(personDetailsViewContoller, animated: true)
            }
        }).disposed(by: disposeBag)
    }
}

extension PeopleSearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text , query != "" else {return}
        peopleSearchViewModel.searchPeople(withQuery:query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
         searchController.searchBar.becomeFirstResponder()
    }
}


extension PeopleSearchViewController : UITableViewDelegate {
    // Setup tableView configuration
    func setupTableView() {
        peopleSearchTableView.delegate = self
        peopleSearchTableView.register(PersonTableViewCell.self, forCellReuseIdentifier:PersonTableViewCell.identifier)
        peopleSearchTableView.register(PersonTableViewFooterView.self, forHeaderFooterViewReuseIdentifier: PersonTableViewFooterView.identifier)
        peopleSearchTableView.separatorStyle = .none
        peopleSearchTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8)
        peopleSearchTableView.contentInset = .init(top: 2.5, left: 0, bottom: 2.5, right: 0)
    }
    
    // TableView Cell Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
