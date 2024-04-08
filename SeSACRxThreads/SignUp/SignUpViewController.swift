//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    var emailAddr = BehaviorSubject(value: "a@a.com")   /*Observable.just("hwiollf@google.com")*/
    let sampleBackgroundColor = Observable.just(UIColor.blue)
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
//        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
//        emailAddr
//            .subscribe(with: self) { owner, value in
//                owner.emailTextField.text = value
//            }
//            .disposed(by: disposeBag)
        
        // emailAddr
        //            .bind(with: self) { owner, value in
        //                owner.emailTextField.text = value
        //            }
        //            .disposed(by: disposeBag)
        
        emailAddr
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        sampleBackgroundColor
            .bind(to: nextButton.rx.backgroundColor,
                  emailTextField.rx.tintColor,
                  emailTextField.rx.textColor)
            .disposed(by: disposeBag)
        
        sampleBackgroundColor
            .map { $0.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                // 등위연산자(=)로 값을 바꾸지 않는다
                owner.emailAddr.onNext("b@b.com")
            }
            .disposed(by: disposeBag)
        
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
//        
//        validationButton.rx.tap
//            .bind(with: self) { owner, _ in
//                owner.emailAddr
//                    .subscribe(with: self) { owner, value in
//                        owner.emailTextField.text = "random@random.com"
//                    }
//                    .dispose()
//            }
//            .disposed(by: disposeBag)

    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
