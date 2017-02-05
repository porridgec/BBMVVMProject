//
//  BBNavigationControllerStack.swift
//  BBMVVMProject
//
//  Created by Hahn.Chan on 23/01/2017.
//  Copyright © 2017 Hahn Chan. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class BBNavigationControllerStack {
    
    static let sharedNavigationControllerStack: BBNavigationControllerStack = BBNavigationControllerStack()
    private let navigationEventBus: BBNavigationEventBus = BBNavigationEventBus.sharedEventBus
    private let router: BBRouter = BBRouter.sharedRouter
    private var navigationControllers: [UINavigationController] = [UINavigationController]()
    
    private init() {
        registerNavigationHooks()
    }
    
    func push(navigationController: UINavigationController) {
        if !navigationControllers.contains(navigationController) {
            navigationControllers.append(navigationController)
        }
    }
    
    func popNavigationController() -> UINavigationController? {
        return navigationControllers.count > 0 ? navigationControllers.removeLast() : nil
    }
    
    private func topNavigationController() -> UINavigationController {
        return self.navigationControllers.last!
    }
    
    private func registerNavigationHooks() {
        
        navigationEventBus
            .reactive
            .signal(for: #selector(navigationEventBus.push(viewModel:animated:)))
            .observeValues { [weak self](params) in
                if let strongSelf = self, let viewModel = params[0] as? BBViewModel, let animated = params[1] as? Bool {
                    strongSelf.navigationControllers.last?.pushViewController(strongSelf.router.viewControllerFor(viewModel: viewModel),
                                                                               animated: animated)
                }
        }
        
        navigationEventBus
            .reactive
            .signal(for: #selector(navigationEventBus.popViewModel(animated:)))
            .observeValues { [weak self](params) in
                if let strongSelf = self, let animated = params[0] as? Bool {
                    _ = strongSelf.navigationControllers.last?.popViewController(animated: animated)
                }
        }
        
        navigationEventBus
            .reactive
            .signal(for: #selector(navigationEventBus.popToRootViewModel(animated:)))
            .observeValues { [weak self](params) in
                if let strongSelf = self, let animated = params[0] as? Bool {
                    _ = strongSelf.navigationControllers.last?.popToRootViewController(animated: animated)
                }
        }
        
        navigationEventBus
            .reactive
            .signal(for: #selector(navigationEventBus.present(viewModel:animated:completion:)))
            .observeValues { [weak self](params) in
                if let strongSelf = self, let viewModel = params[0] as? BBViewModel, let animated = params[1] as? Bool, let completion = params[2] as? (() -> Void)? {
                    let navigationController = UINavigationController(rootViewController: strongSelf.router.viewControllerFor(viewModel: viewModel))
                    strongSelf.push(navigationController: navigationController)
                    strongSelf.topNavigationController().present(navigationController,
                                                                 animated: animated,
                                                                 completion: completion)
                }
        }
        
        navigationEventBus
            .reactive
            .signal(for: #selector(navigationEventBus.dismissViewModel(aniamted:completion:)))
            .observeValues { [weak self](params) in
                if let strongSelf = self, let animated = params[0] as? Bool, let completion = params[1] as? (() -> Void)? {
                    _ = strongSelf.popNavigationController()
                    strongSelf.topNavigationController().dismiss(animated: animated, completion: completion)
                }
        }
        
        navigationEventBus
            .reactive
            .signal(for: #selector(navigationEventBus.reset(rootViewModel:)))
            .observeValues { [weak self](params) in
                if let strongSelf = self, let rootViewModel = params[0] as? BBViewModel {
                    strongSelf.navigationControllers.removeAll()
                    let viewController = strongSelf.router.viewControllerFor(viewModel: rootViewModel)
                    if !viewController.isKind(of: BBTabBarViewController.classForCoder()) {
                        strongSelf.push(navigationController: UINavigationController(rootViewController: viewController))
                    }
                    
                    UIApplication.shared.delegate?.window??.rootViewController = viewController
                }
        }
        
    }

}
