//
//  Social.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 21/2/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import Foundation
import UIKit
import Social

class Social {
    class var sharedSocial: Social {
        struct Static {
            static var instance: Social?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Social()
        }
        
        return Static.instance!
    }
    
    
    func subirTwitter(imagen : UIImage , vista : UIViewController)
    {
        // 1
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            // 2
            var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            // 3
            tweetSheet.setInitialText("Photocollage #PHC ")
            tweetSheet.addImage(imagen)
            
            // 4
             vista.presentViewController(tweetSheet, animated: true, completion: nil)
        } else {
            // 5
            println("Error al subir a Twitter")
        }
    }
    
    func subirFacebook(imagen :UIImage , vista : UIViewController)
    {
        // 1
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            // 2
            var facebookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            // 3
            facebookSheet.setInitialText("Photocollage #PHC ")
            facebookSheet.addImage(imagen)
            
            // 4
            
            vista.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            // 5
            println("Error al subir a Facebook")
        }
    }
    
    
    
}