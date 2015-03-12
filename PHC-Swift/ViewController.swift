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
    
    @IBOutlet var vistaLibre: UIView?
    @IBOutlet var vistaFrame: UIView?
     var imagenFondo : UIImageView?
    var elegirCuadrado : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var imagen: UIImage? = UIImage(named: "ImagenFondo.jpg")!
        
        //Comprobamos si hay imagen anteriror
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let datosImagen: AnyObject = userDefaults.valueForKey("ultimaImagen"){
            
            imagen = UIImage(data: datosImagen as NSData)
            if(imagen == nil)
            {
                imagen = UIImage(named: "ImagenFondo.jpg")!
            }
            NSLog("Imagen Recuperada")
        }
        
        
        var aspecRadio = imagen!.size.height / self.view.bounds.height
        
        
        imagenFondo = UIImageView (frame: CGRectMake(0, 0, imagen!.size.width * (1 / aspecRadio), self.view.bounds.height))
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
        
           descargarImagen()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pasarModoLibre(sender: UIButton)
    {
        elegirCuadrado = (sender.tag == 1)
          self.performSegueWithIdentifier("ModoLibre", sender: self);
    }

    
    // Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ModoLibre"
        {
            var libre : ModoLibre = segue.destinationViewController as ModoLibre
            libre.cuadrado = elegirCuadrado
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
    
    func descargarImagen()
    {
       // var image : UIImage;
         var userDefaults = NSUserDefaults.standardUserDefaults()
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitDay, fromDate: date)
        var dia = components.day
        var urlString = "http://www.lanchosoftware.com:9095/imagenes/imagen" + toString(dia) + ".jpg"
        
        var imgURL: NSURL = NSURL(string:urlString)!
        
        if let ultimoDia: Int = userDefaults.valueForKey("ultimaDia") as? Int {
         
            if(dia != ultimoDia)
            {
        // Download an NSData representation of the image at the URL
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            
            if error == nil {

               
                userDefaults.setValue(data, forKey: "ultimaImagen")
                userDefaults.setValue(dia, forKey: "ultimaDia")
                userDefaults.synchronize() // don't forget this!!!!
                
                 println("Descargada Imagen")
                dispatch_async(dispatch_get_main_queue(), {
                      var  image = UIImage(data: data)!
                    //Animamos el cambiod e iamgen
                     self.imagenFondo!.image = image
                    //UIView.transitionWithView(self.imagenFondo!, duration: 2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.imagenFondo!.image = image },completion: nil)
                })
            }
            else {
                println("Error: \(error.localizedDescription)")
            }
        })
        }
        }
        else
        {
            // El dia no extiste lo creamos a 0
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(0, forKey: "ultimaDia")
            descargarImagen()
            
        }

    }

}

