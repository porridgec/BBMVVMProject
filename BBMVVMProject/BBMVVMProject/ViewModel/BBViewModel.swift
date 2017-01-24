//
//  BBViewModel.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 23/01/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit

class BBViewModel: NSObject {
    
    let navigationBus: BBNavigationEventBus = BBNavigationEventBus.sharedEventBus
    let params: [String: AnyObject]!
    let navigationTitle: String!
    
    init(withParams: [String: AnyObject]) {
        params = withParams
        navigationTitle = (params["navigationTitle"] as? String) ?? ""
        super.init()
        initialize()
    }
    
    func initialize() {} //override this function in subclasses

}
