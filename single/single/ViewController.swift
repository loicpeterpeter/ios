//
//  ViewController.swift
//  single
//
//  Created by loic on 01/11/2018.
//  Copyright © 2018 Loic. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    var motionManager = CMMotionManager()
    
    var location = CGPoint(x:0,y:0)
    var score = 0
    var ran = 1
    
    var perdu = false
    
    var runTimer:Timer!
    var perduTimer: Timer!
    
    var listTuile: Array<UIImageView> = []
    var re: Array<UIImageView> = []
    
    @IBOutlet weak var text: UITextField!
    
    @IBOutlet weak var pause: UIButton!
    
    @IBOutlet var Balle: UIImageView!
    
    @IBOutlet weak var Background: UIImageView!
    
    @IBOutlet weak var perduImage: UIImageView!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let contact = touch.location(in: view)
            
            location.x = contact.x-37
        }
    }
     //Activation du tactile pour les tests
     */
    
    
    func createTuile(x1:Int){
        let imageName = "bois.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: x1*100, y: -100, width: 100, height: 100)
        listTuile.append(imageView)
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        view.sendSubviewToBack(Background)
        
    }
    
    
    func deleteTuile(){
        re = []
        for element in listTuile{
            if (element.frame.origin.y==700){
                re.append(element)
                element.removeFromSuperview()
            }
        }
        for element in re{
            if let index = listTuile.index(of: element){
                listTuile.remove(at: index)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        motionManager.gyroUpdateInterval = 0.2
        motionManager.startGyroUpdates(to: OperationQueue.current!){(data, error) in
            if let myData = data{
                let x = myData.rotationRate.x
                self.location.x = self.location.x + CGFloat(x)
                self.Balle.frame.origin.x = self.Balle.frame.origin.x + self.location.x
                
                if self.Balle.frame.origin.x < 0{
                    self.Balle.frame.origin.x = 0
                }
                if self.Balle.frame.origin.x > 420{
                    self.Balle.frame.origin.x = 420
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Balle.frame.origin.x = 210
        
        location = Balle.frame.origin
        runTimer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(Run), userInfo: nil, repeats: true)
        pause.addTarget(self, action: #selector(Pause) , for: .touchUpInside)
        text.text = String(score)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubletap))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        createTuile(x1: ran)
        
        
        //Balle.transform = CGAffineTransform(translationX: location.x, y: location.y)
        
    }

    @objc func doubletap(){
        score = score * 2
    }

    
    @objc func Run(sender: UIButton!){
        deleteTuile()
        if (listTuile.count != 0){
            if (listTuile.last!.frame.origin.y == 0){
                createTuile(x1: ran)
                ran += Int.random(in: -1..<2)
                if(ran == -1) {ran = 0}
                if(ran == 4) {ran = 3}
                createTuile(x1: ran)
                score += 1
                //text.text = String(score)
                //text.text = String(listTuile.count)
            }
        }
        Balle.frame.origin = CGPoint(x: location.x, y:location.y)
        if (!perdu){
            for element in listTuile{
            element.frame.origin.y += 2
            }
            verif()
        }
        
    }
    
    func verif(){
        var boo = false
        if (listTuile.count >= 13){
            for element in listTuile{
                
                if (Int(element.frame.origin.y) < Int(Balle.frame.origin.y) + 37 && Int(Balle.frame.origin.y) - 37 < Int(element.frame.origin.y) + 50){
                    
                    if (Int(element.frame.origin.x) < Int(Balle.frame.origin.x) + 37 && Int(Balle.frame.origin.x) < Int(element.frame.origin.x) + 75){
                        boo = true
                    }
                    
                }
            }
            if (boo){
                score += 1
                text.text = String(score)
            }else{
                perdu = true
            }
        }
        if perdu{
            perduTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(retour), userInfo: nil, repeats: false)
            
        }
        }
        
    @objc func retour(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func Pause(sender: UIButton!){
        perdu = true
    }
    
}

