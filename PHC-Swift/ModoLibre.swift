//
//  ModoLibre.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 18/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

class ModoLibre: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Declaracion Variables
    
    var cameraRoll = UIImagePickerController();
   
    
    @IBOutlet var BotonMenuPrincipal: UIButton?
    @IBOutlet var BotonMenuOpciones: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraRoll.delegate = self
        cameraRoll.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        cameraRoll.allowsEditing = true
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
        // Acciones
    
    @IBAction func pasarMenuOpciones(sender: UIButton)
    {
        presentViewController(cameraRoll, animated: true, nil);
    }
    
    @IBAction func pasarMenuPrincipal(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    // Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MenuPrincipal"
        {
            
        }
    }
    
    // Metodos Camera Roll
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
        var tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        //imagePreview.image  = tempImage
        var imagen = Imagen(imagen:tempImage);
        imagen.añadir(self);

        
        cameraRoll.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        
        cameraRoll.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    
    // Funciones de modificacion
    
    func mover(recognizer:UIPanGestureRecognizer) {
    
        NSLog("Mover");
        
    }
    
    func tocar(recognizer:UIPanGestureRecognizer) {
        
        NSLog("Tocar");
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            NSLog("Tocado");
        }
    }
}
