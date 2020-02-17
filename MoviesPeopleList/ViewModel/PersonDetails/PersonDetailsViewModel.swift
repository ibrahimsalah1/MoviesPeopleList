//
//  PersonDetailsViewModel.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/17/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PersonDetailsViewModel {
    private let service:Service
    private let disposeBag = DisposeBag()
    var personImages = BehaviorRelay<[Image]>(value: [])
    
    init(service:Service = Service()) {
        self.service = service
    }
    
    func getImages(for personId:Int) {
        let personImagesRequest = PeopleRouter.getPersonImages(id: personId)
        service.getResponse(request:personImagesRequest).subscribe(onNext: { (response: PersonImages) in
            self.personImages.accept(response.profiles)
        }, onError: { error in
            // Handling errors
        }).disposed(by: disposeBag)
    }
}
