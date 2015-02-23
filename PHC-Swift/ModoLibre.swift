 //
//  ModoLibre.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 18/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

class ModoLibre: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate , CortarDelegate ,ShapesDelegate, MenuColorPickerDelegate,FondoDelegate,MenuOpcionesDelegate{
    
    //Declaracion Variables
    
    var cameraRoll = UIImagePickerController()
    var cortarView:Cortar?
    var menuShapes:MenuShapes?
    var menuColor:MenuColorPicker?
    var fondoSelector:FondoSelector?
    var menuOpciones:MenuOpciones?
    var menuEditar: MenuEditar = MenuEditar()
    var imagenes : [Imagen] = [Imagen]()
    var imagenT : Imagen?
    var intElegidoShape :Int = 0
    var vistaBotones : UIView = UIView()
    var camaraFondo : Bool = false
     var viewFondo : UIImageView = UIImageView()
    
    //Menus Mostrar
    
    var labelIzq:UILabel = UILabel()
    var labelDer:UILabel = UILabel()
    var botonFondo: UIButton = UIButton()
    var boton: UIButton = UIButton()
    
    @IBOutlet var botonMenuPrincipal: UIButton?
    @IBOutlet var botonMenuOpciones: UIButton?
    
    var imagenShape: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraRoll.delegate = self
        cameraRoll.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        cameraRoll.allowsEditing = false
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animarEntradaMenu()
    {
     //   vistaBotones.alpha=0
                
                UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut, animations:
                    {
                        
                        self.boton.transform = CGAffineTransformScale(self.boton.transform,100, 100)
                       // self.labelDer.alpha = 1
                        self.botonFondo.transform = CGAffineTransformScale(self.botonFondo.transform,100, 100)
                       // self.labelIzq.alpha = 1
                        
                    }, completion:{ finished in
                        
                        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut, animations:
                            {
                              self.labelDer.alpha = 1
                              self.labelIzq.alpha = 1
                                
                            }, completion:{ finished in
                                
                                // Animamos los botones
                                
                                
                                
                        })
                        
                        
                        
                })

    }
    
    func animarCambioMenu()
    {
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut, animations:
            {
                
                self.labelDer.alpha = 0
                self.labelIzq.alpha = 0
                
            }, completion:{ finished in
                
                UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseOut, animations:
                    {
                        self.boton.transform = CGAffineTransformScale(self.boton.transform,0.01, 0.01)
                        // self.labelDer.alpha = 1
                        self.botonFondo.transform = CGAffineTransformScale(self.botonFondo.transform,0.01, 0.01)
                        // self.labelIzq.alpha = 1
                        
                    }, completion:{ finished in
                        
                        // Animamos los botones
                        
                       self.mostrarOpcionesFondo()
                })
                
                
                
        })
        
    }
    
        // Acciones
    @IBAction func pasarMenuOpciones(sender : UIButton)
    {
        // presentViewController(cameraRoll, animated: true, nil);
        
       //  menuEditar.mostrarMenu(sender,padreP: self, botonTmp: UIButton(),dImagen: nil , botonOpciones : true)
        
        
        //Atributios del texto
        let parag = NSMutableParagraphStyle()
        parag.alignment = NSTextAlignment.Center
        
        let font = UIFont(name: "Arial Rounded MT Bold", size: 24.0)
        let attrs = Dictionary(dictionaryLiteral: (NSFontAttributeName, font!),(NSForegroundColorAttributeName,  UIColor.whiteColor()),(NSParagraphStyleAttributeName,         parag) )
        let attributedString = NSAttributedString(string: "Shapes", attributes: attrs)
        let attributedString2 = NSAttributedString(string: "Fondo", attributes: attrs)
        
        vistaBotones = UIView(frame: self.view.frame)
        vistaBotones.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
      //  vistaBotones.alpha=0
        self.view.addSubview(vistaBotones)
        
        let vista = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        vista.frame = vistaBotones.frame
        vistaBotones.addSubview(vista)
        
        boton = UIButton(frame: CGRectMake(0,0, 150, 150))
        boton.tintColor = UIColor.blackColor()
        boton.setImage(UIImage(named:"Boton-Shapes.png")!, forState: UIControlState.Normal)
        boton.addTarget(self, action: Selector("mostrarOpcionesShapes"), forControlEvents: UIControlEvents.TouchDown)
        boton.center = self.view.center
        boton.center.x -= 90
        boton.center.y -= 20
        vistaBotones.addSubview(boton)
        
        labelIzq = UILabel()
        labelIzq.attributedText = attributedString
        labelIzq.frame = boton.frame
        labelIzq.center.y += 100
        labelIzq.shadowColor = UIColor.blackColor()
        labelIzq.shadowOffset = CGSizeMake(2, 0)
        vistaBotones.addSubview(labelIzq)
        
        
        botonFondo = UIButton(frame: CGRectMake(0,0, 150, 150))
        botonFondo.tintColor = UIColor.blackColor()
        botonFondo.setImage(UIImage(named:"Boton-FondoColor.png")!, forState: UIControlState.Normal)
        botonFondo.addTarget(self, action: Selector("animarCambioMenu"), forControlEvents: UIControlEvents.TouchDown)
        botonFondo.center = self.view.center
        botonFondo.center.x += 90
        botonFondo.center.y -= 20
        vistaBotones.addSubview(botonFondo)
        
        
        labelDer = UILabel()
        labelDer.attributedText = attributedString2
        labelDer.frame = botonFondo.frame
        labelDer.center.y += 100
        labelDer.shadowColor = UIColor.blackColor()
        labelDer.shadowOffset = CGSizeMake(2, 0)
        vistaBotones.addSubview(labelDer)
        
        let tap = UITapGestureRecognizer(target:self, action:Selector("cerrar:"))
        tap.numberOfTapsRequired = 1
        vistaBotones.addGestureRecognizer(tap)
        
        
        //Animamos la entrada 
        
        boton.transform = CGAffineTransformScale(boton.transform,0.01, 0.01)
        botonFondo.transform = CGAffineTransformScale(botonFondo.transform,0.01 ,0.01)
        labelIzq.alpha = 0
        labelDer.alpha = 0
        animarEntradaMenu()

        
    }
   
    
    func mostrarOpcionesFondo()
    {
        self.boton.setImage(UIImage(named:"Boton-FondoFoto.png")!, forState: UIControlState.Normal)
        self.boton.removeTarget(self, action: Selector("mostrarOpcionesShapes"), forControlEvents: UIControlEvents.TouchDown)
        self.boton.addTarget(self, action: Selector("mostrarFondoFoto"), forControlEvents: UIControlEvents.TouchDown)
        
        self.botonFondo.setImage(UIImage(named:"Boton-Color.png")!, forState: UIControlState.Normal)
        self.botonFondo.removeTarget(self, action: Selector("animarCambioMenu"), forControlEvents: UIControlEvents.TouchDown)
        self.botonFondo.addTarget(self, action: Selector("mostrarFondoColor"), forControlEvents: UIControlEvents.TouchDown)
        
        let parag = NSMutableParagraphStyle()
        parag.alignment = NSTextAlignment.Center
        
        let font = UIFont(name: "Arial Rounded MT Bold", size: 24.0)
        let attrs = Dictionary(dictionaryLiteral: (NSFontAttributeName, font!),(NSForegroundColorAttributeName,  UIColor.whiteColor()),(NSParagraphStyleAttributeName,         parag) )
        let attributedString = NSAttributedString(string: "Foto", attributes: attrs)
        let attributedString2 = NSAttributedString(string: "Color", attributes: attrs)
        
        
        self.labelIzq.attributedText = attributedString
        self.labelDer.attributedText = attributedString2
        self.animarEntradaMenu()
    }
    
    func mostrarFondoFoto()
    {
        /*
        camaraFondo = true
        cameraRoll.allowsEditing = false
        vistaBotones.removeFromSuperview()
        presentViewController(cameraRoll, animated: true, nil);
 */
        
        
        vistaBotones.removeFromSuperview()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.fondoSelector  = mainStoryboard.instantiateViewControllerWithIdentifier("FondoSelector") as? FondoSelector
        self.fondoSelector!.delegate = self
        self.view.addSubview(fondoSelector!.view)
    }
    func mostrarFondoColor()
    {
        vistaBotones.removeFromSuperview()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuColor = mainStoryboard.instantiateViewControllerWithIdentifier("MenuColorPicker") as? MenuColorPicker
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
        self.menuColor = mainStoryboard.instantiateViewControllerWithIdentifier("MenuColorPicker") as? MenuColorPicker
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
        var tempImage:UIImage
        
        if(picker.allowsEditing)
        {
            tempImage = info[UIImagePickerControllerEditedImage] as UIImage
        }
        else
        {
            tempImage = info[UIImagePickerControllerOriginalImage] as UIImage
        }
        //imagePreview.image  = tempImage

        
        cameraRoll.dismissViewControllerAnimated(true, completion: {
            
            if(self.camaraFondo)
            {
                //Foto Para el fondo
                self.viewFondo.removeFromSuperview()
                self.viewFondo = UIImageView(frame: self.view.bounds)
                self.viewFondo.image = tempImage
                self.view.insertSubview(self.viewFondo, atIndex: 0)
                
                self.camaraFondo = false
            }
            else
            {
                //Foto para un Shape
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            self.cortarView = mainStoryboard.instantiateViewControllerWithIdentifier("CortarSB") as? Cortar
            self.cortarView!.inicializar(tempImage, plantillaC:self.imagenShape, delegado:self)
            self.presentViewController(self.cortarView!, animated: true, nil);
            }
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
        
        
        self.traerBotonesAlfrente()

        
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
        
        
        self.traerBotonesAlfrente()
        
        
        
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
        
        
        self.traerBotonesAlfrente()
        
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
        
        
        self.traerBotonesAlfrente()
    }
    
    func borrar(recognizer : UIPinchGestureRecognizer) {
       // NSLog("Borrar");
        menuEditar.esconderMenu()
        var imagen : Imagen = self.devolverImagen(recognizer.view!)!
        
        
        imagen.borrar()
        
        menuEditar.esconderMenu()
        self.traerBotonesAlfrente()
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
        
        self.traerBotonesAlfrente()
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
        
        cameraRoll.allowsEditing = true
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
        viewFondo.removeFromSuperview()
        self.view.backgroundColor = color
    }
    
    func eleccionFondoFinalizado(imagen:String)
    {
        self.viewFondo.removeFromSuperview()
        self.viewFondo = UIImageView(frame: self.view.bounds)
        self.viewFondo.image = UIImage(named: imagen)
        self.view.insertSubview(self.viewFondo, atIndex: 0)
        
        self.camaraFondo = false
    }
    
    @IBAction func mostrarMenuOpciones()
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuOpciones = mainStoryboard.instantiateViewControllerWithIdentifier("MenuOpciones") as? MenuOpciones
        self.menuOpciones!.delegate = self
        self.view.addSubview(menuOpciones!.view)
    }
    
    func volverMenuPrincipal()
    {
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func capturarImagen() -> UIImage
    {
         botonMenuPrincipal!.hidden = true
         botonMenuOpciones!.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        botonMenuPrincipal!.hidden = false
        botonMenuOpciones!.hidden = false
        
        return image
        
    }
    
    func traerBotonesAlfrente()
    {
        self.view.bringSubviewToFront(botonMenuOpciones!)
        self.view.bringSubviewToFront(botonMenuPrincipal!)
    }
    func cerrar(recognizer:UIPanGestureRecognizer)
    {
        recognizer.view?.removeFromSuperview()
    }
}
