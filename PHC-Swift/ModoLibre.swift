//
//  ModoLibre.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 18/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

class ModoLibre: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate , CortarDelegate{
    
    //Declaracion Variables
    
    var cameraRoll = UIImagePickerController()
    var cortarView:Cortar?
    var menuEditar: MenuEditar = MenuEditar()
    
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
        var tempImage:UIImage = info[UIImagePickerControllerEditedImage] as UIImage
        //imagePreview.image  = tempImage

        
        cameraRoll.dismissViewControllerAnimated(true, completion: {
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            self.cortarView = mainStoryboard.instantiateViewControllerWithIdentifier("CortarSB") as? Cortar
            self.cortarView!.inicializar(tempImage, delegado:self)
            self.presentViewController(self.cortarView!, animated: true, nil);
        });
        
       
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        
        cameraRoll.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    
    // Funciones de modificacion
    
    func mover(recognizer:UIPanGestureRecognizer) {
    
        let translation = recognizer.translationInView(self.view)
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
            y:recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)

        
    }
    
    func tocar(recognizer:UIPanGestureRecognizer) {
        
       // NSLog("Tocar");
        // Traer al frente
        
        self.view.bringSubviewToFront(recognizer.view!);
        
    }
    
    func rotar(recognizer:UIRotationGestureRecognizer) {
       // NSLog("Rotar");
        recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
        recognizer.rotation = 0
        
    }
    
    func zoom(recognizer : UIPinchGestureRecognizer) {
        //NSLog("Zoom");
        recognizer.view!.transform = CGAffineTransformScale(recognizer.view!.transform,
            recognizer.scale, recognizer.scale)
        recognizer.scale = 1
    }
    
    func borrar(recognizer : UIPinchGestureRecognizer) {
       // NSLog("Borrar");
        recognizer.view!.removeFromSuperview()
    }
    
    func longPress(recognizer : UIPinchGestureRecognizer) {
        // NSLog("Borrar");
       if(recognizer.state == UIGestureRecognizerState.Began)
       {
            menuEditar.mostrarMenu(recognizer.view!,padreP: self, botonTmp: UIButton())
        }
    }
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    
    // Funciones Cortar Delegate 
    
    func cortarCerrado()
    {
        cortarView!.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func cortarFinalizado(imagenCortada:UIImageView)
    {
        
        cortarView!.dismissViewControllerAnimated(true, completion: nil);
        var imagen = Imagen(imagen:imagenCortada);
        imagen.añadir(self);
    }
}
