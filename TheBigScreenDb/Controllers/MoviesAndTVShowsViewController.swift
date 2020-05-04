
import UIKit

private let reuseIdentifier = "VideoCell"

class MoviesAndTVShowsViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewLayout: UICollectionViewFlowLayout!
    
    var selectedCategoryName: String!
    var movies: [Movie]?
    var tvShows: [TvShow]?    
    var defaultToMovies: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        if let categoryName = selectedCategoryName {
            navigationItem.title = categoryName
        }
        
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillLayoutSubviews() {

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.viewWillLayoutSubviews()

    }
}


extension MoviesAndTVShowsViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
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
        
        cell.imageView.frame = cell.frame
        
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
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200/2, height: (300/2))
        
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


extension UIImage {
    func getCropRation() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
        
    }
}
