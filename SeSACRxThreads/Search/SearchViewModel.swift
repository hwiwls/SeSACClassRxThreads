//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by hwijinjeong on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    let inputQuery = PublishSubject<String>()
    
    let inputSearchButtonTap = PublishSubject<Void>()
    
    lazy var items = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    init() {
        inputQuery
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                print("search: \(value)")
                
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        
        inputSearchButtonTap
            .withLatestFrom(inputQuery)
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, value in
                print("search btn clicked: \(value)")
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            })
            .disposed(by: disposeBag)
    }
    
}
