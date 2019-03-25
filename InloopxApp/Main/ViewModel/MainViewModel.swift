//
//  MainViewModel.swift
//  InloopxApp
//
//  Created by MacBook Pro on 28/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel: ViewModelType {
    
    typealias Dependencies = HasMainService
    
    fileprivate let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let photoRequest = self.dependencies.mainService.getPhotos().asDriverOnErrorJustComplete()
        
        let albumRequest = self.dependencies.mainService.getAlbums().asDriverOnErrorJustComplete()
        
        return Output(photoRequest: photoRequest, albumRequest: albumRequest)
    }
}

extension MainViewModel {
    struct Input {
        
    }
    
    struct Output {
        let photoRequest: Driver<Lce<[Photo]>>
        let albumRequest: Driver<Lce<[Album]>>
    }
}
