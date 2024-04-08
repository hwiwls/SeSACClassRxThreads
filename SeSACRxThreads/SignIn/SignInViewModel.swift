//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    
    // input: 이메일 입력하는 text, 비밀번호 입력하는 text, signInButton 클릭했을 때, signUpButton 클릭했을 때
    struct Input {
        let email: ControlProperty<String?>
        let password: ControlProperty<String?>
        let signInTap: ControlEvent<Void>
        let signUpTap: ControlEvent<Void>
    }
    
    // output: 이메일 입력하는 text, 비밀번호 입력하는 text, signInButton 클릭 여부, signInButton 클릭했을 때, signUpButton 클릭했을 때
    
    struct Output {
        let email: Driver<String>
        let password: Driver<String>
        let enabled: Driver<Bool>
        let signInTap: ControlEvent<Void>
        let signUpTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let email = input.email
            .orEmpty
            .asDriver()
        
        let password = input.password
            .orEmpty
            .asDriver()
        
        let enabled = input.email
            .orEmpty
            .map { $0.count > 8 && $0.contains("@") }
            .asDriver(onErrorJustReturn: false)
        
//        let signInTap = input.signInTap
//            
//        let signUpTap = input.signUpTap
        
        return Output(email: email, password: password, enabled: enabled, signInTap: input.signInTap, signUpTap: input.signUpTap)
    }
    
}
