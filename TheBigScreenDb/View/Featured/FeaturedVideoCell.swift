//
//  FeaturedVideoCell.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 30/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit
import AlamofireImage

class FeaturedVideoCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie:Movie? = nil {
        didSet {
            if let movie = movie,
                let url = movie.poster_path {
                //let placeholderImage = UIImage(named: "placeholder")!
                let placeholderImage = UIImage()

                let filter = AspectScaledToFillSizeFilter(size: CGSize(width: 100, height: 150))
                imageView.af.setImage(withURL: url, placeholderImage: placeholderImage, filter: filter)
            } else {
                imageView.image = UIImage()
            }
            
//            if let movie = movie {
//                titleLabel.text = movie.title
//            }
            
        }
    }
    

}
