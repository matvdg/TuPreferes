//
//  ViewController.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuestionReaderDelegate {
    
    var currentQuestion: Question?
    var qc: QuestionCache?
    var qm: QuestionManager?
    
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var firstChoice: UIButton!
    @IBOutlet weak var secondChoice: UIButton!
    
    override func viewDidLoad() {
        self.qc = Provider.getQuestionCache()
        self.qm = Provider.getQuestionManager()
        
        self.qm?.readRemoteQuestions(self.qc!)
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        self.qm?.readNextQuestion(self)
        applyStyle()
    }
    
    fileprivate func applyStyle() {
        firstChoice.layer.cornerRadius = 5
        secondChoice.layer.cornerRadius = 5
        firstChoice.titleLabel?.adjustsFontSizeToFitWidth = true
        secondChoice.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func questionIsAvailable(_ question: Question?){
        self.currentQuestion = question
        
        if let q = self.currentQuestion {
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
    
    @IBAction func didChoose(_ sender: UIButton) {
        let vote = self.qm!.createNewVote(q: self.currentQuestion!, chosenTitle: sender.titleLabel!.text!)
        self.qm?.submitVoteForQuestion(q: self.currentQuestion!, v: vote)
    }
    
    
}

