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
    @IBOutlet weak var titleLabel: UILabel!
    
    var placeholderImage: UIImage?
      
    
    
    var movie:Movie? = nil {
        didSet {
            if let movie = movie,
                let url = movie.poster_path {
                    downloadImage(with: url)
                
                    titleLabel?.text = movie.title
            }
        }
    }
    
    var tvShow:TvShow? = nil {
            didSet {
                if let tvShow = tvShow,
                    let url = tvShow.poster_path {
                    downloadImage(with: url)
                    
                    titleLabel?.text = tvShow.name

                }
            }
        }
    
    func downloadImage(with url: URL) {
     
        imageView.af.setImage(withURL: url, placeholderImage: placeholderImage)
    }
    
    
    
}
