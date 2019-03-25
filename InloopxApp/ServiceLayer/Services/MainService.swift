//
//  MainService.swift
//  InloopxApp
//
//  Created by MacBook Pro on 28/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RealmSwift
import RxRealm

protocol HasMainService {
    var mainService: MainService { get }
}

class MainService: BaseService {
    
    func getPhotos() -> Observable<Lce<[Photo]>> {
        let endpoint = MainAPI.getPhotos()
        
        return self.provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().map([Photo].self).flatMap({ (photos) -> Observable<Lce<[Photo]>> in
            return Observable.just(Lce.init(data: photos))
        }).catchError({
            (error) in error.asServiceError()
        })
    }
    
    func getAlbums() -> Observable<Lce<[Album]>> {
        let endpoint = MainAPI.getAlbums()
        
        return self.provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().map([Album].self).flatMap({ (albums) -> Observable<Lce<[Album]>> in
            return Observable.just(Lce.init(data: albums))
        }).catchError({
            (error) in error.asServiceError()
        })
    }
    
    func newPhoto(title: String, albumId: Int) -> Observable<Lce<Void>> {
        let endpoint = MainAPI.newPhoto(title: title, albumId: albumId)
        return self.provider.request(MultiTarget(endpoint)).asObservable().filterSuccess().mapToLceVoid()
            .catchError({
                (error) in error.asServiceError()
            })
    }
    
}

