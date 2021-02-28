//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by chihyin wang on 2020/7/2.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit
import QuizEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var quiz: Quiz?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let question1 = Question.singleAnswer("What's Bill's favorite color?")
        let question2 = Question.multipleAnswer("What's Bill's favorite brand?")
        let questions = [question1, question2]
        
        let option101 = "Maroon"
        let option102 = "Navy"
        let option103 = "Black"
        let options1 = [option101, option102, option103]
        
        let option201 = "Maison Martin Margiela"
        let option202 = "Christian Dior"
        let option203 = "Raf Simons"
        let option204 = "Haider Ackermann"
        let options2 = [option201, option202, option203, option204]
        
        let options = [question1: options1, question2: options2]
        let correctAnswers = [(question1, [option103]), (question2, [option201, option202, option204])]
        
        let navigationController = UINavigationController()
        let factory = iOSUIKitViewControllerFactory(options: options, correctAnswers: correctAnswers)
        let router = NavigationControllerRouter(navigationController, factory: factory)
        
        quiz = Quiz.start(questions: questions, delegate: router)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }


}

