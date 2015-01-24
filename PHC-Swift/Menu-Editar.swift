//
//  Menu-Editar.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 20/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit



 var sharedMenu : MenuEditar? = nil

class MenuEditar : NSObject
{
    var RADIO :CGFloat = 50.0
    let ALPHA :CGFloat = (30.0 * 3.1415/180.0)
    var numBotones : Int = 0
    var botones = [UIButton]()
    var padre: UIView?
    var contador:Int = 0;
    let veces = 3;
    var mostrando : Bool = false
    var centro : CGPoint?

    func mostrarMenu(imagenP:UIView ,padreP:UIViewController,botonTmp:UIButton)
    {
        if(mostrando && imagenP == padre)
        {
            esconderMenu()
        }
        else
        {
        padre = imagenP
        RADIO = imagenP.frame.height - RADIO
    
       
        var boton: UIButton = UIButton(frame: CGRectMake(0,0, 30, 30))
        boton.tintColor = UIColor.blackColor()
        boton.setImage(UIImage(named:"Circulo.png")!, forState: UIControlState.Normal)
        boton.center = imagenP.center
        boton.alpha = 0
        padreP.view.addSubview(boton)
        
        UIButton.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
            {
                var frameImagen = imagenP.frame
                if(self.contador > 0)
                {
                    var translateTransform:CGAffineTransform  = CGAffineTransformMakeTranslation(imagenP.center.x, imagenP.center.y);
                    var rotationTransform: CGAffineTransform  = CGAffineTransformMakeRotation(self.ALPHA);
                    
                    var customRotation:CGAffineTransform  = CGAffineTransformConcat(CGAffineTransformConcat( CGAffineTransformInvert(translateTransform), rotationTransform), translateTransform);
                    
                    var rotatedPoint:CGPoint = CGPointApplyAffineTransform(botonTmp.center, customRotation);
                    
                    boton.center = rotatedPoint
                    
                }
                else
                {
                    boton.frame.origin.y -= self.RADIO
                }
                boton.alpha = 1
                
            }, completion:{ finished in
                println("Animacion Acabada")
                if(self.contador++ < self.veces)
                {
                    self.mostrarMenu(imagenP, padreP: padreP, botonTmp: boton)
                }
                else
                {
                    self.mostrando=true
                    self.centro=self.padre!.center
                }
        })

        botones.append(boton)
        }
        
    }
    
    func esconderMenu()
    {
        if(mostrando)
        {
            esconderMenuRecursivo()
        }
    }

    func esconderMenuRecursivo()
    {
    
     self.mostrando=false
    
      UIButton.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
            {
                if(self.contador > 0)
                {
                    self.botones[self.contador-1].center = self.centro!
                    self.botones[self.contador-1].alpha = 0
                    
                }

                
            }, completion:{ finished in
                
                if(self.contador > 0)
                {
                    self.botones[self.contador-1].removeFromSuperview()
                    self.botones.removeLast()
                    self.contador--
                    self.esconderMenuRecursivo()
                }
                else
                {
                   
                    self.RADIO = 50.0
                }})

    }
    
    
    
}