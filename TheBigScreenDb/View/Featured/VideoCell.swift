
import UIKit
import AlamofireImage
import STRatingControl

class VideoCell : UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    @IBOutlet weak var ratingControl: STRatingControl!
    
    
    var placeholderImage: UIImage?
    
    
    private let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
    
    var imageTapped : (()->())?
    
    var media:Media? = nil {
        didSet {
            
            if let media = media,
                let url = media.poster_path {
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(singleTap)

                downloadImage(with: url)
                
                titleLabel?.text = media.title
                releaseYearLabel?.text = "Year: \(media.release_year)"
                
                if media.media_Type == MediaType.tvShow {
                    mediaTypeLabel?.text = " TV Show "
                    mediaTypeLabel?.backgroundColor = .orange
                } else {
                    mediaTypeLabel?.text = " Movie "
                    mediaTypeLabel?.backgroundColor = .green
                }
                                
                mediaTypeLabel?.layer.cornerRadius = 5
                mediaTypeLabel?.layer.masksToBounds = true
                mediaTypeLabel?.clipsToBounds = true
                mediaTypeLabel?.textColor = .black
                            
                if let voteavg = media.vote_average {
                    let rating = Int(floor(voteavg)) / 2
                    ratingControl?.rating = min(rating, 5)
                }
                            
            }
        }
    }
           
    
    func downloadImage(with url: URL) {
        
        imageView.af.setImage(withURL: url, placeholderImage: placeholderImage, runImageTransitionIfCached: true)
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        imageView.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if imageView != nil {
            imageView.af.cancelImageRequest()
            imageView.layer.removeAllAnimations()
            imageView.image = nil
        }
    }
    

    //Action
    @objc func tapDetected() {
        imageTapped?()
    }
    
}
