//
//  ViewController.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 18/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

infix operator ^ { associativity left precedence 140 }

func ^(radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

class ViewController: UIViewController {

    //Declaracion Variables
    
    @IBOutlet var ModoLibre: UIButton?
    @IBOutlet var vistaLibre: UIView?
    @IBOutlet var vistaFrame: UIView?
     var imagenFondo : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var imagen: UIImage = UIImage(named: "ImagenFondo.jpg")!
        var aspecRadio = imagen.size.height / self.view.bounds.height
        
        
    
        
        imagenFondo = UIImageView (frame: CGRectMake(0, 0, imagen.size.width * (1 / aspecRadio), self.view.bounds.height))
        imagenFondo?.image = imagen
        
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = imagenFondo!.bounds
        
        imagenFondo?.addSubview(visualEffectView)
        self.view.insertSubview(imagenFondo!, atIndex: 0)
        
        UIImageView.animateWithDuration(50, delay: 0, options: .CurveEaseOut, animations:
            {
                self.imagenFondo!.center.x =  self.imagenFondo!.center.x - (self.imagenFondo!.bounds.width / 2)
                
            }, completion:{ finished in
                
                // self.animarFondo(vez)
        })
     
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
    /*
    func animarFondo(vez: Int)
    {
        var diferenciaPosicion : Int = Float(pow(Double(-1), Double(vez)))  * Float((vez * self.imagenFondo!.bounds.width / 2))
        
        UIImageView.animateWithDuration(50, delay: 0, options: .CurveEaseOut, animations:
            {
                self.imagenFondo!.center.x =  self.imagenFondo!.center.x + diferenciaPosicion
                
            }, completion:{ finished in
                
               // self.animarFondo(vez)
        })
        
    }
    
 */

}

