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
    var vistaBorde : UIImageView;
    var padre:AnyObject? = nil ;
    var borde : Bool = false
    var intPlantilla :Int = 0
    //PanGestures
    
    var move:UIPanGestureRecognizer?;


    
    init(imagen:UIImageView)
    {
        vistaImagen = imagen
        vistaBorde = imagen
    }
    
    func ponerImagen(imagen:UIImageView)
    {
       // let width = CGImageGetWidth(imagen.CGImage) / 2;
       // let height = CGImageGetHeight(imagen.CGImage) / 2;
        
        vistaImagen = imagen
         vistaBorde = imagen
    }
    
    func borrar()
    {
    
        if(borde)
        {
            vistaBorde.removeFromSuperview()
        }
        
        vistaImagen.removeFromSuperview()
        
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
        
        let long = UILongPressGestureRecognizer(target:padre!, action:Selector("longPress:"))
        long.minimumPressDuration = 1
        long.delegate = padre as ModoLibre
        vistaImagen.addGestureRecognizer(long)
        
        
        // Añadir
        
        var modoLibre = controller as ModoLibre
        
         modoLibre.vistaCollage.addSubview(vistaImagen);
        modoLibre.vistaCollage.bringSubviewToFront(vistaImagen);
        modoLibre.imagenes.append(self)
        
        //Escalamos la imagen
        vistaImagen.transform = CGAffineTransformScale(vistaImagen.transform,
            0.6, 0.6)
    }
    
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
}