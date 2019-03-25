//
//  MainFlowController.swift
//  InloopxApp
//
//  Created by MacBook Pro on 28/02/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class MainFlowController {
    
    fileprivate let navigationController: UINavigationController
    
    fileprivate let dependencies: AppDependency
    
    init(navigationController: UINavigationController, dependencies: AppDependency) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let mainStoryBoard = StoryboardScene.Main.initialScene.instantiate()
        mainStoryBoard.flowDelegate = self
        mainStoryBoard.viewModel = MainViewModel(dependencies: dependencies)
        navigationController.viewControllers = [mainStoryBoard]
        navigationController.navigationBar.isHidden = false
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
    }
    
}

extension MainFlowController: MainViewControllerFlowDelegate {
    
    func createNewPhoto(albums: [Album]) {
        let newPhotoSotryboard = StoryboardScene.NewPhoto.initialScene.instantiate()
        newPhotoSotryboard.flowDelegate = self
        newPhotoSotryboard.albums = albums
        newPhotoSotryboard.viewModel = NewPhotoViewModel(dependencies: dependencies)
        navigationController.show(newPhotoSotryboard, sender: nil)
    }
    
}

extension MainFlowController: NewPhotoFlowDelegate {
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
}

