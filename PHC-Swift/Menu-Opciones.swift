//
//  FondoSelector.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 9/2/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//


@objc protocol MenuOpcionesDelegate
{
    
    optional func eleccionFondoFinalizado(imagen:String)
    
}

import UIKit


class MenuOpciones: UIViewController
{
    
    let imagenes : [String] = ["imagenFondo1.png","imagenFondo2.png"]
    
    var delegate:MenuOpcionesDelegate?
    var fondoMenu : UIVisualEffectView?;
    var contadorTmp : Int = 0
    var posicionX : CGFloat = 0
    var vistaBotones : [VistaBoton] = [VistaBoton]()
    
    @IBOutlet var vistaTerminar : VistaBoton?
    @IBOutlet var vistaAyuda : VistaBoton?
    @IBOutlet var vistaHome : VistaBoton?
    @IBOutlet var vistaCerrar : VistaBoton?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        vistaBotones.append(vistaTerminar!)
        vistaBotones.append(vistaAyuda!)
        vistaBotones.append(vistaHome!)
        vistaBotones.append(vistaCerrar!)
        
        fondoMenu = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        fondoMenu!.frame = self.view.bounds
        
        self.view.insertSubview(fondoMenu!, atIndex: 0)
        
        
        
        //Iniciamos los valores para la animacion
        
        posicionX = vistaTerminar!.center.x
        self.view.alpha = 0
        
        for vista : VistaBoton in vistaBotones
        {
            vista.alpha = 0
            vista.centroX = vista.center.x
            vista.center.x =  vista.center.x + self.view.bounds.width
        }
    
        //Animar alpha Entrada
    
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
            {
                self.view.alpha = 1
                
                
            }, completion:{ finished in
                
               // self.view.removeFromSuperview()
                
        })
        
        
         self.animarEntrada()
    }
    
    func animarEntrada()
    {
        
        
        var vistaB : VistaBoton  = self.vistaBotones[self.contadorTmp]
        
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations:
                {
                    vistaB.alpha = 1
                    vistaB.center.x =  vistaB.centroX
                    vistaB.centroX = 0
                    
                    
                }, completion:{ finished in
                    println("Animacion Acabada")
                    if(self.contadorTmp+1 < self.vistaBotones.count)
                    {
                        self.contadorTmp++
                        self.animarEntrada()
                    }
                    
            })
            
        
    }
    
    func animarSalida()
    {
         
        var vistaB : VistaBoton  = self.vistaBotones[self.contadorTmp]
        
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
            {
                vistaB.alpha = 0
                vistaB.center.x =  -self.view.bounds.width
                
                
            }, completion:{ finished in
                println("Animacion Acabada")
                if(self.contadorTmp > 0)
                {
                    self.contadorTmp--
                    self.animarSalida()
                }

                else
                {
                    //Alpha Vista
                    
                    UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
                        {
                            self.view.alpha = 0
                            
                            
                        }, completion:{ finished in
                           
                                self.view.removeFromSuperview()
                            
                    })
                }
                
                
        })
        
        
    }
    
   @IBAction func cerrar()
    {
      //  self.view.removeFromSuperview()
        animarSalida()
    }
    
}

