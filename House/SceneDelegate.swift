//
//  SceneDelegate.swift
//  House
//
//  Created by Sundara Sastha on 23/12/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var storyboard = UIStoryboard()
    private var initialViewController = UIViewController()
    let UserAPI = "UserAPI.php"
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let winscene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: winscene)
        if((UserDefaults.standard.string(forKey: "UserID")) != nil) {
            let jsonParam: [String: Any] = ["ProcessName": "checkUserId","userId": UserDefaults.standard.string(forKey: "UserID")!]
            Common.sharedInstance.RequestFromApi(api: self.UserAPI, jsonParams: jsonParam, completionHandler: {(result) -> Void in
                let msg = result["message"] as? Int
                DispatchQueue.main.async {
                    if(msg == 0 && UserDefaults.standard.string(forKey: "lastName") != nil) {
                            var locale: String
                            if((UserDefaults.standard.integer(forKey: "langFlg")) == 1){
                                locale = "ja";
                            } else {
                                locale = "en";
                            }
                            Common.sharedInstance.languageChangeAction(locale: locale)
                    } else {
                            self.storyboard = UIStoryboard(name: "Login", bundle: nil)
                            self.initialViewController = self.storyboard.instantiateViewController(identifier: "LoginVC")
                            self.window?.rootViewController = self.initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                }
            })
            
        }
        else {
            self.storyboard = UIStoryboard(name: "Login", bundle: nil)
            self.initialViewController = self.storyboard.instantiateViewController(identifier: "LoginVC")
            window?.rootViewController = self.initialViewController
            window?.makeKeyAndVisible()
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url{
            let urlString = url.absoluteString
            let component = urlString.components(separatedBy: "=")
            let id = component.last
            let jsonParam: [String: Any] = ["ProcessName": "userUpdateVerifyFlg","id": id!]
            Common.sharedInstance.RequestFromApi( api: self.UserAPI, jsonParams: jsonParam, completionHandler: {(result) -> Void in
              
           })
        }
    }
    
    
}

