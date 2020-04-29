//
//  FeaturedHeaderView.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 29/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit
import Foundation

class FeaturedHeaderView : UIView {
 
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
            } else {
                imageView.image = nil
            }
        }
    }
    
}
