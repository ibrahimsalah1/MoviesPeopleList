//
//  PeopleSearchViewModel.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/17/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import RxCocoa
import RxSwift

class PeopelSearchViewModel {
    
    private let service: Service
    private let disposeBag = DisposeBag()
    var peopleCellViewModel = BehaviorRelay<[PersonCellViewModel]>(value: [])
    
    private var searchedPeople: [Person] = [Person]()
    private var totalPages: Int = 1
    private var currentPage = 0
    private var shouldLoadMore:Bool = false
    private var query = ""
    var isFinishingLoading:Bool = false
    
    init(service:Service = Service()) {
        self.service = service
    }
    
    func searchPeople(withQuery query:String) {
        // Reset to initial data if query search changed to other query
        // else load more pages for this query search
        if self.query != query {
            resetData()
        }
        self.query = query
        guard !shouldLoadMore, self.totalPages > self.currentPage else {return}
        shouldLoadMore = true
        currentPage += 1
        let request:PeopleRouter = PeopleRouter.searchPeople(query: query, page: currentPage)
        service.getResponse(request:request).subscribe(onNext: { (response: BaseResponse<Person>) in
            self.shouldLoadMore = false
            self.searchedPeople = response.results
            if let totalPges = response.total_pages {
                self.totalPages = totalPges
                self.isFinishingLoading = totalPges == self.currentPage
            }
            self.searchedPeople.forEach {
                let element = PersonCellViewModel(id: $0.id, name: $0.name, imageProfile: $0.profilePath, rate: round(($0.popularity ?? 0.0) * 100) / 100, department: $0.department ?? "", gender: $0.gender)
                self.peopleCellViewModel.add(element:element)
            }
        }, onError: {error in
            // Will handle all types of errors
        }).disposed(by: disposeBag)
    }
    
    // Reset all data  when search with new query
    func resetData() {
        totalPages = 1
        currentPage = 0
        shouldLoadMore = false
        isFinishingLoading = false
        searchedPeople.removeAll()
        peopleCellViewModel.removeAll()
    }
    
    func getPerson(for index:Int) -> PersonCellViewModel {
        return peopleCellViewModel.value[index]
    }
}
