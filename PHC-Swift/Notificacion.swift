//
//  Notificacion.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 28/2/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit



 class Notificacion : UIView
{
    
     var fondoMenu : UIVisualEffectView?;
    
    func notfFotoGuardada(padre : UIViewController)
    {
        fondoMenu = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        fondoMenu!.frame = padre.view.bounds
        
        self.insertSubview(fondoMenu!, atIndex: 0)
        
        var imagen: UIImageView = UIImageView(frame: CGRectMake(0, 0, 200, 200))
        imagen.image = UIImage(named: "Boton-Terminar.png")
        imagen.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
        imagen.alpha = 0
        imagen.transform = CGAffineTransformScale(imagen.transform,10, 10)
        self.addSubview(imagen)
        
        padre.view.addSubview(self)
        
        UIView.animateWithDuration(0.20, delay: 0, options: .CurveEaseOut, animations:
            {
                imagen.alpha = 1
                imagen.transform = CGAffineTransformScale(imagen.transform,0.1, 0.1)
                
                
            }, completion:{ finished in
                
               
                
                UIView.animateWithDuration(0.20, delay: 2, options: .CurveEaseOut, animations:
                    {
                        self.alpha = 0
                        
                        
                    }, completion:{ finished in
                        
                        self.removeFromSuperview()
                })
        })

        
        
        
    }
    
    
    
    
}
