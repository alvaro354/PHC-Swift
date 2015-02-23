//
//  ColorPicker.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 31/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

var size4Inch : Bool =   UIScreen.mainScreen().bounds.size.height == 568

import UIKit

@objc protocol MenuColorPickerDelegate
{
    
    optional func eleccionColorFinalizado(color:UIColor)
    
}



class MenuColorPicker : UIViewController,UIGestureRecognizerDelegate
{

    
    @IBOutlet var cerrar : UIButton?
    @IBOutlet var hueScroll : UIScrollView?
    @IBOutlet var hueSelector : UIImageView?
    
    var hueFloat: CGFloat = 0.0
    
    var fondoMenu : UIVisualEffectView?;
    var delegate:MenuColorPickerDelegate?
    var colores : [UIColor] = [UIColor]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fondoMenu = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        fondoMenu!.frame = self.view.bounds
         self.view.insertSubview(fondoMenu!, atIndex: 0)
        //Configuramos imagenes
        
    
        
        for (var i = 0 ; i < 12; i++) {
            var hue : CGFloat = CGFloat(i) * 30.0 / 360.0;
            var colorCount  =  size4Inch ? 32 : 24;
            for (var x = 0; x < colorCount; x++) {
                var row = x / 4;
                var column = x % 4;
                
                var saturation : CGFloat = CGFloat(column) * 0.25 + 0.25;
                var luminosity : CGFloat = 1.0 - CGFloat(row ) * 0.12;
                var color : UIColor = UIColor(hue: hue, saturation: saturation, brightness: luminosity, alpha: 1.0)
                colores.append(color)
            }
        }
        
        
        
        var index = 0;
        for (var i = 0; i < 12; i++) {
            var colorCount = size4Inch ? 32 : 24;
            for (var x = 0; x < colorCount && index < colores.count; x++) {
                var layer : CALayer = CALayer()
                layer.cornerRadius = 6.0;
                var color : UIColor = colores[index++];
                layer.backgroundColor = color.CGColor;
                
                var column = Int(x % 4);
                var row = Int(x / 4);
                layer.frame = CGRectMake(CGFloat(i) * 320.0 + 8.0 + (CGFloat(column) * 78.0), 8.0 + CGFloat(row) * 48, 70, 40)
                self.setupShadow(layer)
                hueScroll?.layer.addSublayer(layer)
            }
        }
        
        hueScroll?.contentSize = CGSizeMake(3840, 296);
        
        let tap = UITapGestureRecognizer(target:self, action:Selector("colorGridTapped:"))
        tap.delegate = self
        hueScroll?.addGestureRecognizer(tap)
       
    }
    
    func colorGridTapped(recognizer : UITapGestureRecognizer )
    {
        var point : CGPoint = recognizer.locationInView(self.hueScroll)
        var page : Int = Int(point.x / 320)
        var delta = Int(point.x % 320)
        
        var row : Int = Int(((point.y - 8) / 48))
        var column : Int = Int(((delta - 8) / 78))
        var colorCount = size4Inch ? 32 : 24;
        var index : Int = colorCount * page + row * 4 + column;
        if (index < colores.count) {
            delegate!.eleccionColorFinalizado!(colores[index])
            cerrarVista()
        }
    }
    
    func setupShadow(layer: CALayer) {
        
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOpacity = 0.8;
    layer.shadowOffset = CGSizeMake(0, 2);
    var rect: CGRect  = layer.frame;
    rect.origin = CGPointZero;
    layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).CGPath
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cerrarVista()
    {
        self.view.removeFromSuperview()
    }
    
    //Delegado Tap
    
}