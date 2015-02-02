//
//  Menu-Editar.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 20/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit


 let opcionesBotones : [(String,String)] = [("Circulo.png","elegirColorBorde"),("Circulo.png",""),("Circulo.png",""),("Circulo.png","esconderMenu")]
 let opcionesEditar : [(String,String)] = [("Circulo.png","añadirFoto"),("Circulo.png","cambiarFondo")]

 var sharedMenu : MenuEditar? = nil

class MenuEditar : NSObject,ColorPickerDelegate
{
    //Si secambia radio y alpha al esocnder restablecer
    var RADIO :CGFloat = 30.0
    let ALPHA :CGFloat = (25.0 * 3.1415/180.0)
    var numBotones : Int = 0
    var botones = [UIButton]()
    var padre: UIView?
      var padreController: UIViewController?
    var contador:Int = 0;
    var veces = 0;
    var mostrando : Bool = false
    var centro : CGPoint?
    var datosImagen : Imagen?
    var menuColor:ColorPicker?

    func mostrarMenu(imagenP:UIView ,padreP:UIViewController,botonTmp:UIButton ,dImagen : Imagen? , botonOpciones: Bool)
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
        RADIO = (imagenP.bounds.size.height / 2) + RADIO
        var array : [(String,String)] = [(String,String)]()
            
            if(botonOpciones)
            {
                array = opcionesEditar
            }
            else
            {
                array = opcionesBotones
            }
            
            self.veces = array.count
            let(imagen:String,funcion:String) = array[botones.count]
       
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
                    boton.center.y =  imagenP.center.y - self.RADIO
                }
                boton.alpha = 1
                
            }, completion:{ finished in
                println("Animacion Acabada")
                if(++self.contador < self.veces)
                {
                    self.mostrarMenu(imagenP, padreP: padreP, botonTmp: boton ,dImagen: dImagen , botonOpciones : botonOpciones)
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
    
    func añadirFoto()
    {
        esconderMenu()
         (padreController as ModoLibre).mostrarOpcionesShapes()
    }
    
    func cambiarFondo()
    {
         esconderMenu()
        (padreController as ModoLibre).mostrarOpcionesShapes()
    }
    func elegirColorBorde()
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuColor = mainStoryboard.instantiateViewControllerWithIdentifier("ColorPicker") as? ColorPicker
        self.menuColor!.delegate = self
        padreController!.view.addSubview(menuColor!.view)
    }
 
     func eleccionColorFinalizado(color:UIColor)
     {
        añadirBorde(color)
    }
    
    func añadirBorde(color:UIColor)
    {
        var plantilla : UIImage?
        
        if (datosImagen!.borde)
        {
            datosImagen!.vistaBorde.removeFromSuperview()
        }
        
        //Plantilla Elegida
        switch Int(datosImagen!.intPlantilla)
        {
            case 0:
            plantilla = UIImage(named:"Circulo.png")!
            break;
            case 1:
            plantilla = UIImage(named:"Corazon.png")!
            break;
            case 2:
            plantilla = UIImage(named:"Cuadroc.png")!
            break;
            
            default:
            break;
            
        }

        
        //Radio del borde
        
        let radio : CGFloat = 8.0
        
        let imageSize:CGSize = CGSizeMake(300, 300);
        let fillColor : UIColor = color
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0);
        let context:CGContextRef  = UIGraphicsGetCurrentContext();
        fillColor.setFill()
        CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        let imagenView :UIImageView = padre as UIImageView

        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        let maskImageRef:CGImageRef  = plantilla!.CGImage;
        
        // create a bitmap graphics context the size of the image
        let mainViewContentContext:CGContextRef = CGBitmapContextCreate (nil, UInt(plantilla!.size.width), UInt(plantilla!.size.height), 8, 0, colorSpace, bitmapInfo);
        
        
        
        var ratio:CGFloat  = 0;
        let scale:CGFloat  = 0.5;
        
        ratio = plantilla!.size.width / image.size.width;
        
        if(ratio * image.size.height < plantilla!.size.height) {
            ratio = plantilla!.size.height / image.size.height;
        }
        
        let rect1:CGRect  = CGRectMake(0, 0,plantilla!.size.width , plantilla!.size.height)
        let rect2:CGRect  = CGRectMake(-((image.size.width*ratio) - plantilla!.size.width)/2 , -((image.size.height*ratio)-plantilla!.size.height)/2, image.size.width*ratio , image.size.height*ratio)
        
        UIColor.clearColor().setFill()
        CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
        CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
        CGAffineTransformMakeScale(scale,scale);
        
        // release that bitmap context
        let newImage:CGImageRef = CGBitmapContextCreateImage(mainViewContentContext);
        
        
        let theImage:UIImage  = UIImage(CGImage: newImage)!;

        //Calculamos el angulo
        
        
        let imagenViewF : UIImageView = UIImageView(image: theImage)
        imagenViewF.center =  imagenView.center
        imagenViewF.transform = imagenView.transform
        imagenViewF.transform = CGAffineTransformScale(imagenViewF.transform,(imagenView.bounds.width + radio) / imagenView.bounds.width  , (imagenView.bounds.height + radio) / imagenView.bounds.height )
        padreController!.view.insertSubview(imagenViewF, belowSubview: datosImagen!.vistaImagen)
        datosImagen?.vistaBorde = imagenViewF
        datosImagen?.borde = true
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
                   self.botones.removeAll(keepCapacity: false)
                   self.RADIO = 30.0
                }})

    }
    
    
    
}