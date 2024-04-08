//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by hwijinjeong on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    struct Input {
        let birthDay: ControlProperty<Date>
    }
    
    let disposeBag = DisposeBag()
    
    struct Output {
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let year = PublishRelay<Int>()
        let month = PublishRelay<Int>()
        let day = PublishRelay<Int>()
        
        input.birthDay
            // map으로 지지고 볶고 해서 가능
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)

                // observable
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        
        let driverYear = year
            .map { "\($0)년" }
            .asDriver(onErrorJustReturn: "")
        
        let driverMonth = month 
            .map { "\($0)월" }
            .asDriver(onErrorJustReturn: "")
        
        let driverDay = day 
            .map { "\($0)일" }
            .asDriver(onErrorJustReturn: "")
        
        return Output(year: driverYear, month: driverMonth, day: driverDay)
    }
}


//class BirthdayViewModel {
//    // input -> datePicker에서 선택한 날짜(date)
//    let birthDay: BehaviorSubject<Date> = BehaviorSubject(value: .now)
//    
//    // output -> year, month, day
//    let year = PublishRelay<Int>()
//    let month = BehaviorRelay(value: 4)
//    let day = PublishRelay<Int>()
//    
//    let disposeBag = DisposeBag()
//    
//    init() {
//        birthDay
//            .subscribe(with: self) { owner, date in
//                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
//                
//                print(component.day, component.month, component.year)
//                
//                // observable
//                owner.year.accept(component.year!)
//                owner.month.accept(component.year!)
//                owner.day.accept(component.day!)
//            }
//            .disposed(by: disposeBag)
//    }
//}

