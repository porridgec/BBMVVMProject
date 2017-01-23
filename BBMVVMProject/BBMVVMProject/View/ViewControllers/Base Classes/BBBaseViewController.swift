//
//  BBBaseViewController.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 23/01/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit

class BBBaseViewController: UIViewController {
    
    let viewModel: BBViewModel
    
    required init(viewModel: BBViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.red
        
        bindViewModel()
    }
    
    func bindViewModel() {
        //binding
    }

}
