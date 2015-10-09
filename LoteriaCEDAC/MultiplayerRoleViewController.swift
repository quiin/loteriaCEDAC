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
        let destination = segue.destinationViewController as! SelectLevelViewController
        switch segue.identifier!{
        case "segueAsPlayer":
            destination.gameMode = 1
            println("Player")
        case "segueAsDealer":
            destination.gameMode = 2
            println("Dealer")
        default:
            println("wutAs")
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
