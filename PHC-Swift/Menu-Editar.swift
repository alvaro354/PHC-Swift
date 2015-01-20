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
    var RADIO :CGFloat = 10.0
    let ALPHA :CGFloat = (10.0 * 3.1415/180.0)
    var numBotones : Int = 0
    var botones = [UIButton]()
    var padre: Imagen?
    var contador:Int = 0;
    let veces = 3;

    func mostrarMenu(imagenP:UIView ,padreP:UIViewController,botonTmp:UIButton)
    {
        RADIO = imagenP.frame.height + RADIO
        
       
        var boton: UIButton = UIButton(frame: CGRectMake(0,0, 50, 50))
        boton.tintColor = UIColor.blackColor()
        boton.setImage(UIImage(named:"Circulo.png")!, forState: UIControlState.Normal)
        boton.center = imagenP.center
        padreP.view.addSubview(boton)
        
        UIButton.animateWithDuration(1, delay: 0, options: .CurveEaseOut, animations:
            {
                var frameImagen = imagenP.frame
                if(self.contador > 0)
                {
                    var distanciaPuntos:CGFloat = self.RADIO * sin(self.ALPHA)
                    var x  = distanciaPuntos * sin((3.1415/2)-self.ALPHA)
                    var y = distanciaPuntos * sin(self.ALPHA)
                    
                    boton.frame.origin.y = CGFloat(UInt(botonTmp.frame.origin.y + y))
                    boton.frame.origin.x = CGFloat(UInt(botonTmp.frame.origin.x + x))
                    
                }
                else
                {
                    boton.frame.origin.y -= self.RADIO
                }
                
            }, completion:{ finished in
                println("Animacion Acabada")
                if(self.contador++ < self.veces)
                {
                    self.mostrarMenu(imagenP, padreP: padreP, botonTmp: boton)
                }
        })

        botones.append(boton)
        
        
    }
    
    
    
    
}