//
//  SelectLevelViewController.swift
//  LoteriaCEDAC
//
//  Created by Carlos Alejandro Reyna González on 09/10/15.
//  Copyright (c) 2015 CEDAC. All rights reserved.
//

import UIKit

class SelectLevelViewController: UIViewController {

    // gameMode = 0 => single player 
    // gameMode = 1 => multiplayer player as player
    // gameMode = 2 => multiplayer player as dealer
    var gameMode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Selecciona Niveles"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier!{
        case "segueLevel1":
            let destination = segue.destinationViewController as! loteria
            destination.selectedLevel = 1
            println("level 1")
        case "segueLevel2":
            let destination = segue.destinationViewController as! loteria
            destination.selectedLevel = 2
            println("level 2")
        case "segueLevel3":
            let destination = segue.destinationViewController as! loteria
            destination.selectedLevel = 3
            destination.hideCurrentCard = true
            println("level 3")
        case "segueInstructions":
            let destination = segue.destinationViewController as! UIViewController
            destination.title = "Instrucciones"
        default:
            println("wut")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
