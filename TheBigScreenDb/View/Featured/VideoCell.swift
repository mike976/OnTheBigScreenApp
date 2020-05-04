
import UIKit
import AlamofireImage

class VideoCell : UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        
        imageView.af.cancelImageRequest()
        imageView.layer.removeAllAnimations()
        imageView.image = nil
    }
    

    //Action
    @objc func tapDetected() {
        imageTapped?()
    }
    
}
