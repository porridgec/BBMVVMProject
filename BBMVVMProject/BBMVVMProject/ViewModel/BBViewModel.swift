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

class BBViewModel: NSObject {
    
    let navigationBus: BBNavigationEventBus = BBNavigationEventBus.sharedEventBus
    let params: [String: AnyObject]
    var navigationTitle: String
    var shouldHideNavigationBar: Bool
    var shouldHideStatusBar: Bool
    
    //sample signals
    var coldSignal: SignalProducer<Int, NoError>!
    var (hotSignal, hotSignalObserver) = Signal<Int, NoError>.pipe()
    
    init(withParams: [String: AnyObject]) {
        params = withParams
        navigationTitle = (params["navigationTitle"] as? String) ?? ""
        shouldHideNavigationBar = (params["shouldHideNavigationBar"] as? Bool) ?? false
        shouldHideStatusBar = (params["shouldHideNavigationBar"] as? Bool) ?? false
        
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
    
    func search() -> SignalProducer<String, NoError> {
        return BBNetworkManager.searchMusic(keyword: "numb")
    }
    

}
