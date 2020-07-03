//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by chihyin wang on 2020/7/2.
//  Copyright © 2020 chihyinwang. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        
//        let vc = QuestionViewController(question: "First Question", options: ["A1", "A2"]) {
//            print($0)
//        }
//        vc.tableView.allowsMultipleSelection = false
        
        let vc = ResultsViewController(summary: "You got 1/2 correct", answers: [
            PresentableAnswer(question: "Question1Question1Question1Question1Question1Question1Question1Question1Question1Question1Question1Question1Question1Question1Question1", answer: "goodgoodgoodgoodgoodgoodgoo", wrongAnswer: nil),
            PresentableAnswer(question: "Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2Question2", answer: "good", wrongAnswer: "badbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbadbad")
        ])
        
        window.rootViewController = vc
        self.window = window
        window.makeKeyAndVisible()
    }


}

