//
//  Storyboard.swift
//  LifeArt
//
//  Created by Muhammad Imran on 06/04/2021.
//  Copyright © 2021 ITRID TECHNOLOGIES LTD. All rights reserved.
//

import Foundation
import UIKit

let mainBundle = Bundle.main
enum Storyboard: String {
    case main = "Main"
    case Walkthrough = "Walkthrough"
}

extension Storyboard {
    var instance: UIViewController {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: mainBundle).instantiateViewController(withIdentifier: self.rawValue)
    }
}
