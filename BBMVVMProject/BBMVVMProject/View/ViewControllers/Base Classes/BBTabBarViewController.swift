//
//  BBTabBarViewController.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 05/02/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit
import CYLTabBarController

class BBTabBarViewController: BBBaseViewController {
    
    var tabbarController: CYLTabBarController!
    let titles: [String] = ["A","B","C","D"]
    let normalImages: [String] = ["tab_home_normal",
                                  "tab_explore_normal",
                                  "tab_message_normal",
                                  "tab_profile_normal"]
    let selectedImages: [String] = ["tab_home_selected",
                                    "tab_explore_selected",
                                    "tab_message_selected",
                                    "tab_profile_selected"]
    var tabBarViewModel: BBTabBarViewModel {
        get {
            return viewModel as! BBTabBarViewModel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabbarController = CYLTabBarController()
        tabbarController.view.frame = view.bounds
        
        addChildViewController(tabbarController)
        view.addSubview(tabbarController.view)
        tabbarController.didMove(toParentViewController: self)
        
        setupTabBarAttributes()
        setupViewControllers()
        setupTabBarHook()
    }
    
    private func setupTabBarAttributes() {
        var attributes: [[String : String]] = [[String : String]]()
        for index in 0...3 {
            let dict: [String : String] = [CYLTabBarItemTitle : titles[index],
                                           CYLTabBarItemImage : normalImages[index],
                                           CYLTabBarItemSelectedImage: selectedImages[index]]
            attributes.append(dict)
        }
        tabbarController.tabBarItemsAttributes = attributes
        tabbarController.delegate = self
    }
    
    private func setupViewControllers() {
        let navigationControllers: [UINavigationController] = [UINavigationController.init(rootViewController: BBRouter.sharedRouter.viewControllerFor(viewModel: tabBarViewModel.aViewModel)),
                                            UINavigationController.init(rootViewController: BBRouter.sharedRouter.viewControllerFor(viewModel: tabBarViewModel.bViewModel)),
                                            UINavigationController.init(rootViewController: BBRouter.sharedRouter.viewControllerFor(viewModel: tabBarViewModel.cViewModel)),
                                            UINavigationController.init(rootViewController: BBRouter.sharedRouter.viewControllerFor(viewModel: tabBarViewModel.dViewModel))]
        tabbarController.viewControllers = navigationControllers
        BBNavigationControllerStack.sharedNavigationControllerStack.push(navigationController: navigationControllers[0])
    }
    
    private func setupTabBarHook() {
        reactive.signal(for: #selector(self.tabBarController(_:didSelect:))).observeValues { (params) in
            _ = BBNavigationControllerStack.sharedNavigationControllerStack.popNavigationController()
            BBNavigationControllerStack.sharedNavigationControllerStack.push(navigationController: params[1] as! UINavigationController)
        }
    }

}

extension BBTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //
    }
}
