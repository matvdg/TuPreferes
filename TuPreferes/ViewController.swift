//
//  ViewController.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QuestionConsumer {
    
    var question: Question?

    @IBOutlet weak var choicesTable: UITableView!
    @IBOutlet weak var content: UILabel!
    
    override func viewDidLoad() {
        let qm = QuestionManager(client: DefaultHTTPClient())
        qm.getNextQuestion(self)
    }
    
    
    //UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let question = self.question {
            return question.choices.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("choice", forIndexPath: indexPath)
        cell.textLabel!.text = self.question!.choices[indexPath.row].content
        return cell
    }
    
    func OnNextQuestion(question: Question?){
        if question != nil {
            dispatch_async(dispatch_get_main_queue()){
                self.question = question
                self.content.text = self.question!.content
                self.choicesTable.reloadData()
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

