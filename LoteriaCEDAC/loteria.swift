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
    var cards = ["🐂", "🐎","🐯","🐤","👉","👌","🎁","🎂", "🎃"]
    var cardsForDealing = ["🐂", "🐎","🐯","🐤","👉","👌","🎁","🎂", "🎃"]
    //var guessedCards: [String] = []
    var selectedCards = 0
    var selectedLevel = 0
    var hideCurrentCard = false
    var timer : NSTimer = NSTimer()
    var timerValue = 0

    
    //constants
    let cellId = "cardCell"
    
    //Outlets
    @IBOutlet weak var currentCard: UILabel!
    @IBOutlet weak var lblTimeLeft: UILabel!
    
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
        //Animar cambio
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let lblCell = cell?.viewWithTag(100) as! UILabel
        //match!
        if(lblCell.text == currentCard.text) {
            selectedCards++
            if didWin(){
                var alert = UIAlertController(title: "Congratz!", message: "You won GG 👏🏼🎉", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                cell!.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.4)
                
            }
            cardsForDealing = cardsForDealing.filter(){$0 != self.currentCard.text}
            if !didWin() {
                changeCurrentCard()
            }
        }
        
    }
    

    
    func didWin() -> Bool{
        return cardsForDealing.isEmpty
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as!UICollectionViewCell
        let lblCard:UILabel = cell.viewWithTag(100) as! UILabel
        lblCard.text = cards[indexPath.row]
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return cell
    }

    func shuffleCards(){
        for i in 0..<cards.count{
            var j = Int(arc4random())%cards.count
            let temp = cards[i]
            cards[i] = cards[j]
            cards[j] = temp
        }
    }
    
    func changeCurrentCard(){
        currentCard.text = cardsForDealing[Int(arc4random())%cardsForDealing.count]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nivel \(selectedLevel)"
        currentCard.hidden = hideCurrentCard
        changeCurrentCard()
        shuffleCards()
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "changeCurrentCard", userInfo: nil, repeats: true)
        println(timer.timeInterval.description)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

