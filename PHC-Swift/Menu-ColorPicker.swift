//
//  ColorPicker.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 31/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

var size4Inch : Bool =   UIScreen.mainScreen().bounds.size.height == 568

import UIKit

@objc protocol MenuColorPickerDelegate
{
    
    optional func eleccionColorFinalizado(color:UIColor)
    
}



class MenuColorPicker : UIViewController,UIGestureRecognizerDelegate
{

    
    @IBOutlet var cerrar : UIButton?
    @IBOutlet var atras : UIButton?
    @IBOutlet var hueScroll : UIView?
    @IBOutlet var hueSelector : UIImageView?
    
    var tagColor: Int = 0
    
    var fondoMenu : UIVisualEffectView?;
    var delegate:MenuColorPickerDelegate?
    var colores : [UIColor] = [UIColor]()
    var botones : [UIView] = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fondoMenu = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        fondoMenu!.frame = self.view.bounds
         self.view.insertSubview(fondoMenu!, atIndex: 0)
        //Configuramos imagenes
        atras?.hidden = true
       
    
        
        for (var i = 0 ; i < 12; i++) {
            var hue : CGFloat = CGFloat(i) * 30.0 / 360.0;
            var colorCount  =  size4Inch ? 32 : 24;
            for (var x = 0; x < colorCount; x++) {
                var row = x / 4;
                var column = x % 4;
                
                var saturation : CGFloat = CGFloat(column) * 0.25 + 0.25;
                var luminosity : CGFloat = 1.0 - CGFloat(row ) * 0.12;
                var color : UIColor = UIColor(hue: hue, saturation: saturation, brightness: luminosity, alpha: 1.0)
                colores.append(color)
            }
        }
    
        
        colocarBotones()
       
    }
    
    func colocarGamaBotones()
    {
        //Borramos array Botones
        
        self.botones.removeAll(keepCapacity: true)
        
        var index = 0;
        var padding = 32.0
            var colorCount = size4Inch ? 32 : 24;
            for (var x = 0; x < colorCount && index < colores.count; x++) {
                var view : UIButton = UIButton()
                view.layer.cornerRadius = 25.0
                view.layer.borderWidth = 2.0
                view.layer.borderColor = UIColor.blackColor().CGColor
                var indexC : Int = (colorCount * tagColor) + index++
                var color : UIColor = colores[indexC]
                view.backgroundColor = color
                view.hidden = true
                
                view.addTarget(self, action: Selector("colorGridTapped:"), forControlEvents: UIControlEvents.TouchDown)
                
                var column = Int(x % 4);
                var row = Int(x / 4);
                // padding = Double(UIScreen.mainScreen().bounds.size.width) - Double(4.0 * 60.0) + Double(8.0 * 3.0) / 2
                view.frame = CGRectMake(CGFloat(padding)  + (CGFloat(column) * 80.0), 8.0 + CGFloat(row) * 70, 60, 60)
                self.setupShadow(view.layer)
                hueScroll?.addSubview(view)
                
                //Preparamos la animacion
                view.transform = CGAffineTransformScale(view.transform,0.01 ,0.01)
                botones.append(view)
            }
            padding += 32.0
        
        
        self.animarEntradaBotones(0)
        
     /*   let tap = UITapGestureRecognizer(target:self, action:Selector("colorGridTapped:"))
        tap.delegate = self
        hueScroll?.addGestureRecognizer(tap)*/
    }
    
    
    
    func colocarBotones()
    {
      self.botones.removeAll(keepCapacity: true)
        
        for (var i = 0 ; i < 12 ; i++)
        {
            var boton : UIButton = UIButton()
            boton.frame = CGRectMake(50.0 + CGFloat(Int( i % 3 )) * 100.0 ,  130 + (100.0 * CGFloat(Int( i / 3 ))) ,80,80)
            boton.layer.cornerRadius = 25.0
            boton.layer.borderWidth = 2.0
            boton.layer.borderColor = UIColor.blackColor().CGColor
            boton.backgroundColor = colores[3 + 24 * i]
            boton.tag = i
            boton.hidden = true
            boton.addTarget(self, action: Selector("botonSeleccionPulsado:"), forControlEvents: UIControlEvents.TouchDown)
            self.setupShadow(boton.layer)
            self.view.addSubview(boton)
            
            
            //Preparamos la animacion
            boton.transform = CGAffineTransformScale(boton.transform,0.01 ,0.01)
            botones.append(boton)
        }
        
        animarEntradaBotones(0)
    }
    
    @IBAction func volverAtras()
    {
         atras?.hidden = true
        self.animarSalidaBotones(self.botones.count-1 , mostrarGama: false, volver : true)

    }
    
    func botonSeleccionPulsado(boton: UIButton)
    {
       // var tamañoPagina : CGFloat =  self.hueScroll!.contentSize.width / CGFloat(11.5)
        tagColor = boton.tag
        self.animarSalidaBotones(self.botones.count-1 , mostrarGama: true, volver : false)
        
    }
    
    
    func colorGridTapped(boton : UIButton )
    {
       
        delegate!.eleccionColorFinalizado!(boton.backgroundColor!)
         self.animarSalidaBotones(self.botones.count-1 , mostrarGama: false,  volver : false)

    }
    
    func setupShadow(layer: CALayer) {
        
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOpacity = 0.8;
    layer.shadowOffset = CGSizeMake(0, 2);
    var rect: CGRect  = layer.frame;
    rect.origin = CGPointZero;
    layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).CGPath
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cerrarVista()
    {
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
            {
                    self.view.alpha = 0
                
            }, completion:{ finished in
                
               self.view.removeFromSuperview()
                
        })
    }
    
    //Animacipones
    
    func animarEntradaBotones(var index : Int)
    {
        
        UIView.animateWithDuration(0.03, delay: 0, options: .CurveEaseOut, animations: {
            
           self.botones[index].hidden = false;
            self.botones[index].transform = CGAffineTransformScale(self.botones[index].transform, 100, 100)
           
            
            }
            , completion:
            { finished in
                
                if(index+1 < self.botones.count)
                {
                    index = index + 1
                    self.animarEntradaBotones(index)
                }
                else
                {
                    NSLog("Animacion Parar")
                }
                
        })
    }
    
    func animarSalidaBotones(var index : Int , var mostrarGama : Bool , var volver : Bool)
    {
        
        UIView.animateWithDuration(0.03, delay: 0, options: .CurveEaseOut, animations: {
            
            self.botones[index].transform = CGAffineTransformScale(self.botones[index].transform, 0.01, 0.01)
            self.botones[index].hidden = true;
            
            }
            , completion:
            { finished in
                
                if(index > 0)
                {
                    index = index - 1
                    self.animarSalidaBotones(index , mostrarGama: mostrarGama , volver: volver)
                }
                else
                {
                    NSLog("Animacion Parar Salida")
                    if(mostrarGama)
                    {
                         self.atras?.hidden = false
                        self.colocarGamaBotones()
                    }
                    else if(volver)
                    {
                        self.colocarBotones()
                    }
                    else
                    {
                        self.cerrarVista()
                    }
                }
                
        })
    }
    
}