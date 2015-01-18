//
//  ViewController.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 18/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Declaracion Variables
    
    @IBOutlet var ModoLibre: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pasarModoLibre(sender: UIButton)
    {
          self.performSegueWithIdentifier("ModoLibre", sender: self);
    }

    
    // Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ModoLibre"
        {
            
        }
    }
}

