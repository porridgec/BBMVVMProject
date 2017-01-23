//
//  BBNavigationEventBus.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 23/01/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class BBNavigationEventBus: NSObject {
    
    static let sharedEventBus: BBNavigationEventBus = BBNavigationEventBus()
    
    private override init() {
        super.init()
    }
    
    dynamic func push(viewModel: BBViewModel, animated: Bool) {}
    
    dynamic func popViewModel(animated: Bool) {}
    
    dynamic func popToRootViewModel(animated: Bool) {}
    
    dynamic func present(viewModel: BBViewModel, animated: Bool, completion: (() -> Void)?) {}
    
    dynamic func dismissViewModel(aniamted: Bool, completion: (() -> Void)?) {}
    
    dynamic func reset(rootViewModel: BBViewModel) {}

}
