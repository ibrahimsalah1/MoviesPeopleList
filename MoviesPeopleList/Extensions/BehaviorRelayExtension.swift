//
//  BehaviorRelayExtension.swift
//  MoviesPeopleList
//
//  Created by Ibrahim Salah on 2/15/20.
//  Copyright © 2020 Ibrahim Salah. All rights reserved.
//

import RxCocoa
extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
    
    func removeAll() {
        var array = self.value
        array.removeAll()
        self.accept(array)
    }
}
