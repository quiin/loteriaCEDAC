//
//  MemoryGameController.swift
//  LoteriaCEDAC
//
//  Created by Carlos Alejandro Reyna González on 07/09/15.
//  Copyright (c) 2015 CEDAC. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import MediaPlayer
import MultipeerConnectivity

class loteria: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, MCBrowserViewControllerDelegate, MCSessionDelegate {

    // List of connected devices
    var deviceArray: NSMutableArray = NSMutableArray();
    
    // Manages information.
    var session: MCSession!
    
    // Broadcast the device's information.
    var announcer: MCAdvertiserAssistant!
    
    // Looks for other discoverable devices running the application.
    var browser: MCBrowserViewController!
    
    // Device's ID Name.
    var peerID: MCPeerID!
    
    //vars
    var cards: [String] = []
    var cardsForDealing: [String] = []
    var connectedDevices = 0
    var counterCompletedDevices = 0
    var selectedCards = 0
    var selectedLevel = 0
    var gameMode = 0
    var hideCurrentCard = false
    //var timer : NSTimer = NSTimer()
    var timerValue = 0
    var currentCardName = ""
    
    //constants
    let cellId = "cardCell"
    
    //Outlets
    @IBOutlet weak var currentCard: UIImageView!
    @IBOutlet weak var cvCards: UICollectionView!
    @IBOutlet weak var btnRestart: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        //Animar cambio
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let lblCell = cell?.viewWithTag(100) as! UIImageView
        if self.gameMode == 2{//if im the dealer
            self.collectionView.userInteractionEnabled = false
            cell!.alpha = 0.5
            cell!.userInteractionEnabled = false
            let peers = self.session.connectedPeers
            let data = lblCell.image?.accessibilityIdentifier?.dataUsingEncoding(NSUTF8StringEncoding)
            do{
                try self.session.sendData(data!, toPeers: peers, withMode: MCSessionSendDataMode.Reliable)
            }
            catch{
                print("Error sending data")
            }
        }else{//if single player or not dealer
            //check for match
            if lblCell.image?.accessibilityIdentifier == self.currentCardName {
                
                if self.gameMode == 1 {//if player
                    self.collectionView.userInteractionEnabled = false
                    let peers = self.session.connectedPeers
                    let data = lblCell.image?.accessibilityIdentifier?.dataUsingEncoding(NSUTF8StringEncoding)
                    do{
                        try self.session.sendData(data!, toPeers: peers, withMode: MCSessionSendDataMode.Reliable)
                    }
                    catch{
                        print("Error sending data")
                    }
                }
                
                selectedCards++
                
                cardsForDealing.removeAtIndex(cardsForDealing.indexOf(self.currentCardName)!)
                
                cell!.alpha = 0.5
                
                if didWin(){
                    btnRestart.enabled = true
                    let alert = UIAlertController(title: "¡Felicidades!", message: "¡Has ganado! 👏🏼🎉", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    //self.timer.invalidate()
                    //self.timer = NSTimer()
                }
                if !didWin() {
                    changeCurrentCard()
                }
            }else{
                UIView.animateWithDuration(0.2, animations: {
                    cell!.alpha = 0.6
                    }, completion: {
                        (value:Bool) in
                        cell!.alpha = 1
                })
            }
        }
    }
    
    @IBAction func restartGame(sender: AnyObject) {
        //reset buttons background color
        cardsForDealing = cards
        for cell in cvCards.visibleCells() {
            cell.alpha = 1
        }
        selectedCards = 0
        hideCurrentCard = false
        timerValue = 0
        viewDidLoad()
        shuffleCards()
        cvCards.reloadData()
        
    }
    
    func playAudio(){
        let s = currentCardName.stringByReplacingOccurrencesOfString(".jpg", withString: "")
        print(s)
        let URL = NSBundle.mainBundle().URLForResource(s, withExtension: "wav")
        var soundID:SystemSoundID = 0
        AudioServicesCreateSystemSoundID(URL!, &soundID)
        AudioServicesPlayAlertSound(soundID)
    }

    @IBAction func playSound(sender: UITapGestureRecognizer) {
        playAudio()
    }
    
    func didWin() -> Bool{
        return cardsForDealing.isEmpty
    }
    
