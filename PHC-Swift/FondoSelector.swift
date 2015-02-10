//
//  FondoSelector.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 9/2/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//


import UIKit

class FondoSelector : FondoMenus, iCarouselDataSource, iCarouselDelegate
{
    
  var carousel : iCarousel!
    var botonCerrar : UIButton?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        carousel = iCarousel(frame: self.view.bounds)
        carousel.center = view.center
        carousel.dataSource = self
        carousel.delegate = self
        carousel.type = .CoverFlow2
        self.view.addSubview(carousel)
        
        botonCerrar = UIButton(frame: CGRectMake(0,0, 30, 30))
        botonCerrar!.tintColor = UIColor.blackColor()
        botonCerrar!.setImage(UIImage(named:"Circulo.png")!, forState: UIControlState.Normal)
        botonCerrar!.addTarget(self, action: Selector("cerrar"), forControlEvents: UIControlEvents.TouchDown)
        botonCerrar!.center = CGPointMake(self.view.bounds.width - 80, 80)
        self.view.addSubview(botonCerrar!)
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        return 10
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView!
    {
        var label: UILabel! = nil
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            view = UIImageView(frame:CGRectMake(0, 0, 100, 100))
            (view as UIImageView!).image = UIImage(named: "Circulo.png")
            view.contentMode = .Center
            
            label = UILabel(frame:view.bounds)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.font = label.font.fontWithSize(50)
            label.tag = 1
            view.addSubview(label)
        }
        else
        {
            //get a reference to the label in the recycled view
            label = view.viewWithTag(1) as UILabel!
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        
        
        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 1.1
        }
        return value
    }
    
    func cerrar()
    {
        self.view.removeFromSuperview()
    }
    
}

