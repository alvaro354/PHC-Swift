//
//  FondoMenus.swift
//  PHC-Swift
//
//  Created by Alvaro Lancho on 9/2/15.
//  Copyright (c) 2015 LanchoSoftware. All rights reserved.
//

import UIKit


class FondoMenus : UIViewController
{
    var fondoMenu : UIVisualEffectView?;
    
    
      override func viewDidLoad()
      {
          super.viewDidLoad()
        
        fondoMenu = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        fondoMenu!.frame = self.view.bounds
        
        self.view.addSubview(fondoMenu!)
        
        }
    
    
  

    
}

