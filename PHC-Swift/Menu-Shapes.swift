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
    
    optional func eleccionFinalizado(imagen:UIImage)
    
}


class MenuShapes : UIViewController, UICollectionViewDelegate ,UICollectionViewDataSource{
    
    @IBOutlet var cerrar : UIButton?
     var grid : UICollectionView?
    
     var delegate:ShapesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Inicializar Collection View
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        grid = UICollectionView(frame: CGRectMake(0,0, 300, 300), collectionViewLayout: layout )
        grid!.dataSource = self
        grid!.delegate = self
        grid!.layer.cornerRadius = 10
        grid!.center = self.view.center
        grid!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CeldaShape")
        
        self.view.addSubview(grid!)
        
        self.view.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cerrarVista()
    {
        self.view.removeFromSuperview()
    }
    
    //Delegado COllection
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CeldaShape", forIndexPath: indexPath) as UICollectionViewCell
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.eleccionFinalizado!(UIImage())
        self.cerrarVista()
    }
    
}
