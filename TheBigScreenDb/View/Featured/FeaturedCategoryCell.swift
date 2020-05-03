//
//  CategoryRow.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 30/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//
import UIKit
import Foundation


class FeaturedCategoryCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryName:String?
    
    
    //Require a public property of movies passed over from FeaturedViewController when dequeuing a tableview cell
    //then we use this to complete code in here
    var movies: [Movie]? = nil {
        didSet {
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.reloadData()
            
        }
    }
    
    var tvShows: [TvShow]? = nil {
           didSet {
               collectionView.backgroundColor = .clear
               collectionView.showsHorizontalScrollIndicator = false
               collectionView.reloadData()
               
           }
       }
       
}

extension FeaturedCategoryCell : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell

        let placeholder = UIImage(named: "placeholder")
        
        cell.placeholderImage = placeholder
    
             
        cell.contentView.layer.cornerRadius = 10.0;
        cell.contentView.layer.borderWidth = 1.0;
        cell.contentView.layer.borderColor = UIColor.clear.cgColor;
        cell.contentView.layer.masksToBounds = true;
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(2));
        cell.layer.shadowRadius = 2.0;
        cell.layer.shadowOpacity = 1.0;
        cell.layer.masksToBounds = false;
        cell.contentView.clipsToBounds = true
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath;

        
        if let movies = self.movies {
                       
            if movies.count > 0 {
                cell.imageView.image = placeholder
                cell.movie = movies[indexPath.row]
                return cell
            } else if let tvShows = self.tvShows {

                if tvShows.count > 0 {
                    cell.imageView.image = placeholder
                    cell.tvShow = tvShows[indexPath.row]
                    return cell
                }
            }
        }
        

        cell.imageView.image = placeholder
        cell.movie = nil
        
        return cell
    }    
}

extension FeaturedCategoryCell : UICollectionViewDelegateFlowLayout {

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let itemsPerRow:CGFloat = 5
//        let hardCodedPadding:CGFloat = 5
//        let itemWidth = (collectionView.frame.width / itemsPerRow) - hardCodedPadding
//        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//
//
//        print("FeaturedCategoryCell \(itemWidth):\(itemHeight)")
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        let itemWidth = itemHeight * 300 / 444
        //print("FeaturedCategoryCell \(itemWidth):\(itemHeight)")
        return CGSize(width: itemWidth, height: itemHeight)


    }        
}
