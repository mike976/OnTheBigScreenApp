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
    
    var movies: [Movie]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    var tvShows: [TvShow]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var defaultToMovies: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
       
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewFlowLayout()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    
    private func setupCollectionViewFlowLayout() {

        if collectionViewLayout == nil {

            let numberOfItemsPerRow: CGFloat = 2
            let lineSpacing: CGFloat = 10
            let interItemSpacing: CGFloat = 5

            let width = (collectionView.frame.width - (numberOfItemsPerRow - 1) * interItemSpacing) / numberOfItemsPerRow

            let height = width

            collectionViewLayout = UICollectionViewFlowLayout()

            collectionViewLayout.itemSize = CGSize(width: width, height: height)

            collectionViewLayout.sectionInset = UIEdgeInsets.zero
            collectionViewLayout.scrollDirection = .vertical
            collectionViewLayout.minimumLineSpacing = lineSpacing
            collectionViewLayout.minimumInteritemSpacing = interItemSpacing

            collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)

        }

    }
    

}




extension MoviesAndTVShowsViewController : UICollectionViewDataSource, UICollectionViewDelegate{
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

         if let movies = self.movies {
            return movies.count
         }
        
        if let tvshows = self.tvShows {
                   return tvshows.count
                }
            
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
        
        let placeholder = UIImage(named: "placeholder")
            
        cell.placeholderImage = placeholder
                
        
        //cell.contentView.layer.cornerRadius = 10.0;
//       cell.contentView.layer.borderWidth = 1.0;
//       cell.contentView.layer.borderColor = UIColor.clear.cgColor;
//       cell.contentView.layer.masksToBounds = true;
//       
//       cell.layer.shadowColor = UIColor.lightGray.cgColor
//       cell.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(2));
//       cell.layer.shadowRadius = 2.0;
//       cell.layer.shadowOpacity = 1.0;
//       cell.layer.masksToBounds = false;
//       cell.contentView.clipsToBounds = true
//       cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath;
        
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

        cell.imageView.image = placeholder
        cell.movie = nil
               
        return cell
    }
    
        
    
    
}
