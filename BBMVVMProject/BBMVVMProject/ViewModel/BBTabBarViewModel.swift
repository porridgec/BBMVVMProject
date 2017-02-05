//
//  BBTabBarViewModel.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 05/02/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit

class BBTabBarViewModel: BBViewModel {
    
    var aViewModel: BBDemoViewModel = BBDemoViewModel([BBViewModelParam.navigationTitle.rawValue : "a"])
    var bViewModel: BBDemoViewModel = BBDemoViewModel([BBViewModelParam.navigationTitle.rawValue : "b"])
    var cViewModel: BBDemoViewModel = BBDemoViewModel([BBViewModelParam.navigationTitle.rawValue : "c"])
    var dViewModel: BBDemoViewModel = BBDemoViewModel([BBViewModelParam.navigationTitle.rawValue : "d"])

}
