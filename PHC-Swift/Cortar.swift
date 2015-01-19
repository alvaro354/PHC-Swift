//
//  Cortar.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho  on 19/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

@objc protocol CortarDelegate
{
    
    optional func cortarFinalizado(imagenCortada:UIImageView)
    optional func cortarCerrado()
    
}

class Cortar: UIViewController,UIScrollViewDelegate
{

     var delegate:CortarDelegate?
    var imagenView: UIImageView?
    var plantillaView: UIImageView = UIImageView();
    var plantilla: UIImage = UIImage();
    var photo:UIImage?
    var photoCortada:UIImage?
    var photoViewCortada:UIImageView = UIImageView();
    @IBOutlet var scrollView:UIScrollView?
    
 
    override init()
    {
        super.init()
    }
    
    init(imagenC:UIImage, delegado:CortarDelegate)
    {
         super.init(nibName: nil, bundle: nil)
        delegate=delegado
        photo = imagenC

    }

    required init(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }

    func inicializar(imagenC:UIImage, delegado:CortarDelegate)
    {
    delegate=delegado
    photo = imagenC
    
    }
    
    func ponerImagen()
    {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        var imageViewFrame:CGRect = CGRectMake(0.0, 0.0,self.photo!.size.width / 2,self.photo!.size.height / 2)
        
        self.scrollView!.contentSize = imageViewFrame.size;
        self.scrollView!.delegate = self
        scrollView!.minimumZoomScale = 0.5;
        scrollView!.maximumZoomScale = 3.0;
        
        self.imagenView = UIImageView(frame:CGRectMake(0.0, self.photo!.size.height / 4,self.photo!.size.width / 2,self.photo!.size.height / 2))
        self.imagenView!.image = photo
        self.scrollView!.addSubview(imagenView!)
        
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView!.addGestureRecognizer(doubleTapRecognizer)
        
        
         // centerScrollViewContents()
        
        //ponemos la plantilla
        
        ponerPlantilla()
        
    }

    @IBAction func cerrar()
    {
        delegate?.cortarCerrado!()
    }
    
    // Cortar
    
    @IBAction func cortar()
    {
        
        //Cortar
    
        let ox: CGFloat = self.scrollView!.contentOffset.x;
        let oy: CGFloat  = self.scrollView!.contentOffset.y;
        let zoomScale :CGFloat = self.scrollView!.zoomScale;
        let cx :CGFloat = (ox + self.plantillaView.frame.origin.x + 15.0) * 2.0 / zoomScale  ;
        let cy:CGFloat = (oy + self.plantillaView.frame.origin.y + 15.0) * 2.0 / zoomScale ;
        let cw: CGFloat  = 300.0 / zoomScale;
        let ch: CGFloat = 300.0 / zoomScale;
        let cropRect :CGRect = CGRectMake(cx, cy, cw, ch);
        
        
        
        let imageRef:CGImageRef = CGImageCreateWithImageInRect(self.photo!.CGImage, cropRect);
        
        photoCortada = UIImage(CGImage: imageRef)
        
        
        //Mask
        
        
        let maskLayer:CALayer = CALayer()
        maskLayer.contents = plantilla.CGImage
        //  maskLayer.contentsGravity = kCAGravityCenter;
        maskLayer.frame = CGRectMake(0.0, 0.0,plantilla.size.width,plantilla.size.height);
        
        photoViewCortada = UIImageView(frame:CGRectMake(0, 0, plantilla.size.width, plantilla.size.height));
        photoViewCortada.image = photo;
        
        photoViewCortada.layer.mask = maskLayer;
      //  viewToMask.layer.mask.borderWidth= 8;
     //   viewToMask.layer.mask.borderColor= [UIColor blueColor].CGColor;
        
        delegate?.cortarFinalizado!(photoViewCortada)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ponerImagen()
    }
    
    //Plantilla
    
    func ponerPlantilla()
    {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        plantilla = UIImage(named:"Circulo.png")!
        
        plantillaView = UIImageView(frame:CGRectMake(screenSize.width/2,screenSize.height/2,200,200));
        plantillaView.image = plantilla
        plantillaView.alpha = 0.5
        plantillaView.userInteractionEnabled = true
        plantillaView.multipleTouchEnabled = true
        
        let move = UIPanGestureRecognizer(target:self, action:Selector("mover:"))
        plantillaView.addGestureRecognizer(move)
        
        self.view.addSubview(plantillaView)
    }
    
    
    
    func mover(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x,
            y:recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
        
        
    }
    
    //Scroll View Delegados
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imagenView
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView!.bounds.size
        var contentsFrame = imagenView!.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imagenView!.frame = contentsFrame
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
       /* // 1
        let pointInView = recognizer.locationInView(imagenView)
        
        // 2
        var newZoomScale = scrollView!.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView!.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView!.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView!.zoomToRect(rectToZoomTo, animated: true)
*/
        scrollView!.zoomScale = 1.0;

    }

}