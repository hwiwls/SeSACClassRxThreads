//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/01.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
   
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    
    let searchBar = UISearchBar()
     
    let disposeBag = DisposeBag()
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
    
    func bind() {
        viewModel.items   // subscribe도 상괸 없음
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                
                cell.appNameLabel.text = "test \(element)"
                cell.appIconImageView.backgroundColor = .systemBlue
                
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
//        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
//            .bind(with: self) { owner, value in
//                print(value.0, value.1)
//                
//                owner.data.remove(at: value.0.row)
//                owner.items.onNext(owner.data)
//            }
//            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.inputQuery)
            .disposed(by: disposeBag)
        
        
        searchBar.rx.searchButtonClicked
            .bind(to: viewModel.inputSearchButtonTap)
            .disposed(by: disposeBag)
        
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
//    @objc func plusButtonClicked() {
//        let sample = ["A", "B", "C", "D", "E"]
//        
//        data.append(sample.randomElement()!)
//        
//        items.onNext(data)
//
//    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
