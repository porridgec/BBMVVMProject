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
        reactive.trigger(for: #selector(viewDidLoad)).observeValues { [weak self] in
            if let strongSelf = self {
                strongSelf.bindViewModel()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.red
        
        let button: UIButton = UIButton(type: .system)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.backgroundColor = UIColor.blue
        button.setTitle("bbbbb", for: .normal)
        view.addSubview(button)
        button.reactive.controlEvents(.touchUpInside).observeValues { [weak self](button) in
            if let strongSelf = self {
                strongSelf.viewModel.navigationBus.push(viewModel: BBViewModel(withParams: [:]), animated: true)
            }
        }
    }
    
    func bindViewModel() {
        //binding
        navigationItem.title = viewModel.navigationTitle
    }

}
