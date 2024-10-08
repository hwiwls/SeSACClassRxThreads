//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    
//    let year = PublishSubject<Int>() /*BehaviorSubject(value: 2024)*/ // Observable.just(2024)
//    let month = PublishSubject<Int>() /*BehaviorSubject(value: 3)*/ //Observable.just(3)
//    let day = PublishSubject<Int>() //Observable.just(29)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
//        bind()
        newBind()
        test2()
    }
    
    func newBind() {
        let birthDay = birthDayPicker.rx.date
        
        let input = BirthdayViewModel.Input(birthDay: birthDay)
        
        let output = viewModel.transform(input: input)
        
        output.year
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.month
            .drive(monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.day
            .drive(dayLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func test() {
        let publish = PublishSubject<Int>()
        
        publish.onNext(1)
        publish.onNext(2)
        
        publish.subscribe { value in
            print("publish - \(value)")
        } onError: { error in
            print("onError")
        } onCompleted: {
            print("onCompleted")
        } onDisposed: {
            print("onDisposed")
        }
        .disposed(by: disposeBag)

        publish.onNext(3)
        publish.onNext(4)
        
        publish.onCompleted()
        
        publish.onNext(5)
        publish.onNext(6)
    }
    
    func test2() {
        let publish = BehaviorSubject(value: 23)
        
        publish.onNext(1)
        publish.onNext(2)   // 구독하기 직전 마지막 값을 전달하는 게 BehaviorSubject의 특성
        
        publish.subscribe { value in
            print("publish - \(value)")
        } onError: { error in
            print("onError")
        } onCompleted: {
            print("onCompleted")
        } onDisposed: {
            print("onDisposed")
        }
        .disposed(by: disposeBag)

        publish.onNext(3)
        publish.onNext(4)
        
        publish.onCompleted()
        
        publish.onNext(5)
        publish.onNext(6)
    }
    
//    func bind() {
//        
//        birthDayPicker.rx.date
//            .bind(to: viewModel.birthDay)
//            .disposed(by: disposeBag)
//        
//        viewModel.year
//            .asDriver(onErrorJustReturn: 2024)
//            .map { "\($0)년" }
//            .drive(yearLabel.rx.text)
////            .observe(on: MainScheduler.instance)    // 메인에서 동작할 수 도록
////            .subscribe(with: self) { owner, value in
////                owner.yearLabel.text = "\(value)년"
////            }
//            .disposed(by: disposeBag)
//        
//        viewModel.month
////            .map { "\($0)월" }
////            .observe(on: MainScheduler.instance)    // 메인에서 동작할 수 도록
////            .subscribe(with: self) { owner, value in
////                owner.monthLabel.text = value
////            }
//            .asDriver()
//            .map { "\($0)월" }
//            .drive(monthLabel.rx.text)
//            .disposed(by: disposeBag)
//        
//        viewModel.day
////            .map { "\($0)일" }
////            .bind(to: dayLabel.rx.text)
//            .asDriver(onErrorJustReturn: 3)
//            .drive(with: self, onNext: { owner, value in
//                owner.dayLabel.text = "\(value)일"
//            })
//            .disposed(by: disposeBag)
//    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
