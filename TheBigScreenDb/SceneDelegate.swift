//
//  SceneDelegate.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 27/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
               
        simulateAnIOCContainer()        
    }
    
    
    //Due to issues using SwinInject and tabbarcontroller for dependency injection IOC registration.
    //I've created this function that is essentially a makeshift way of resolving dependencies via initializer injection, and this indrectly shows the object graph had this been an actual IOC container
    func simulateAnIOCContainer () {
        
        //Featured Tab Section Dependencies Resolved
        if let viewController = self.window?.rootViewController {
                
             let webClient: WebClientProtocol = WebClient()
             let movieDatabaseService: TheMovieDatabaseServiceProtocol = TheMovieDatabaseService(webClient: webClient)
             let mediaListViewModel = MediaViewModel(movieDatabaseService: movieDatabaseService)
            
            if let featuredNavigationController = viewController.children[0] as? UINavigationController {
                
                if let featuredViewController = featuredNavigationController.children[0] as? FeaturedViewController {                
                    featuredViewController.mediaListViewModel = mediaListViewModel
                }
            }
            
            if let searchNavigationController = viewController.children[1] as? UINavigationController {
                
                if let searchViewController = searchNavigationController.children[0] as? SearchViewController {
                    searchViewController.mediaViewModel = mediaListViewModel
                }
            }
            
            
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

