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
    let disposeBag = DisposeBag()
    var peopleCellViewModel = BehaviorRelay<[PersonCellViewModel]>(value: [])
    
    private var people: [Person] = [Person]()
    private var totalPages: Int = 1
    private var currentPage = 0
    private var shouldLoadMore = false
    
    init(service:Service = Service()) {
        self.service = service
    }
    
    func getPopularPeople() {
        guard !shouldLoadMore, self.totalPages > self.currentPage else {return}
        shouldLoadMore = true
        currentPage += 1
        let request:PeopularPeopleRouter = PeopularPeopleRouter.getPopularPeople(page: 1)
        service.getResponse(request:request).subscribe(onNext: { (response: BaseResponse<Person>) in
            self.shouldLoadMore = false
            self.people = response.results
            if let totalPges = response.total_pages {
                self.totalPages = totalPges
            }
            self.people.forEach {
                let element = PersonCellViewModel(name: $0.name, imageProfile: $0.profilePath, rate: round(($0.popularity ?? 0.0) * 100) / 100, department: $0.department)
                self.peopleCellViewModel.add(element:element)
            }
        }, onError: {error in
            // Will handle all types of errors
        }).disposed(by: disposeBag)
    }
}
