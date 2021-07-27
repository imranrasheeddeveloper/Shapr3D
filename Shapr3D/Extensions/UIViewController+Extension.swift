//
//  UIViewController+Extension.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 25/07/2021.
//

import Foundation
import UIKit

extension UIViewController{
    func setStatusBar() {
      let tag = 12321
      if let taggedView = self.view.viewWithTag(tag){
        taggedView.removeFromSuperview()
      }
      let overView = UIView()
      
      let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
      overView.frame = (window?.windowScene?.statusBarManager!.statusBarFrame)!
      overView.backgroundColor = UIColor(named: "primaryColor")
      overView.tag = tag
      self.view.addSubview(overView)
    
        
    }
    func hideKeyboard() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
      view.endEditing(true)
    }
}
