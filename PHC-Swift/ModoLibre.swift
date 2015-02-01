//
//  ModoLibre.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 18/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

class ModoLibre: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate , CortarDelegate ,ShapesDelegate, ColorPickerDelegate{
    
    //Declaracion Variables
    
    var cameraRoll = UIImagePickerController()
    var cortarView:Cortar?
    var menuShapes:MenuShapes?
    var menuColor:ColorPicker?
    var menuEditar: MenuEditar = MenuEditar()
    var imagenes : [Imagen] = [Imagen]()
    var imagenT : Imagen?
    var intElegidoShape :Int = 0
    var vistaBotones : UIView = UIView()
    
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
    @IBAction func pasarMenuOpciones(sender : UIButton)
    {
        // presentViewController(cameraRoll, animated: true, nil);
        
       //  menuEditar.mostrarMenu(sender,padreP: self, botonTmp: UIButton(),dImagen: nil , botonOpciones : true)
        
        vistaBotones = UIView(frame: self.view.frame)
        vistaBotones.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        self.view.addSubview(vistaBotones)
        
        var boton: UIButton = UIButton(frame: CGRectMake(0,0, 60, 60))
        boton.tintColor = UIColor.blackColor()
        boton.setImage(UIImage(named:"Circulo.png")!, forState: UIControlState.Normal)
        boton.addTarget(self, action: Selector("mostrarOpcionesShapes"), forControlEvents: UIControlEvents.TouchDown)
        boton.center = self.view.center
        boton.center.x -= (boton.bounds.size.width)
        vistaBotones.addSubview(boton)
        
        var botonFondo: UIButton = UIButton(frame: CGRectMake(0,0, 60, 60))
        botonFondo.tintColor = UIColor.blackColor()
        botonFondo.setImage(UIImage(named:"Circulo.png")!, forState: UIControlState.Normal)
        botonFondo.addTarget(self, action: Selector("mostrarOpcionesFondo"), forControlEvents: UIControlEvents.TouchDown)
        botonFondo.center = self.view.center
        botonFondo.center.x += (botonFondo.bounds.size.width)
        vistaBotones.addSubview(botonFondo)
        
    }
    
    func mostrarOpcionesFondo()
    {
        vistaBotones.removeFromSuperview()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuColor = mainStoryboard.instantiateViewControllerWithIdentifier("ColorPicker") as? ColorPicker
        self.menuColor!.delegate = self
        self.view.addSubview(menuColor!.view)
    }
     func mostrarOpcionesShapes()
    {
       // presentViewController(cameraRoll, animated: true, nil);
        
        vistaBotones.removeFromSuperview()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuShapes = mainStoryboard.instantiateViewControllerWithIdentifier("MenuShapes") as? MenuShapes
        self.menuShapes!.delegate = self
        self.view.addSubview(menuShapes!.view)

    }
    
    @IBAction func pasarMenuPrincipal(sender: UIButton)
    {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    //Funcion eñegir color
    
    func elegirColorBorde(imagenP:Imagen)
    {
        
        imagenT = imagenP
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuColor = mainStoryboard.instantiateViewControllerWithIdentifier("ColorPicker") as? ColorPicker
        self.menuColor!.delegate = self
        self.view.addSubview(menuColor!.view)
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
            self.cortarView!.inicializar(tempImage, plantillaC:self.imagenShape, delegado:self)
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
        
        if(imagen.borde)
        {
            imagen.vistaBorde.center = CGPoint(x:imagen.vistaBorde.center.x + translation.x,
            y:imagen.vistaBorde.center.y + translation.y)
        }
        
        recognizer.setTranslation(CGPointZero, inView: self.view)

        
    }
    
    func tocar(recognizer:UIPanGestureRecognizer) {
        
       // NSLog("Tocar");
        // Traer al frente
        menuEditar.esconderMenu()
        
        var imagen = self.devolverImagen(recognizer.view!)!
        
        if(imagen.borde)
        {
            self.view.bringSubviewToFront(imagen.vistaBorde);
        }
        
        self.view.bringSubviewToFront(imagen.vistaImagen);
        
        
        
    }
    
    func rotar(recognizer:UIRotationGestureRecognizer) {
       // NSLog("Rotar");
        menuEditar.esconderMenu()
        
          var imagen = self.devolverImagen(recognizer.view!)!
        
        imagen.vistaImagen.transform = CGAffineTransformRotate(imagen.vistaImagen.transform, recognizer.rotation)
        
        if(imagen.borde)
        {
        imagen.vistaBorde.transform = CGAffineTransformRotate(imagen.vistaBorde.transform, recognizer.rotation)
        }
        recognizer.rotation = 0
        
    }
    
    func zoom(recognizer : UIPinchGestureRecognizer) {
        //NSLog("Zoom");
        menuEditar.esconderMenu()
        
         var imagen = self.devolverImagen(recognizer.view!)!
        
        imagen.vistaImagen.transform = CGAffineTransformScale(imagen.vistaImagen.transform,
            recognizer.scale, recognizer.scale)
        
        if(imagen.borde)
        {
        imagen.vistaBorde.transform = CGAffineTransformScale(imagen.vistaBorde.transform,
            recognizer.scale, recognizer.scale)
        }
        
        recognizer.scale = 1
    }
    
    func borrar(recognizer : UIPinchGestureRecognizer) {
       // NSLog("Borrar");
        menuEditar.esconderMenu()
        var imagen : Imagen = self.devolverImagen(recognizer.view!)!
        
        
        imagen.borrar()
        
        menuEditar.esconderMenu()
    }
    
    func longPress(recognizer : UIPinchGestureRecognizer) {
        // NSLog("Borrar");
       if(recognizer.state == UIGestureRecognizerState.Began)
       {
        menuEditar.mostrarMenu(recognizer.view!,padreP: self, botonTmp: UIButton(),dImagen:self.devolverImagen(recognizer.view!)!, botonOpciones : false)
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
        imagen.intPlantilla = intElegidoShape
        imagen.añadir(self);
    }
    
    // Delegate Eleccion Shape
    
    func eleccionFinalizado(imagen:Int)
    {
        intElegidoShape = imagen
        
        switch imagen
        {
        case 0:
            imagenShape = UIImage(named:"Circulo.png")!
            break;
        case 1:
            imagenShape = UIImage(named:"Corazon.png")!
            break;
        case 2:
            imagenShape = UIImage(named:"Cuadroc.png")!
            break;
           
        default:
            break;
            
        }
        
        
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
    
    func eleccionColorFinalizado(color:UIColor)
    {
        self.view.backgroundColor = color
    }
}
