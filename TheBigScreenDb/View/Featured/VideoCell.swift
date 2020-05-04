
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

        var label = UILabel()
        
        label.text = "Michael Bullock (1976)"
        label.font = UIFont.init(name: "Helvetica", size: CGFloat(10))
        label.textAlignment = .center
        
        imageView.addSubview(label)
        imageView.bringSubviewToFront(label)
        
//        imageView.af.setImage(withURL: url, placeholderImage: placeholderImage, runImageTransitionIfCached: true, { (response) in
            
            
  //          }
        
        imageView.af.setImage(withURL: url, placeholderImage: placeholderImage, runImageTransitionIfCached: true) { (response) in
            
            if response.error != nil {
                print(response.error)
            }
        }
                
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        imageView.sizeToFit()
    }
    
    
    
}
