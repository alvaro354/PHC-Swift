//
//  ColorPicker.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 31/1/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit

@objc protocol ColorPickerDelegate
{
    
    optional func eleccionColorFinalizado(color:UIColor)
    
}



class ColorPicker : UIViewController, UICollectionViewDelegate ,UICollectionViewDataSource{


    
    @IBOutlet var cerrar : UIButton?
    var grid : UICollectionView?
    var tag: Int = 0
    var colorPalette: [String] = [String]()
    var delegate:ColorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Inicializar Collection View
       /*
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        grid = UICollectionView(frame: CGRectMake(0,0, 300, 400), collectionViewLayout: layout )
        grid!.dataSource = self
        grid!.delegate = self
        grid!.layer.cornerRadius = 10
        grid!.center = self.view.center
        grid!.registerClass( UICollectionViewCell.self, forCellWithReuseIdentifier: "CeldaColor")
        
        self.view.addSubview(grid!)
        */
        self.view.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        
        //Cargamos el array de colores
        
        // Get colorPalette array from plist file
        let path = NSBundle.mainBundle().pathForResource("colorPalette", ofType: "plist")
        let pListArray = NSArray(contentsOfFile: path!)
        
        for  var index = 0 ; index < pListArray?.count; index++
        {
            colorPalette.append(pListArray?.objectAtIndex(index) as String)
        }
        
        
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
    
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    // UICollectionViewDataSource Protocol:
    // Returns the number of columns in collection view
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 16
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        //cell.layer.borderWidth = 1
       // cell.layer.borderColor =  UIColor.blackColor().CGColor
        
        cell.backgroundColor = hexStringToUIColor(colorPalette[tag])
        cell.tag = tag++

    
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("Color Elegido Pulsado")
        var cell: UICollectionViewCell  = collectionView.cellForItemAtIndexPath(indexPath)! as UICollectionViewCell
        delegate?.eleccionColorFinalizado!(cell.backgroundColor!)
        self.cerrarVista()
    }

    
    // This function converts from HTML colors (hex strings of the form '#ffffff') to UIColors
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (countElements(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}