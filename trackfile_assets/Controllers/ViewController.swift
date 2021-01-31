//
//  ViewController.swift
//  NOBIS2020
//
//  Created by Henit Work on 07/01/21.
//

import UIKit
import anim


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
              self.performSegue(withIdentifier: "gonext", sender: self)
         })
        
        
        
        
        // Do any additional setup after loading the view.
    }
   
}

