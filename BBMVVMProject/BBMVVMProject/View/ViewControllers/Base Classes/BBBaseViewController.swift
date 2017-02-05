//
//  BBBaseViewController.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 23/01/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit
import Moya
import ReactiveCocoa
import ReactiveSwift
import Result

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
                    strongSelf.viewModel.coldSignal.start({ (event) in
                        switch event {
                        case let .value(value):
                            print("cold signal \(value) observed")
                        case let .failed(error):
                            print("Failed: \(error)")
                        case .completed:
                            print("Completed")
                        case .interrupted:
                            print("Interrupted")
                        }
                    })
            }
        }
        
        let bbutton: UIButton = UIButton(type: .system)
        bbutton.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        bbutton.backgroundColor = UIColor.purple
        bbutton.setTitle("bbbbb", for: .normal)
        view.addSubview(bbutton)
        bbutton.reactive.controlEvents(.touchUpInside).observeValues { [weak self](button) in
            if let strongSelf = self {
                strongSelf.viewModel.sendHotSignal()
            }
        }
        viewModel.hotSignal.observeValues({ (value) in
            print("hot signal \(value) observed")
        })
        
        let sbutton: UIButton = UIButton(type: .system)
        sbutton.frame = CGRect(x: 100, y: 500, width: 200, height: 50)
        sbutton.backgroundColor = UIColor.yellow
        sbutton.setTitle("bbbbb", for: .normal)
        view.addSubview(sbutton)
        sbutton.reactive.controlEvents(.touchUpInside).observeValues { [weak self](button) in
            if let strongSelf = self {
                strongSelf.viewModel.search().start(Observer<String, MoyaError>.init(value: { (value) in
                    print(value)
                }, failed: { error in
                    print("error occured \(error)")
                }, completed: nil, interrupted: nil))
            }
        }
    }
    
    func bindViewModel() {
        //binding
        navigationItem.title = viewModel.navigationTitle
    }

}
