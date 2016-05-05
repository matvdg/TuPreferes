//
//  ViewController.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuestionManagerDelegate {
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var firstChoice: UIButton!
    @IBOutlet weak var secondChoice: UIButton!
    
    override func viewDidLoad() {
        let qm = QuestionManager(client: DefaultHTTPClient())
        qm.getNextQuestion(self)
        applyStyle()
    }
    
    private func applyStyle() {
        firstChoice.layer.cornerRadius = 5
        secondChoice.layer.cornerRadius = 5
        firstChoice.titleLabel?.adjustsFontSizeToFitWidth = true
        secondChoice.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func questionIsAvailable(question: Question?){
        if let q = question {
            dispatch_async(dispatch_get_main_queue()){
                self.content.text = q.content
                self.firstChoice.setTitle(q.choices.first!.content, forState: .Normal)
                self.secondChoice.setTitle(q.choices.last!.content, forState: .Normal)
            }
        } else {
            let myAlert = UIAlertController(title: "Erreur", message: "Vérifier votre connexion et réessayez.", preferredStyle: UIAlertControllerStyle.Alert)
            // add "OK" button
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            // show the alert
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
    }
    
    
    
}

