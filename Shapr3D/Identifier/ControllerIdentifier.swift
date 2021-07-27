//
//  ControllerIdentifier.swift
//  LifeArt
//
//  Created by Muhammad Imran on 06/04/2021.
//  Copyright © 2021 ITRID TECHNOLOGIES LTD. All rights reserved.
//

import Foundation
import UIKit

enum ControllerIdentifier: String {
    case WalkthroughVC
    //case HomeViewVC
    case tabbar
}

extension UIViewController{
    func pushToController(from name : Storyboard, identifier: ControllerIdentifier) {
        DispatchQueue.main.async { [self] in
            let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
            navigationController?.pushViewController(vc,animated: true)
        }
    
    }
    func pushToRoot(from name : Storyboard, identifier: ControllerIdentifier) {
        DispatchQueue.main.async { [self] in
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        }
        
    }

}
