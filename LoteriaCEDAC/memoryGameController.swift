//
//  MemoryGameController.swift
//  LoteriaCEDAC
//
//  Created by Carlos Alejandro Reyna González on 07/09/15.
//  Copyright (c) 2015 CEDAC. All rights reserved.
//

import UIKit

class MemoryGameController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    
    //vars
    var flipped = [Bool] (count: 18, repeatedValue: false)
    var cards = ["🐂", "🐎","🐯","🐤","👉","👌","🎁","🎂", "🎃", "🍆","🍕","🍻","🍳","🐸","🐬","🐠","🐝","💦",
                 "🐂", "🐎","🐯","🐤","👉","👌","🎁","🎂", "🎃", "🍆","🍕","🍻","🍳","🐸","🐬","🐠","🐝","💦"]
    
    var isFirstPairOpen = false
    var firstPairIndex = 0
    var firstPair = ""
    var secondPair = ""
    
    //constants
    let backCard = "❓"
    
    
    
    
    
    
    
    //Collection methods
    //items in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    //number of sections
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //handle item select
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
       return cell!
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