    //fill cards
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) 
        let lblCard:UIImageView = cell.viewWithTag(100) as! UIImageView
        lblCard.image = UIImage(named: cards[indexPath.row])
        lblCard.image?.accessibilityIdentifier = cards[indexPath.row]
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return cell
    }

    func shuffleCards(){
        for i in 0..<cards.count{
            let j = Int(arc4random_uniform(UInt32(cards.count)))
            let temp = cards[i]
            cards[i] = cards[j]
            cards[j] = temp
        }
    }
    
    func changeCurrentCard(){
        if !cardsForDealing.isEmpty{
            if self.gameMode == 0 { //if not multiplayer
                self.currentCardName = cardsForDealing[Int(arc4random_uniform(UInt32(cardsForDealing.count)))]
            }
            switch self.selectedLevel{
            case 1: currentCard.image = UIImage(named: self.currentCardName)
            case 2:
                currentCard.image = UIImage(named: "sound.png")
                currentCard.userInteractionEnabled = true
            default: print("")
            }
        }
    }
    
    private func configureSession() {
        // Create PeerID with the device's name.
        self.peerID = MCPeerID(displayName: "Simulator Number 4");
        // Create the session.
        self.session = MCSession(peer: self.peerID);
        self.session.delegate = self;
        // Create announcer.
        self.announcer = MCAdvertiserAssistant(serviceType: "Loteria CEDAC", discoveryInfo: nil, session: self.session);
        self.announcer.start();
    }
    
    // MARK: - Event Handler Methods
    
    @IBAction func connect(sender: UIButton) {
        self.browser = MCBrowserViewController(serviceType: "Loteria CEDAC", session: self.session);
        self.browser.delegate = self;
        self.presentViewController(self.browser, animated: true, completion: nil);
    }
    
    @IBAction func disconnect(sender: UIButton) {
        // Stops broadcasting data.
        self.announcer.stop();
        self.announcer.delegate = nil;
        
        // Disconnects and ends the session.
        self.session.disconnect();
        self.session.delegate = nil;
        
        self.deviceArray.removeAllObjects();
        // Restarts the app.
        self.configureSession();
    }
    
    // MARK: - Browser Methods
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        self.browser.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        self.browser.dismissViewControllerAnimated(true, completion: nil);
    }
    // MARK: - Session Methods
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        // Connects, Disconnects, and Cancels.
        let peerName = peerID.displayName;
        switch(state) {
        case MCSessionState.Connecting:
            print("Connecting With: \(peerName)");
        case MCSessionState.NotConnected:
            print("Was Disconnected: \(peerName)");
        case MCSessionState.Connected:
            print("Connection Established With: \(peerName)");
            self.deviceArray.addObject(peerName);
            print("Currently Connected: \(self.deviceArray)");
        }
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        // Peer data arrives.
        let receivedMessage = NSString(data: data, encoding: NSUTF8StringEncoding);
        print("Received Data: \(receivedMessage!)");
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if self.gameMode == 1 {//if player
                self.currentCardName = (receivedMessage?.description)!
                print((receivedMessage?.description)!)
                if self.selectedLevel != 2{
                    self.currentCard.image = UIImage(named: self.currentCardName)
                }else{
                    self.playAudio()
                }
                self.collectionView.userInteractionEnabled = true
            }else if self.gameMode == 2 {//if dealer
                self.counterCompletedDevices++
                if(self.counterCompletedDevices == self.deviceArray.count){
                    //All connected devices have guessed the card
                    self.collectionView.userInteractionEnabled = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        switch self.selectedLevel {
        case 1:
            self.cards = ["burro.jpg", "caballo.jpg", "cerdo.jpg", "delfin.jpg", "elefante.jpg", "foca.jpg", "gallo.jpg", "gato.jpg", "oveja.jpg",  "pavo.jpg", "perro.jpg", "pollo.jpg", "rana.jpg", "vaca.jpg"]
            self.cardsForDealing = ["burro.jpg", "caballo.jpg", "cerdo.jpg", "delfin.jpg", "elefante.jpg", "foca.jpg", "gallo.jpg", "gato.jpg", "oveja.jpg",  "pavo.jpg", "perro.jpg", "pollo.jpg", "rana.jpg", "vaca.jpg"]
        case 2:
            self.cards = ["burro.jpg", "caballo.jpg", "cerdo.jpg", "delfin.jpg", "elefante.jpg", "foca.jpg", "gallo.jpg", "gato.jpg", "oveja.jpg",  "pavo.jpg", "perro.jpg", "pollo.jpg", "rana.jpg", "vaca.jpg"]
            self.cardsForDealing = ["burro.jpg", "caballo.jpg", "cerdo.jpg", "delfin.jpg", "elefante.jpg", "foca.jpg", "gallo.jpg", "gato.jpg", "oveja.jpg",  "pavo.jpg", "perro.jpg", "pollo.jpg", "rana.jpg", "vaca.jpg"]
        case 3:
            self.cards = ["burro.jpg", "caballo.jpg", "cerdo.jpg", "delfin.jpg", "elefante.jpg", "foca.jpg", "gallo.jpg", "gato.jpg", "oveja.jpg",  "pavo.jpg", "perro.jpg", "pollo.jpg", "rana.jpg", "vaca.jpg"]
            self.cardsForDealing = ["burro.jpg", "caballo.jpg", "cerdo.jpg", "delfin.jpg", "elefante.jpg", "foca.jpg", "gallo.jpg", "gato.jpg", "oveja.jpg",  "pavo.jpg", "perro.jpg", "pollo.jpg", "rana.jpg", "vaca.jpg"]
        default:
            print("")
        }
        if(self.gameMode != 0 ){ //if multiplayer
            self.configureSession();
            print("Configuring session")
        }
        
        if self.gameMode == 1{ //if player
            self.collectionView.userInteractionEnabled = false
        }
       
        self.title = "Nivel \(selectedLevel)"
        print("game mode \(self.gameMode)")
        print("selected level \(selectedLevel)")
        currentCard.hidden = hideCurrentCard
        changeCurrentCard()
        shuffleCards()
        //timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "changeCurrentCard", userInfo: nil, repeats: true)
        btnRestart.enabled = false
    }
    
    // Unused Methods
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        return ;
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        return ;
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        return ;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

