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
    @IBOutlet weak var cvCards: UICollectionView!
    @IBOutlet weak var btnRestart: UIButton!
    
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
        if lblCell.text == currentCard.text {
            selectedCards++
            cardsForDealing = cardsForDealing.filter(){$0 != self.currentCard.text}
            cell!.backgroundColor = UIColor(red: 0, green: 255, blue: 0, alpha: 0.4)
            if didWin(){
                btnRestart.enabled = true
                var alert = UIAlertController(title: "¡Felicidades!", message: "¡Has ganado! 👏🏼🎉", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.timer.invalidate()
                self.timer = NSTimer()
            }
            if !didWin() {
                changeCurrentCard()
            }
        }else{

            UIView.animateWithDuration(0.2, animations: {
                cell!.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.7)
                }, completion: {
                    (value:Bool) in
                    cell!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            })
        }
        
    }
    
    @IBAction func restartGame(sender: AnyObject) {
        //reset buttons background color
        cardsForDealing = cards
        for cell in cvCards.visibleCells() as! [UICollectionViewCell]{
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
        selectedCards = 0
        hideCurrentCard = false
        timerValue = 0
        viewDidLoad()
        shuffleCards()
        cvCards.reloadData()
        
    }

    
    func didWin() -> Bool{
        return cardsForDealing.isEmpty
    }
    
    //fill cards
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as!UICollectionViewCell
        let lblCard:UILabel = cell.viewWithTag(100) as! UILabel
        lblCard.text = cards[indexPath.row]
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return cell
    }

    func shuffleCards(){
        for i in 0..<cards.count{
//            var j = Int(arc4random_un())%cards.count
            var j = Int(arc4random_uniform(UInt32(cards.count)))
            let temp = cards[i]
            cards[i] = cards[j]
            cards[j] = temp
        }
    }
    
    func changeCurrentCard(){
        if !cardsForDealing.isEmpty{
            currentCard.text = cardsForDealing[Int(arc4random_uniform(UInt32(cardsForDealing.count)))]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nivel \(selectedLevel)"
        currentCard.hidden = hideCurrentCard
        changeCurrentCard()
        shuffleCards()
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "changeCurrentCard", userInfo: nil, repeats: true)
        btnRestart.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

