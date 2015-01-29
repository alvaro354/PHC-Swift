//
//  ModoLibre.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 18/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

class ModoLibre: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate , CortarDelegate ,ShapesDelegate{
    
    //Declaracion Variables
    
    var cameraRoll = UIImagePickerController()
    var cortarView:Cortar?
    var menuShapes:MenuShapes?
    var menuEditar: MenuEditar = MenuEditar()
    var imagenes : [Imagen] = [Imagen]()
    
    @IBOutlet var BotonMenuPrincipal: UIButton?
    @IBOutlet var BotonMenuOpciones: UIButton?
    
    var imagenShape: UIImage = UIImage()
    
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
       // presentViewController(cameraRoll, animated: true, nil);
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuShapes = mainStoryboard.instantiateViewControllerWithIdentifier("MenuShapes") as? MenuShapes
        self.menuShapes!.delegate = self
        self.view.addSubview(menuShapes!.view)

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
        menuEditar.esconderMenu()
        let translation = recognizer.translationInView(self.view)
        
        var imagen = self.devolverImagen(recognizer.view!)!
        
        imagen.vistaImagen.center = CGPoint(x:imagen.vistaImagen.center.x + translation.x,
            y:imagen.vistaImagen.center.y + translation.y)
        imagen.vistaBorde.center = CGPoint(x:imagen.vistaBorde.center.x + translation.x,
            y:imagen.vistaBorde.center.y + translation.y)
        
        recognizer.setTranslation(CGPointZero, inView: self.view)

        
    }
    
    func tocar(recognizer:UIPanGestureRecognizer) {
        
       // NSLog("Tocar");
        // Traer al frente
        menuEditar.esconderMenu()
        self.view.bringSubviewToFront(recognizer.view!);
        
    }
    
    func rotar(recognizer:UIRotationGestureRecognizer) {
       // NSLog("Rotar");
        menuEditar.esconderMenu()
        
          var imagen = self.devolverImagen(recognizer.view!)!
        
        imagen.vistaImagen.transform = CGAffineTransformRotate(imagen.vistaImagen.transform, recognizer.rotation)
        imagen.vistaBorde.transform = CGAffineTransformRotate(imagen.vistaBorde.transform, recognizer.rotation)
        
        recognizer.rotation = 0
        
    }
    
    func zoom(recognizer : UIPinchGestureRecognizer) {
        //NSLog("Zoom");
        menuEditar.esconderMenu()
        
         var imagen = self.devolverImagen(recognizer.view!)!
        
        imagen.vistaImagen.transform = CGAffineTransformScale(imagen.vistaImagen.transform,
            recognizer.scale, recognizer.scale)
        
        imagen.vistaBorde.transform = CGAffineTransformScale(imagen.vistaBorde.transform,
            recognizer.scale, recognizer.scale)
        
        recognizer.scale = 1
    }
    
    func borrar(recognizer : UIPinchGestureRecognizer) {
       // NSLog("Borrar");
        menuEditar.esconderMenu()
         var imagen = self.devolverImagen(recognizer.view!)!
        
         imagen.vistaBorde.removeFromSuperview()
         imagen.vistaImagen.removeFromSuperview()
        
        menuEditar.esconderMenu()
    }
    
    func longPress(recognizer : UIPinchGestureRecognizer) {
        // NSLog("Borrar");
       if(recognizer.state == UIGestureRecognizerState.Began)
       {
        menuEditar.mostrarMenu(recognizer.view!,padreP: self, botonTmp: UIButton(),dImagen:self.devolverImagen(recognizer.view!)!)
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
    
    // Delegate Eleccion Shape
    
    func eleccionFinalizado(imagen:UIImage)
    {
        imagenShape = imagen
        presentViewController(cameraRoll, animated: true, nil);
    }
    
    func devolverImagen(vista:UIView) -> Imagen?
    {
        let vistaBuscar :UIImageView = vista as UIImageView
        let imagenT : Imagen?
        
        for imagen in imagenes
        {
            if(imagen.vistaImagen == vistaBuscar)
            {
                return imagen
                break
            }
        }
        
        return imagenT
    }
}
