//
//  Imagen.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 18/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import Foundation
import UIKit


class Imagen: NSObject, UIGestureRecognizerDelegate{
    
    var vistaImagen : UIImageView;
    var padre:AnyObject? = nil ;
    
    //PanGestures
    
    var move:UIPanGestureRecognizer?;

    init(imagen:UIImage)
    {
        vistaImagen = UIImageView(frame:CGRectMake(200.0,200.0,100,100));
        vistaImagen.image = imagen;
    }
    
    func ponerImagen(imagen:UIImage)
    {
       // let width = CGImageGetWidth(imagen.CGImage) / 2;
       // let height = CGImageGetHeight(imagen.CGImage) / 2;
        
        vistaImagen = UIImageView(frame:CGRectMake(200.0,200.0,100,100));
        vistaImagen.image = imagen;
    }
    
    func añadir(controller:UIViewController)
    {
        padre = controller;
         vistaImagen.userInteractionEnabled = true;
        // Gestures
        move = UIPanGestureRecognizer(target:padre!, action:Selector("mover:"))
        move!.delegate = self;
        //vistaImagen.addGestureRecognizer(move!)
        
        let tap = UITapGestureRecognizer(target:padre!, action:Selector("tocar:"))
        tap.numberOfTapsRequired = 1
        vistaImagen.addGestureRecognizer(tap)
        
        
        // Añadir
        
        
        controller.view.addSubview(vistaImagen);
        controller.view.bringSubviewToFront(vistaImagen);
    }
    
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
}