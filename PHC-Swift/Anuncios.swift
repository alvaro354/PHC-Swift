//
//  Anuncios.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 21/2/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import Foundation
import iAd

class Anuncios : NSObject, ADBannerViewDelegate
{
    class var sharedAnuncios: Anuncios {
        struct Static {
            static var instance: Anuncios?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Anuncios()
        }
        
        return Static.instance!
    }
    
    var iAd : ADBannerView = ADBannerView()
    
    
    
    
    func ponerAnuncioArriba(vista : UIView)
    {
        iAd = ADBannerView(adType: ADAdType.Banner)
        iAd.center.y = iAd.frame.size.height / 2
        iAd.delegate = self;
        
        vista.addSubview(iAd)
    }
    
    func ponerAnuncioAbajo(vista : UIView)
    {
        iAd = ADBannerView(adType: ADAdType.Banner)
        iAd.center.y = vista.bounds.size.height - iAd.frame.size.height / 2
        iAd.delegate = self;
        
        vista.addSubview(iAd)
    }
    
    func quitarAnuncio()
    {
        iAd.removeFromSuperview()
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("iAD error: %@",error)
        iAd.removeFromSuperview()
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        NSLog("Anuncio iAD Cargado")
    }
    
    
    
    
    
}