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
    
    var carousel : iCarousel!
    var botonCerrar : UIButton?
    var delegate:MenuOpcionesDelegate?
    var fondoMenu : UIVisualEffectView?;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        fondoMenu = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        fondoMenu!.frame = self.view.bounds
        
        self.view.insertSubview(fondoMenu!, atIndex: 0)
    
    }
    
    func cerrar()
    {
        self.view.removeFromSuperview()
    }
    
}

