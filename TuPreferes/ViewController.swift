//
//  ViewController.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, QuestionReaderDelegate {
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var firstChoice: UIButton!
    @IBOutlet weak var secondChoice: UIButton!
    
    override func viewDidLoad() {
        let realm = try! Realm()
        let realmCache = RealmCache(realm: realm)
        let questionCache = QuestionCache(persisterFinder: realmCache)
        let qm = QuestionManager(client: DefaultHTTPClient(), questionGetter: questionCache)
        
        qm.readRemoteQuestions(questionCache)
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        qm.readNextQuestion(self)
        applyStyle()
    }
    
    fileprivate func applyStyle() {
        firstChoice.layer.cornerRadius = 5
        secondChoice.layer.cornerRadius = 5
        firstChoice.titleLabel?.adjustsFontSizeToFitWidth = true
        secondChoice.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func questionIsAvailable(_ question: Question?){
        if let q = question {
            DispatchQueue.main.async{
                self.content.text = q.content
                self.firstChoice.setTitle(q.firstChoice!.content, for: UIControlState())
                self.secondChoice.setTitle(q.lastChoice!.content, for: UIControlState())
            }
        } else {
            let myAlert = UIAlertController(title: "Erreur", message: "Vérifier votre connexion et réessayez.", preferredStyle: UIAlertControllerStyle.alert)
            // add "OK" button
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(myAlert, animated: true, completion: nil)
        }
    }
    
    
    
}

