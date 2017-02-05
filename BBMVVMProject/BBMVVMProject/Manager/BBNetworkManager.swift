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

enum BBNetworkRetCode: Int {
    case error = 0
    case normal = 1
}

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
        switch self {
        case .searchMusic(_):
            return URLEncoding.default
        }
    }
    var needAccessToken: Bool {
        switch self {
        case .searchMusic(_):
            return true
        }
    }
}

struct BBNetworkManager {
    
    static let provider = MoyaProvider<BBNetworkApiType>(endpointClosure: { (target: BBNetworkApiType) -> Endpoint<BBNetworkApiType> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        if target.needAccessToken == true {
            return defaultEndpoint.adding(newHTTPHeaderFields: ["token":"accessToken"])
        } else {
            return defaultEndpoint
        }
    })
    
    static func request(target: BBNetworkApiType) -> SignalProducer<JSON, MoyaError> {
        return SignalProducer<JSON, MoyaError>.init({ (observer, disposable) in
            provider.request(target, completion: { (result) in
                switch result {
                case .success(let value):
                    //more specific operations
                    let json = JSON.init(data: value.data)
                    
                    guard json["ret"].intValue == BBNetworkRetCode.normal.rawValue else {
                        observer.send(error: MoyaError.stringMapping(value))
                        return
                    }
                    
                    observer.send(value: json["data"])
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: error)
                }
            })
        })
    }
    
    static func searchMusic(keyword: String) -> SignalProducer<String, MoyaError> {
        return request(target: .searchMusic(keyword: keyword)).flatMap(.latest, transform: { (data: JSON) -> SignalProducer<String, MoyaError> in
            return SignalProducer<String, MoyaError>.init({ (observer, disposable) in
                observer.send(value: data.rawString()!)
            })
        })
    }
    
    
}

