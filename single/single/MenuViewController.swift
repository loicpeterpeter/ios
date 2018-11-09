//
//  MenuViewController.swift
//  single
//
//  Created by loic on 09/11/2018.
//  Copyright © 2018 Loic. All rights reserved.
//

import Foundation

import UIKit

class MenuViewController: UIViewController{
    
    @IBOutlet weak var viewName: UIView!
    
    @IBOutlet weak var ButtonStart: UIButton!
    
    @IBOutlet weak var en: UIButton!
    
    @IBOutlet weak var fr: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        fr.addTarget(self, action: #selector(FR) , for: .touchUpInside)
        en.addTarget(self, action: #selector(EN) , for: .touchUpInside)
        
        
    }
    
    @objc func FR(){
        ButtonStart.setImage(UIImage(named: "play.png"), for: .normal)
    }
    
    @objc func EN(){
        ButtonStart.setImage(UIImage(named: "jouer.png"), for: .normal)
    }
}
