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
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.reloadData()
            
        }
    }
    
    var tvShows: [TvShow]? = nil {
           didSet {
               collectionView.showsHorizontalScrollIndicator = false
               collectionView.reloadData()
               
           }
       }
       
}

extension FeaturedCategoryCell : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell

        let placeholder = UIImage(named: "placeholder")
        
        if let movies = self.movies {
                       
            if movies.count > 0 {
                                
                if indexPath.row == 6 - 1 {
                                        
                    //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                    let viewAllImage = UIImage(named: "viewAll")
                    cell.movie = nil
                    cell.imageView.image = viewAllImage
                    cell.placeholderImage = viewAllImage
                    
                    return cell
                    
                    //set tap gesture to cell that segues to new movies colleciton page passing self movies as viewcontroller depenency injection
                    
                } else {
                
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                    
                    cell.imageView.image = placeholder
                    cell.placeholderImage = placeholder
                    cell.movie = movies[indexPath.row]
                    cell.addGestureRecognizer(tapGestureRecognizer)
                    
                    //set tap gesture to cell that segues to new movie detail page
                    
                    return cell
                }
            } else if let tvShows = self.tvShows {

                if tvShows.count > 0 {
                    
                    if indexPath.row == 6 - 1 {
                                            
                        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                        let viewAllImage = UIImage(named: "viewAll")
                        cell.movie = nil
                        cell.imageView.image = viewAllImage
                        cell.placeholderImage = viewAllImage
                        
                        return cell
                        
                        //set tap gesture to cell that segues to new movies colleciton page passing self movies as viewcontroller depenency injection
                        
                    } else {
                    
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                        
                        cell.imageView.image = placeholder
                        cell.placeholderImage = placeholder
                        cell.tvShow = tvShows[indexPath.row]
                        cell.addGestureRecognizer(tapGestureRecognizer)
                        
                        //set tap gesture to cell that segues to new movie detail page
                        
                        return cell
                    }
                }
            }
        }
        

        cell.imageView.image = placeholder
        cell.movie = nil
        
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let videoCell = tapGestureRecognizer.view as! VideoCell

        if let title = videoCell.title {
            // Your action
            print(title)
        }
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
