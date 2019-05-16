//
//  ViewModel.swift
//  UserRepositorySearch
//
//  Created by Mustafa Ozhan on 15/05/2019.
//  Copyright © 2019 Mustafa Ozhan. All rights reserved.
//

import RxSwift
import RxCocoa

class ViewModel {
    
    let searchText = Variable("")
    
    lazy var data: Driver<[Repository]> = {
        
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(ViewModel.repositoriesBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func repositoriesBy(_ githubID: String) -> Observable <[Repository]> {
        guard !githubID.isEmpty ,
            let url = URL(string: "https://api.github.com/users/\(githubID)/repos")
            
            else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .map(parse)
    }
    
    static func parse(json: Any) -> [Repository] {
        guard let items = json as? [[String: Any]] else {
            return []
        }
        
        var repositories = [Repository]()
        
        items.forEach{
            guard let repoName = $0["name"] as? String,
                let repoUrl = $0["html_url"] as? String else {
                    return
            }
            
            repositories.append(Repository(repoName: repoName, repoUrl: repoUrl))
        }
        
        return repositories
    }
}
