//
//  FeaturedVideoCell.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 30/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit
import AlamofireImage

class VideoCell : UICollectionViewCell {
    
 
    
    
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var titleLabel: UILabel!
    
    var placeholderImage: UIImage?
      
    var title:String?
    
    var movie:Movie? = nil {
        didSet {
            if let movie = movie,
                let url = movie.poster_path {
                //let placeholderImage = UIImage(named: "placeholder")!
                title = movie.title

                //let filter = AspectScaledToFillSizeFilter(size: CGSize(width: 100, height: 150))
                imageView.af.setImage(withURL: url, placeholderImage: placeholderImage) //, filter: filter)
            } else {
                title = nil                
            }
            
            
//            if let movie = movie {
//                titleLabel.text = movie.title
//            }
            
        }
    }
    
    var tvShow:TvShow? = nil {
            didSet {
                if let tvShow = tvShow,
                    let url = tvShow.poster_path {
                    //let placeholderImage = UIImage(named: "placeholder")!
                    title = tvShow.name

                    //let filter = AspectScaledToFillSizeFilter(size: CGSize(width: 100, height: 150))
                    imageView.af.setImage(withURL: url, placeholderImage: placeholderImage) //, filter: filter)
                } else {
                    title = nil
                }
                
                
    //            if let movie = movie {
    //                titleLabel.text = movie.title
    //            }
                
            }
        }
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

    func run() {
        
        if let movie = movie,
            let url = movie.poster_path {
            //let placeholderImage = UIImage(named: "placeholder")!
            title = movie.title

            //let filter = AspectScaledToFillSizeFilter(size: CGSize(width: 100, height: 150))
            imageView.af.setImage(withURL: url, placeholderImage: placeholderImage) //, filter: filter)
        } else {
            title = nil
        }
    }
    
}
