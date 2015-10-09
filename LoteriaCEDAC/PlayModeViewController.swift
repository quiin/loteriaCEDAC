//
//  PlayModeViewController.swift
//  LoteriaCEDAC
//
//  Created by Carlos Alejandro Reyna González on 09/10/15.
//  Copyright (c) 2015 CEDAC. All rights reserved.
//

import UIKit

class PlayModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Modo de juego"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier!{
        case "segueSinglePlayer":
            let destination = segue.destinationViewController as! SelectLevelViewController
            destination.gameMode = 0
            println("singleplayer")
        case "segueMultiPlayer":            
            println("Multiplayer")
        default:
            println("wutMode")
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
