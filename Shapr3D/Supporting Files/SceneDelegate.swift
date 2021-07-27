//
//  SceneDelegate.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 25/07/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let winScene = (scene as? UIWindowScene) else { return  }
        let win = UIWindow(windowScene: winScene)
        if UIApplication.isFirstLaunch(){
            let storyBoard = UIStoryboard(name: "Walkthrough", bundle: nil)
            let startWalkthroughVC = storyBoard.instantiateViewController(withIdentifier: "WalkthroughVC")
            let nc = UINavigationController(rootViewController: startWalkthroughVC)
            win.rootViewController = nc
            win.makeKeyAndVisible()
            
        }
        else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let startMainVC = storyBoard.instantiateViewController(withIdentifier: "tabbar")
            //let nc = UINavigationController(rootViewController: startMainVC)
            win.rootViewController = startMainVC
            win.makeKeyAndVisible()
        }
        window = win
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {
       
    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
   
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

