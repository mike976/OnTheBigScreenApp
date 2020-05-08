//
//  UIImageViewExtensions.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 08/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit
import Foundation
import AlamofireImage


extension UIImageView  {
    
    func downloadImage(with url: URL) {
           
           self.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholder"), runImageTransitionIfCached: true)
                    
           self.contentMode = .scaleAspectFill
//           self.layer.masksToBounds = true
//           self.clipsToBounds = true
//
//           self.sizeToFit()
       }
    
    
}


extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return  UIApplication.shared.statusBarFrame.size.height +
         (navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
