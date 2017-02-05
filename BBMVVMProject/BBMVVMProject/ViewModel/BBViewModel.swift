//
//  BBViewModel.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 23/01/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import Moya

enum BBViewModelParam: String {
    case navigationTitle
    case shouldHideNavigationBar
    case shouldHideStatusBar
}

class BBViewModel: NSObject {
    
    let navigationBus: BBNavigationEventBus = BBNavigationEventBus.sharedEventBus
    let params: [String: Any]
    var navigationTitle: String
    var shouldHideNavigationBar: Bool
    var shouldHideStatusBar: Bool
    
    //sample signals
    var coldSignal: SignalProducer<Int, NoError>!
    var (hotSignal, hotSignalObserver) = Signal<Int, NoError>.pipe()
    
    override init() {
        params = [:]
        navigationTitle = ""
        shouldHideNavigationBar = false
        shouldHideStatusBar = false
        
        super.init()
        initialize()
    }
    
    init(_ withParams: [String: Any]) {
        params = withParams
        navigationTitle = (params[BBViewModelParam.navigationTitle.rawValue] as? String) ?? ""
        shouldHideNavigationBar = (params[BBViewModelParam.shouldHideNavigationBar.rawValue] as? Bool) ?? false
        shouldHideStatusBar = (params[BBViewModelParam.shouldHideStatusBar.rawValue] as? Bool) ?? false
        
        super.init()
        initialize()
    }
    
    func initialize() { //override this function in subclasses
        coldSignal = SignalProducer<Int, NoError>.init({ (observer, disposable) in
            observer.send(value: 13)
            observer.sendCompleted()
        })
    }
    
    func sendHotSignal() {
        hotSignalObserver.send(value: 1313)
    }
    
    func search() -> SignalProducer<String, MoyaError> {
        return BBNetworkManager.searchMusic(keyword: "numb")
    }
    
    func go() {
        navigationBus.push(viewModel: BBViewModel([BBViewModelParam.navigationTitle.rawValue : "aa"]), animated: true)
    }
    

}
