//
//  Menu-Editar.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 20/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit


 let opcionesBotones : [(String,String)] = [("Circulo.png","añadirBorde"),("Circulo.png",""),("Circulo.png",""),("Circulo.png","esconderMenu")]

 var sharedMenu : MenuEditar? = nil

class MenuEditar : NSObject
{
    
    var RADIO :CGFloat = 50.0
    let ALPHA :CGFloat = (30.0 * 3.1415/180.0)
    var numBotones : Int = 0
    var botones = [UIButton]()
    var padre: UIView?
      var padreController: UIViewController?
    var contador:Int = 0;
    let veces = 3;
    var mostrando : Bool = false
    var centro : CGPoint?
    var datosImagen : Imagen?

    func mostrarMenu(imagenP:UIView ,padreP:UIViewController,botonTmp:UIButton ,dImagen : Imagen )
    {
        if(mostrando && imagenP == padre)
        {
            esconderMenu()
        }
        else
        {
        padre = imagenP
        padreController = padreP
        datosImagen = dImagen
        RADIO = imagenP.frame.height - RADIO
    
            let (imagen:String,funcion:String) = opcionesBotones[botones.count]
       
        var boton: UIButton = UIButton(frame: CGRectMake(0,0, 30, 30))
        boton.tintColor = UIColor.blackColor()
        boton.setImage(UIImage(named:imagen)!, forState: UIControlState.Normal)
        boton.addTarget(self, action: Selector(funcion), forControlEvents: UIControlEvents.TouchDown)
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
                    self.mostrarMenu(imagenP, padreP: padreP, botonTmp: boton ,dImagen: dImagen)
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
    
    func añadirBorde()
    {
        //Radio del borde
        
        let radio : CGFloat = 8.0
        
        let imageSize:CGSize = CGSizeMake(300, 300);
        let fillColor : UIColor = UIColor.blackColor();
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0);
        let context:CGContextRef  = UIGraphicsGetCurrentContext();
        fillColor.setFill()
        CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        let imagenView :UIImageView = padre as UIImageView
        let   plantilla = UIImage(named:"Circulo.png")!
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        let maskImageRef:CGImageRef  = plantilla.CGImage;
        
        // create a bitmap graphics context the size of the image
        let mainViewContentContext:CGContextRef = CGBitmapContextCreate (nil, UInt(plantilla.size.width), UInt(plantilla.size.height), 8, 0, colorSpace, bitmapInfo);
        
        
        
        var ratio:CGFloat  = 0;
        let scale:CGFloat  = 0.5;
        
        ratio = plantilla.size.width / image.size.width;
        
        if(ratio * image.size.height < plantilla.size.height) {
            ratio = plantilla.size.height / image.size.height;
        }
        
        let rect1:CGRect  = CGRectMake(0, 0,plantilla.size.width , plantilla.size.height)
        let rect2:CGRect  = CGRectMake(-((image.size.width*ratio) - plantilla.size.width)/2 , -((image.size.height*ratio)-plantilla.size.height)/2, image.size.width*ratio , image.size.height*ratio)
        
        UIColor.clearColor().setFill()
        CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
        CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
        CGAffineTransformMakeScale(scale,scale);
        
        // release that bitmap context
        let newImage:CGImageRef = CGBitmapContextCreateImage(mainViewContentContext);
        
        
        let theImage:UIImage  = UIImage(CGImage: newImage)!;

        let imagenViewF : UIImageView = UIImageView(image: theImage)
        imagenViewF.frame = CGRectMake(0, 0, imagenView.frame.width+radio, imagenView.frame.height+radio)
        imagenViewF.center =  imagenView.center
       // CGAffineTransformScale(imagenViewF.transform,1.2, 1.2)
        padreController!.view.addSubview(imagenViewF)
        padreController!.view.sendSubviewToBack(imagenViewF)
        datosImagen?.vistaBorde = imagenViewF
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