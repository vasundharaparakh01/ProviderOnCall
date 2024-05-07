//
//  DashboardViewController.swift
//  AccessEMR
//
//  Created by Vasundhara Parakh on 2/25/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit

class DashboardViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
        self.tabBar.items![2].title = "\(UserDefaults.getOrganisationTypeName().uppercased())"
    }
    
    

}

extension DashboardViewController:UITabBarControllerDelegate {
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
//    func tabBarController( _ tabBarController: UITabBarController,
//            animationControllerForTransitionFrom fromVC: UIViewController,
//            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return CustomTabBarTransition(viewControllers: tabBarController.viewControllers)
//    }
    
    // MARK: switch tab with animation
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view,
            let toView = viewController.view else {
          return false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}


