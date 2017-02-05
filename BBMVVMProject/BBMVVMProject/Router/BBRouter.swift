//
//  BBRouter.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 23/01/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit

class BBRouter {
    
    static let sharedRouter: BBRouter = BBRouter()
    private let viewModelMappingDict: [String: AnyClass] =
        ["BBViewModel" : BBBaseViewController.classForCoder(),
         "BBTabBarViewModel" : BBTabBarViewController.classForCoder(),
         "BBDemoViewModel" : BBDemoViewController.classForCoder()]
    
    private init(){}
    
    func viewControllerFor(viewModel: BBViewModel) -> BBBaseViewController {
        guard let viewControllerClass = viewModelMappingDict[NSStringFromClass(viewModel.classForCoder).components(separatedBy: ".").last!]
            else {
                fatalError("equivalent viewController for \([NSStringFromClass(viewModel.classForCoder).components(separatedBy: ".").last!]) does not exsit.")
        }
        
        return (viewControllerClass as! BBBaseViewController.Type).init(viewModel: viewModel)
    }
    

}
