//
//  Menu-Editar.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 20/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit


 let opcionesBotones : [(String,String)] = [("Boton-Terminar.png","elegirColorBorde"),("Boton-Terminar.png","mostrarMenuCambiarAlpha"),("Boton-Terminar.png",""),("Boton-Volver.png","esconderMenu")]
 let opcionesEditar : [(String,String)] = [("Circulo.png","añadirFoto"),("Circulo.png","cambiarFondo")]

 var sharedMenu : MenuEditar? = nil

class MenuEditar : NSObject,MenuColorPickerDelegate
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
    var datosImagenTmp : Imagen?
    var datosImagen : Imagen?
    var menuColor:MenuColorPicker?
    var viewBotones: UIView = UIView()
    var imagenB :UIImageView!
     var imagenF:UIImageView!
    var alphaFinal : CGFloat = 0.0
    var fondoMenu : UIVisualEffectView?;
    var botonCerrar : UIButton!
    
    
    func mostrarMenu2(imagenP:UIView ,padreP:UIViewController,botonTmp:UIButton ,dImagen : Imagen?, botonOpciones: Bool)
    {
        self.contador = 0
        padre = imagenP
        padreController = padreP
        datosImagen = dImagen
        
         viewBotones = UIView(frame: padreP.view.frame)
        viewBotones.center = padreController!.view.center
        
        fondoMenu = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        fondoMenu!.frame = padreP.view.bounds
        viewBotones.addSubview(fondoMenu!)
        (padreP as ModoLibre).view.addSubview(viewBotones)
        
        let tap = UITapGestureRecognizer(target:self, action:Selector("esconderMenu"))
        tap.numberOfTapsRequired = 1
        viewBotones.addGestureRecognizer(tap)
        
        
        var array : [(String,String)] = [(String,String)]()
        array = opcionesBotones
        
        self.veces = array.count
        
        for(var i = 0 ; i < array.count ; i++)
        {
            
            let(imagen:String,funcion:String) = array[i]
            var boton: UIButton = UIButton(frame: CGRectMake(0,0, 100, 100))
            boton.tintColor = UIColor.blackColor()
            boton.setImage(UIImage(named:imagen)!, forState: UIControlState.Normal)
            boton.addTarget(self, action: Selector(funcion), forControlEvents: UIControlEvents.TouchDown)
            boton.center = imagenP.center
            boton.alpha = 0
            viewBotones.addSubview(boton)
        
            boton.transform = CGAffineTransformScale(boton.transform,0.01, 0.01)
        
            botones.append(boton)
        }
    
        (padreP as ModoLibre).botonesHide(true)
        padreP.view.bringSubviewToFront(viewBotones);
       animarEntradaBotones(0)
      
        
    }
    
    func animarEntradaBotones(var vez : Int)
    {
     //  self.padreController!.view.bringSubviewToFront(self.viewBotones);
        var boton : UIButton = self.botones[vez]
        
        UIButton.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
            {
                
                
                boton.transform = CGAffineTransformScale(boton.transform,100, 100)
                boton.frame = CGRectMake(60 + CGFloat((vez % 2) * 160 ),150 + CGFloat((vez / 2) * 200), 100, 100)
                boton.alpha = 1
                
            }, completion:{ finished in
                println("Animacion Acabada")
                
                
                if(++self.contador < self.veces)
                {
                    self.animarEntradaBotones(self.contador)
                   
                }
                else
                {
                    self.centro=self.padre!.center
                    self.mostrando = true
                    
                    
                }
                
                
        })
    }

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
        (padreP as ModoLibre).vistaCollage.addSubview(boton)
        
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
            (padreController as ModoLibre).botonesHide(false)
            fondoMenu?.removeFromSuperview()
            esconderMenuRecursivo(true)
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
        self.menuColor = mainStoryboard.instantiateViewControllerWithIdentifier("MenuColorPicker") as? MenuColorPicker
        self.menuColor!.delegate = self
        padreController!.view.addSubview(menuColor!.view)
    }
 
     func eleccionColorFinalizado(color:UIColor)
     {
        añadirBorde(color)
    }
    
    func mostrarMenuCambiarAlpha()
    {
        esconderMenuRecursivo(false)
    }
    func mostrarCambiarAlpha()
    {
        datosImagenTmp = Imagen()
        
        botonCerrar = UIButton(frame: CGRectMake(0,0, 30, 30))
        botonCerrar!.tintColor = UIColor.blackColor()
        botonCerrar!.setImage(UIImage(named:"Boton-Cerrar.png")!, forState: UIControlState.Normal)
        botonCerrar!.addTarget(self, action: Selector("finalizar"), forControlEvents: UIControlEvents.TouchDown)
        botonCerrar!.center = CGPointMake(viewBotones.bounds.width - 80, 80)
        viewBotones.addSubview(botonCerrar!)
        
        imagenB = UIImageView(frame: datosImagen!.vistaBorde.frame)
        imagenB.image = datosImagen!.vistaBorde.image
        imagenB.alpha = datosImagen!.vistaBorde.alpha
        imagenB.center = padreController!.view.center
        imagenB.center.y -= 50
        datosImagenTmp?.vistaBorde = imagenB
        
        imagenF = UIImageView(frame: datosImagen!.vistaImagen.frame)
        imagenF.image = datosImagen!.vistaImagen.image
        imagenF.alpha = datosImagen!.vistaImagen.alpha
        imagenF.center = padreController!.view.center
        imagenF.center.y -= 50
        datosImagenTmp?.vistaImagen = imagenF
        
        var barra = UISlider(frame: CGRectMake(0, 0, 230, 20))
        barra.minimumValue = 0.0
        barra.maximumValue = 1.0
        barra.value = Float(imagenF.alpha)
        barra.center =  padreController!.view.center
        barra.center.y = padreController!.view.frame.height - 100
        barra.addTarget(self, action: Selector("valorModificado:"), forControlEvents: UIControlEvents.ValueChanged)

        viewBotones.addSubview(imagenB)
        viewBotones.addSubview(imagenF)
        viewBotones.addSubview(barra)
    }
    
    func valorModificado(sender : UISlider)
    {
     //   datosImagenTmp?.cambiarAlpha(CGFloat(sender.value))
        imagenB.alpha = CGFloat(sender.value)
        imagenF.alpha = CGFloat(sender.value)
        alphaFinal = CGFloat(sender.value)
    }
    
    func finalizar()
    {
        datosImagen?.cambiarAlpha(alphaFinal)
        self.viewBotones.removeFromSuperview()
        (padreController as ModoLibre).botonesHide(false)
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
        (padreController! as ModoLibre).vistaCollage.insertSubview(imagenViewF, belowSubview: datosImagen!.vistaImagen)
        datosImagen?.vistaBorde = imagenViewF
        datosImagen?.borde = true
        
        self.esconderMenu()
    }

    func esconderMenuRecursivo( eliminarVista:Bool)
    {
    
     self.mostrando=false
        
      UIButton.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
            {
                if(self.contador > 0)
                {
                    self.botones[self.contador-1].transform = CGAffineTransformMakeScale(0.01, 0.01)
                    self.botones[self.contador-1].center = self.centro!
                    self.botones[self.contador-1].alpha = 0
                    
                }

                
            }, completion:{ finished in
                
                if(self.contador > 0)
                {
                    self.botones[self.contador-1].removeFromSuperview()
                    self.botones.removeLast()
                    self.contador--
                    self.esconderMenuRecursivo(eliminarVista)
                }
                else
                {
                    if(eliminarVista)
                    {
                self.viewBotones.removeFromSuperview()
                   self.botones.removeAll(keepCapacity: false)
                    }
                    else
                    {
                        self.mostrarCambiarAlpha()
                    }
                    
                    self.RADIO = 30.0
                }})

    }
    
    
    
}