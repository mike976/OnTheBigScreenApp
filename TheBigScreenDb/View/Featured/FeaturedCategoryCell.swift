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
            collectionView.reloadData()
            
        }
    }
    
}

extension FeaturedCategoryCell : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedVideoCell", for: indexPath) as! FeaturedVideoCell
        if let movies = self.movies {
            if movies.count > 0 {
                cell.movie = movies[indexPath.row]
            } else {
                cell.movie = nil
            }
        } else {
            cell.movie = nil
            
        }
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
