//
//  Menu-Shapes.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 24/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

@objc protocol ShapesDelegate
{
    
    optional func eleccionFinalizado(imagen:Int)
    
}

 let opcionesShapes : [String] = ["Circulo.png","Corazon.png","Cuadroc.png"]

class MenuShapes : UIViewController, UICollectionViewDelegate ,UICollectionViewDataSource{
    
    
    
    @IBOutlet var cerrar : UIButton?
     var grid : UICollectionView?
    
     var delegate:ShapesDelegate?
    var fondoMenu : UIVisualEffectView?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Inicializar Collection View
        
        
        fondoMenu = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        fondoMenu!.frame = self.view.bounds
        
        
        self.view.addSubview(fondoMenu!)
        
        
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        grid = UICollectionView(frame: CGRectMake(0,0, 300, 300), collectionViewLayout: layout )
        grid!.dataSource = self
        grid!.delegate = self
        grid!.layer.cornerRadius = 10
        grid!.center = self.view.center
        grid!.registerClass(CeldaShape.self, forCellWithReuseIdentifier: "CeldaShape")
        grid!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:0.6 )
        self.view.addSubview(grid!)
       /*
        var viewFondoGrid : UIView = UIView(frame: grid!.frame)
        viewFondoGrid.backgroundColor = UIColor.clearColor()
        viewFondoGrid.layer.cornerRadius = 10
        self.view.insertSubview(viewFondoGrid, belowSubview: grid!)
        
        
        var fondoMenuGrid : UIVisualEffectView?;
        fondoMenuGrid = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        fondoMenuGrid!.frame = viewFondoGrid.bounds
        fondoMenuGrid!.layer.cornerRadius = 10
        viewFondoGrid.addSubview(fondoMenuGrid!)
        */
        //self.view.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        
        let vistaAtras : UIView = UIView(frame: self.view.bounds)
        vistaAtras.center = self.view.center
        self.view.insertSubview(vistaAtras, belowSubview: grid!)
        
        let tap = UITapGestureRecognizer(target:self, action:Selector("cerrarVista"))
        tap.numberOfTapsRequired = 1
        vistaAtras.addGestureRecognizer(tap)
        
        
        //Animamo la entrada
        
         self.grid!.transform = CGAffineTransformScale(self.grid!.transform,0.01, 0.01)
        
        UIView.animateWithDuration(0.20, delay: 0, options: .CurveEaseOut, animations:
            {
                
                self.grid!.transform = CGAffineTransformScale(self.grid!.transform,100.0, 100.0)
                
                
            }, completion:{ finished in
                
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cerrarVista()
    {
        UIView.animateWithDuration(0.20, delay: 0, options: .CurveEaseOut, animations:
            {
                
                self.grid!.transform = CGAffineTransformScale(self.grid!.transform,0.01, 0.01)
                 self.fondoMenu!.alpha = 0
                
            }, completion:{ finished in
                
                self.view.removeFromSuperview()
        })
        
    }
    
    //Delegado COllection
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return opcionesShapes.count
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CeldaShape", forIndexPath: indexPath) as CeldaShape
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.clearColor()
        cell.imageView.image = UIImage(named: opcionesShapes[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.eleccionFinalizado!(indexPath.row)
        self.cerrarVista()
    }
    
}

