//
//  BBNetworkManager.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 24/01/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit
import Moya
import ReactiveCocoa
import ReactiveSwift
import SwiftyJSON
import Result

enum BBNetworkApiType: TargetType {
    case searchMusic(keyword: String)
    
    var baseURL: URL { return URL(string: "http://pires.cn")! }
    var path: String {
        switch self {
        case .searchMusic(_):
            return "/v1/music/kugou"
        }
    }
    var method: Moya.Method {
        switch self {
        case .searchMusic(_):
            return .get
        }
    }
    var parameters: [String : Any]? {
        switch self {
        case .searchMusic(let keyword):
            return ["keyword" : keyword,
                    "size" : 5,
                    "page" : 1]
        }
    }
    var sampleData: Data {
        switch self {
        case .searchMusic(keyword: _):
            guard let path = Bundle.main.path(forResource: "sampleData", ofType: "json"), let data = Data(base64Encoded: path)
                else {
                    return Data()
            }
            return data
        }
    }
    var task: Task {
        switch self {
        case .searchMusic(_):
            return .request
        }
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}

struct BBNetworkManager {
    static let provider = MoyaProvider<BBNetworkApiType>()
    
    static func searchMusic(keyword: String) -> SignalProducer<String, NoError> {
        return SignalProducer<String, NoError>.init({ (observer, disposable) in
            provider.request(.searchMusic(keyword: keyword), completion: { (result) in
                switch result {
                case .success(let response):
                    observer.send(value: try! response.mapString())
                    break
                case .failure(let _):
                    break
                }
            })
        }).flatMap(.latest, transform: { (value) -> SignalProducer<String, NoError> in
            return SignalProducer<String, NoError>.init({ (observer, disposable) in
                
            })
        })
    }
}

