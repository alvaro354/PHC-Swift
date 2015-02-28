//
//  FondoSelector.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 9/2/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//


@objc protocol MenuOpcionesDelegate
{
    
    optional func volverMenuPrincipal()
    optional func capturarImagen() -> UIImage
    
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
    var cerrando: Bool = false
    @IBOutlet var vistaTerminar : VistaBoton?
    @IBOutlet var vistaAyuda : VistaBoton?
    @IBOutlet var vistaHome : VistaBoton?
    @IBOutlet var vistaCerrar : VistaBoton?
    
    @IBOutlet var vistaGeneralEleccion : UIView?
    
    
    @IBOutlet var vistaGeneralAcabar : UIView?
    
    @IBOutlet var vistaGuardar : VistaBoton?
    @IBOutlet var vistaTwitter : VistaBoton?
    @IBOutlet var vistaInstagram : VistaBoton?
    @IBOutlet var vistaFacebook : VistaBoton?
    @IBOutlet var vistaVolver : VistaBoton?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        vistaGeneralEleccion?.alpha = 1
        vistaGeneralAcabar?.alpha = 0
        
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
        
     
    
        //Animar alpha Entrada
    
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations:
            {
                self.view.alpha = 1
                
                
            }, completion:{ finished in
                
               // self.view.removeFromSuperview()
                
        })
        
        
        empezarAnimacion()
        
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
                            if(self.cerrando)
                            {
                                self.view.alpha = 0
                            }
                            
                        }, completion:{ finished in
                           
                            if(self.cerrando)
                            {
                                self.cerrando = false
                                self.view.removeFromSuperview()
                            }
                            else
                            {
                                self.cerrando = false
                                self.vistaGeneralEleccion?.alpha = 0
                                //Borramos los elementos
                                self.gestionBotonesArray(3)
                                //Metemos los nuevos elementos de la vista de Guardar, compartir ...
                                self.gestionBotonesArray(2)
                                self.empezarAnimacion()
                                self.vistaGeneralAcabar?.alpha = 1
                            
                            }
                            
                    })
                }
                
                
        })
        
        
    }
    
    @IBAction func guardarFotoCarrete()
    {
        self.view.alpha = 0
        UIImageWriteToSavedPhotosAlbum(delegate!.capturarImagen!(), nil, nil, nil)
        self.view.alpha = 1
        Notificacion().notfFotoGuardada(self)
       
    }
    
    @IBAction func subirFotoTwitter()
    {
        self.view.alpha = 0
        Social.sharedSocial.subirTwitter(delegate!.capturarImagen!(),vista: self)
        self.view.alpha = 1
    }
    
    @IBAction func subirFotoFacebook()
    {
        self.view.alpha = 0
        Social.sharedSocial
            .subirFacebook(delegate!.capturarImagen!(),vista: self)
        self.view.alpha = 1
    }
    
    
    @IBAction func mostrarAcabar()
    {
        cerrando = false
        animarSalida()
        
    }
    
   @IBAction func cerrar()
    {
      //  self.view.removeFromSuperview()
        cerrando = true
        animarSalida()
    }
    
    @IBAction func volverMenuPrincipal()
    {
        delegate!.volverMenuPrincipal!()
    }
    
    func empezarAnimacion()
    {
        for vista : VistaBoton in vistaBotones
        {
            vista.alpha = 0
            vista.centroX = vista.center.x
            vista.center.x =  vista.center.x + self.view.bounds.width
        }
        
        
        self.animarEntrada()
    }
    
    
    func gestionBotonesArray(opcion : Int)
    {
        switch opcion
        {
        case 1:
            vistaBotones.append(vistaTerminar!)
            vistaBotones.append(vistaAyuda!)
            vistaBotones.append(vistaHome!)
            vistaBotones.append(vistaCerrar!)
            break
        case 2:
            vistaBotones.append(vistaGuardar!)
            vistaBotones.append(vistaTwitter!)
            vistaBotones.append(vistaInstagram!)
            vistaBotones.append(vistaFacebook!)
            vistaBotones.append(vistaVolver!)
            break
        case  3:
            vistaBotones.removeAll(keepCapacity: false)
            break
        default:
            NSLog("Opcion Invalida")
            break
        }
    }
}

