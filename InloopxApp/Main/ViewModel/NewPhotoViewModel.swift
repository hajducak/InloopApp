//
//  NewPhotoViewModel.swift
//  InloopxApp
//
//  Created by MacBook Pro on 28/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NewPhotoViewModel: ViewModelType {
    
    typealias Dependencies = HasMainService
    
    fileprivate let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let newPhotoResponse = input.nePhotoRequest.flatMap { (input) -> Observable<Lce<Void>> in
            return self.dependencies.mainService.newPhoto(title: input.title, albumId: input.albumId)
        }
      
        return Output(newPhotoResponse: newPhotoResponse)
    }
}

extension NewPhotoViewModel {
    struct Input {
        let nePhotoRequest: PublishSubject<(title: String, albumId: Int)>
    }
    
    struct Output {
        let newPhotoResponse: Observable<Lce<Void>>
    }
}
