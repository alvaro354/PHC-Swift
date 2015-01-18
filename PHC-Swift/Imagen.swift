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
        vistaImagen = UIImageView(frame:CGRectMake(200.0,200.0,150,150));
        vistaImagen.image = imagen;
    }
    
    func ponerImagen(imagen:UIImage)
    {
       // let width = CGImageGetWidth(imagen.CGImage) / 2;
       // let height = CGImageGetHeight(imagen.CGImage) / 2;
        
        vistaImagen = UIImageView(frame:CGRectMake(200.0,200.0,150,150));
        vistaImagen.image = imagen;
    }
    
    func añadir(controller:UIViewController)
    {
        padre = controller;
         vistaImagen.userInteractionEnabled = true;
        vistaImagen.multipleTouchEnabled = true
        // Gestures
        move = UIPanGestureRecognizer(target:padre!, action:Selector("mover:"))
        move!.delegate = padre as ModoLibre
        vistaImagen.addGestureRecognizer(move!)
        
        let tap = UITapGestureRecognizer(target:padre!, action:Selector("tocar:"))
        tap.delegate = padre as ModoLibre
        tap.numberOfTapsRequired = 1
        vistaImagen.addGestureRecognizer(tap)
        
        let borrar = UITapGestureRecognizer(target:padre!, action:Selector("borrar:"))
        borrar.delegate = padre as ModoLibre
        borrar.numberOfTapsRequired = 2
        vistaImagen.addGestureRecognizer(borrar )
        
        let rotate = UIRotationGestureRecognizer(target:padre!, action:Selector("rotar:"))
        rotate.delegate = padre as ModoLibre
        vistaImagen.addGestureRecognizer(rotate)
        
        let pitch = UIPinchGestureRecognizer(target:padre!, action:Selector("zoom:"))
        pitch.delegate = padre as ModoLibre
        vistaImagen.addGestureRecognizer(pitch)
        
        
        // Añadir
        
        
        controller.view.addSubview(vistaImagen);
        controller.view.bringSubviewToFront(vistaImagen);
    }
    
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
}