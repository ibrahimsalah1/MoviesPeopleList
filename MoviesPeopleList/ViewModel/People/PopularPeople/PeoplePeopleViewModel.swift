//
//  PeoplePeopleViewModel.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/15/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PopularPeopleViewModel {
    private let service: Service
    private let disposeBag = DisposeBag()
    var peopleCellViewModel = BehaviorRelay<[PersonCellViewModel]>(value: [])
    
    private var people: [Person] = [Person]()
    private var totalPages: Int = 1
    private var currentPage = 0
    
    // check if service now in calling
    private var shouldLoadMore:Bool = false
    
    // Check is pagaination ended
    var isFinishingLoading:Bool = false
    
    init(service:Service = Service()) {
        self.service = service
    }
    
    func getPopularPeople() {
        guard !shouldLoadMore, self.totalPages > self.currentPage else {return}
        shouldLoadMore = true
        currentPage += 1
        let request:PeopleRouter = PeopleRouter.getPopularPeople(page: currentPage)
        // Cancel all pervious requests before request a new one
        service.invalidateAllRequests()
        service.getResponse(request:request).subscribe(onNext: { (response: BaseResponse<Person>) in
            self.shouldLoadMore = false
            self.people = response.results
            if let totalPges = response.total_pages {
                self.totalPages = totalPges
                // Reached at the end of pages
                self.isFinishingLoading = totalPges == self.currentPage
            }
            self.people.forEach {
                let element = PersonCellViewModel(id: $0.id, name: $0.name, imageProfile: $0.profilePath, rate: round(($0.popularity ?? 0.0) * 100) / 100, department: $0.department ?? "", gender: $0.gender)
                self.peopleCellViewModel.add(element:element)
            }
        }, onError: {error in
            // Will handle all types of errors
        }).disposed(by: disposeBag)
    }
    
    // Get a required person for index
    func getPerson(for index:Int) -> PersonCellViewModel {
        return peopleCellViewModel.value[index]
    }
}
