//
//  MainAPI.swift
//  InloopxApp
//
//  Created by MacBook Pro on 28/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import Moya

enum MainAPI {
    case getPhotos()
    case getAlbums()
    case newPhoto(title: String, albumId: Int)
}

extension MainAPI: TargetType {
    
    var baseURL: URL { return URL(string: "\(NetworkingConstants.baseUrl)")! }
    
    var path: String {
        switch self {
        case .getPhotos, .newPhoto(_, _):
            return "/photos"
        case .getAlbums:
            return "/albums"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPhotos, .getAlbums:
            return .get
        case .newPhoto:
            return .post
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Task {
        switch self {
        case .getPhotos, .getAlbums:
            return .requestPlain
        case .newPhoto(let title, let albumId):
            let params: [String: Any] = [
                "title" : title,
                "albumId" : albumId
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getPhotos:
            return NetworkingUtilities.stubbedResponse("Photo")
        case .getAlbums:
            return NetworkingUtilities.stubbedResponse("Album")
        case .newPhoto:
            return NetworkingUtilities.stubbedResponse("NewPhoto")
        }
    }
    
}
