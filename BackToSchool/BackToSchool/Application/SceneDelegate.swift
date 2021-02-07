//
//  SceneDelegate.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//


import UIKit
import FBSDKLoginKit
import SlideMenuControllerSwift

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options
                connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window?.overrideUserInterfaceStyle = .light
        
        if UserDefaults.standard.value(forKey: UD_isTutorial) == nil || UserDefaults.standard.value(forKey: UD_isTutorial) as! String == "" || UserDefaults.standard.value(forKey: UD_isTutorial) as! String == "N/A" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let objVC = storyBoard.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            self.window?.rootViewController = nav
        }
        else {
            if
                UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" {
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let objVC = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
//                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
//                nav.navigationBar.isHidden = true
//                self.window?.rootViewController = nav
                
                let window = UIWindow(windowScene: windowScene)
                self.window = window
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let newViewcontroller:UIViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = UINavigationController(rootViewController: newViewcontroller)
                navigationController.navigationBar.isHidden = true
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
            else {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let objVC = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let sideMenuViewController = storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
                appNavigation.setNavigationBarHidden(true, animated: true)
                let slideMenuController = SlideMenuController(mainViewController: appNavigation, leftMenuViewController: sideMenuViewController)
                slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width * 0.8)
                slideMenuController.removeLeftGestures()
                self.window?.rootViewController = slideMenuController
                
//                let window = UIWindow(windowScene: windowScene)
//                self.window = window
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let newViewcontroller:UIViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                let navigationController = UINavigationController(rootViewController: newViewcontroller)
//                navigationController.navigationBar.isHidden = true
//                window.rootViewController = navigationController
//                window.makeKeyAndVisible()
            }
        }
        
//        let window = UIWindow(windowScene: windowScene)
//        self.window = window
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let newViewcontroller:UIViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//        let navigationController = UINavigationController(rootViewController: newViewcontroller)
//        navigationController.navigationBar.isHidden = true
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Not called under iOS 12 - See AppDelegate applicationDidBecomeActive
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Not called under iOS 12 - See AppDelegate applicationWillResignActive
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Not called under iOS 12 - See AppDelegate applicationWillEnterForeground
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Not called under iOS 12 - See AppDelegate applicationDidEnterBackground
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // For facebook login
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let _ = ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation])
    }



}
