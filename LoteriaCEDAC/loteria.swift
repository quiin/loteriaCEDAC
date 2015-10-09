//
//  MemoryGameController.swift
//  LoteriaCEDAC
//
//  Created by Carlos Alejandro Reyna González on 07/09/15.
//  Copyright (c) 2015 CEDAC. All rights reserved.
//

import UIKit

class loteria: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    
    //vars
    var flipped = [Bool] (count: 9, repeatedValue: false)
    var cards = ["🐂", "🐎","🐯","🐤","👉","👌","🎁","🎂", "🎃"]
    
    var isFirstPairOpen = false
    var firstPairIndex = 0
    var firstPair = ""
    var secondPair = ""
    
    //constants
    let backCard = "❓"
    let cellId = "cardCell"
    
    //Outlets
    @IBOutlet weak var currentCard: UILabel!

    
    
    
    
    //Collection methods
    //items in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    //number of sections
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //handle item select
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as!UICollectionViewCell
        let lblCard:UILabel = cell.viewWithTag(100) as! UILabel
        if flipped[indexPath.row] == true {
                lblCard.text = cards[indexPath.row]
        }else{
            lblCard.text = backCard
        }
        backCard
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return cell
    }

    //shuffleFlags
    func shuffleFlags(){
        for i in 0..<flipped.count{
            var j = Int(arc4random())%flipped.count
            let temp = flipped[i]
            flipped[i] = flipped[j]
            flipped[j] = temp
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shuffleFlags()
        println("added")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

