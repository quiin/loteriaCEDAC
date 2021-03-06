//
//  MultiplayerRoleViewController.swift
//  LoteriaCEDAC
//
//  Created by Carlos Alejandro Reyna González on 09/10/15.
//  Copyright (c) 2015 CEDAC. All rights reserved.
//

import UIKit

class MultiplayerRoleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "¿Qué quieres hacer?"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier!{
        case "segueAsPlayer":
            let destination = segue.destinationViewController as! SelectLevelViewController
            destination.gameMode = 1
            print("Player")
        case "segueAsDealer":
            let destination = segue.destinationViewController as! SelectLevelViewController
            destination.gameMode = 2
            print("Dealer")
        case "returnPlayMode":
            let destination = segue.destinationViewController as! PlayModeViewController
            print("Dealer")
        default:
            print("wutAs")
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
