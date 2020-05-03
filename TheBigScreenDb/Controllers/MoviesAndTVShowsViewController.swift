//
//  MoviesAndTVShowsCollectionController.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 02/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit

private let reuseIdentifier = "VideoCell"

class MoviesAndTVShowsViewController: UIViewController {

       
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewLayout: UICollectionViewFlowLayout!
    
    var movies: [Movie]? //{
////        didSet {
////            collectionView?.reloadData()
////        }
//    }
    var tvShows: [TvShow]? //{
////        didSet {
////            collectionView?.reloadData()
////        }
//    }
    
    var defaultToMovies: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupCollectionView()
       
        collectionView.reloadData()
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillLayoutSubviews() {
        
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        super.viewWillLayoutSubviews()

//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//
//        let bounds = collectionView.bounds
//
//
//
//        layout.itemSize = CGSize(width: (bounds.width - 20)/2, height: (bounds.height - 5)/4)
        
        //collectionView.reloadData()
        
    }
}




extension MoviesAndTVShowsViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//                if let movies = self.movies {
//                    return movies.count
//                 }
//
//                if let tvshows = self.tvShows {
//                           return tvshows.count
//                  }
//
                return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

         if let movies = self.movies {
            return movies.count
         }

        if let tvshows = self.tvShows {
                   return tvshows.count
                }

        return 1
        
        //return
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
        
        let placeholder = UIImage(named: "placeholder")
            
        cell.placeholderImage = placeholder
        cell.imageView.image = placeholder
        
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
            cell.imageView.image = placeholder
            cell.movie = movies[indexPath.row]
            cell.imageView.layer.cornerRadius = 10.0
            return cell
        } else if let tvshows = self.tvShows {
            cell.imageView.image = placeholder
            cell.tvShow = tvshows[indexPath.row]
            return cell
        }

        
        cell.movie = nil
               
        //cell.layoutIfNeeded()
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let bounds = collectionView.bounds

        return CGSize(width: (floor(bounds.width)-100)/2, height: (floor(bounds.height)-50)/3)

    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //let itemsPerRow:CGFloat = 4
//        let hardCodedPadding:CGFloat = 5
//        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//        let itemWidth = itemHeight * 300 / 444
//        //print("FeaturedCategoryCell \(itemWidth):\(itemHeight)")
//        return CGSize(width: itemWidth, height: itemHeight)
//
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


