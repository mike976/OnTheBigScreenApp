//
//  DetailViewController.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 04/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit
import AlamofireImage


class MyTableViewCell : UITableViewCell {
 
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MediaDetailViewController: UIViewController {
        
    private let castCollectionViewDelegate = CastCollectionViewDelegate()
    private let crewCollectionViewDelegate = CrewCollectionViewDelegate()
    private let trailersCollectionViewDelegate = TrailersCollectionViewDelegate()
    private let productionCollectionViewDelegate = ProductionCollectionViewDelegate()
    
    deinit {
        print("OS reclaiming memory - MediaDetailViewController - no retain cycle/memory leaks here")
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    var media: Media?
    var mediaViewModel: MediaViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let receivedMedia = media {
            print(receivedMedia.title)
            navigationItem.title = receivedMedia.title
        }
        
        self.Initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           self.configureNavBar(hideBar: true)
               
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           self.configureNavBar(hideBar: false)
       }
        

    
    func Initialize() {

        self.navigationController?.navigationBar.backgroundColor = nil
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //set blurred background image
        if let imageUrl = media?.poster_path {

            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect:blurEffect)
            backgroundImageView?.downloadImage(with: imageUrl)
            blurView.frame = backgroundImageView.bounds
            backgroundImageView.alpha = 1.0
            backgroundImageView.addSubview(blurView)
       }
        
        backdropImageView.frame = CGRect(x: 0, y:self.topbarHeight, width: view.frame.width, height: 200)
        backdropImageView.downloadImage(with: (media?.backdrop_path)!)

        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        tableView.reloadData()
        
    }
    
    
    func configureNavBar(hideBar: Bool = false) {
        
        if let navBar = self.navigationController?.navigationBar {

            navBar.setBackgroundImage(nil, for: .default)
            
            if hideBar {
                navBar.setBackgroundImage(UIImage(), for: .default)
            }
        }
    }
}

    //MARK: - TableViewController section
extension MediaDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 8
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        cell.prepareForReuse()
    
        
        cell.textLabel?.text = ""
        cell.textLabel?.textColor = .black
        cell.selectionStyle = UITableViewCell.SelectionStyle.none;
    
        if indexPath.section == 0 {
            
            if let title = media?.title, let releaseYear = media?.release_year {
            
                cell.textLabel?.text = "\(title) (\(releaseYear))"
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                cell.textLabel?.sizeToFit()
            }
            
            for i in cell.contentView.subviews {
                i.removeFromSuperview()
            }
    
        } else if indexPath.section == 1 {
                    
            
            let fullString = NSMutableAttributedString(string: "")
            let imageTextAttachment = NSTextAttachment()
            imageTextAttachment.image = UIImage(named: "Rating_Icon.png")
            let imageString = NSAttributedString(attachment: imageTextAttachment)
            fullString.append(imageString)
            fullString.append(NSAttributedString(string: " \(media?.vote_average! ?? 0)/10"))

            let scoreLabel = UILabel()
            scoreLabel.font = UIFont.boldSystemFont(ofSize: 16)
            scoreLabel.textColor = .yellow
            scoreLabel.text = "Review Score: \(media?.vote_average! ?? 0)/10"
            scoreLabel.textAlignment = .center
            scoreLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)

            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect:blurEffect)
            blurView.frame = backgroundImageView.bounds
            
            for i in cell.contentView.subviews {
                i.removeFromSuperview()
            }
            
            cell.contentView.addSubview(blurView)
            cell.contentView.addSubview(scoreLabel)
            cell.contentView.bringSubviewToFront(scoreLabel)

            cell.sizeToFit()
            
        } else if indexPath.section == 2 {
                        
            if let overviewText = media?.overview {
            
                cell.textLabel?.text = overviewText
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                cell.textLabel?.sizeToFit()
            }
            
            for i in cell.contentView.subviews {
                i.removeFromSuperview()
            }
           

        } else if indexPath.section == 3 {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
            let sv = UICollectionView(frame: CGRect(x: 0, y: 30, width: cell.frame.width, height: 140), collectionViewLayout: layout)
            sv.automaticallyAdjustsScrollIndicatorInsets = true
            sv.contentInsetAdjustmentBehavior = .automatic
            sv.register(MediaDetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell_1")
            sv.backgroundColor = .clear
            
            sv.delegate = self.castCollectionViewDelegate
            sv.dataSource = self.castCollectionViewDelegate
            sv.reloadData()
            

            let sectionLabel = UILabel()
            sectionLabel.text = "CAST"
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            sectionLabel.frame = CGRect(x: 20, y: 0, width: cell.frame.width, height: 20)

            for i in cell.contentView.subviews {
                i.removeFromSuperview()
            }
            
            cell.contentView.addSubview(sectionLabel)
            cell.contentView.addSubview(sv)
            cell.contentView.bringSubviewToFront(sv)
            cell.contentView.bringSubviewToFront(sectionLabel)
            
           if self.castCollectionViewDelegate.mediaCredits == nil {

               if let mc = self.getMediaCreditsAsync() {
                    DispatchQueue.main.async { [weak self] in
                        if self?.castCollectionViewDelegate.mediaCredits == nil {
                            self?.castCollectionViewDelegate.mediaCredits = mc
                            sv.reloadData()
                        }
                   }
                }
            }
            
        } else if indexPath.section == 4 {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
            let sv = UICollectionView(frame: CGRect(x: 0, y: 30, width: cell.frame.width, height: 140), collectionViewLayout: layout)
            sv.automaticallyAdjustsScrollIndicatorInsets = true
            sv.contentInsetAdjustmentBehavior = .automatic
            sv.register(MediaDetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell_2")
            sv.backgroundColor = .clear
            
            sv.delegate = self.crewCollectionViewDelegate
            sv.dataSource = self.crewCollectionViewDelegate
            sv.reloadData()
            
            let sectionLabel = UILabel()
            sectionLabel.text = "CREW"
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            sectionLabel.frame = CGRect(x: 20, y: 0, width: cell.frame.width, height: 20)
            
            for i in cell.contentView.subviews {
                i.removeFromSuperview()
            }
            
            cell.contentView.addSubview(sectionLabel)
            cell.contentView.addSubview(sv)
            cell.contentView.bringSubviewToFront(sv)
            cell.contentView.bringSubviewToFront(sectionLabel)
            
            if self.crewCollectionViewDelegate.mediaCredits == nil {
                if let mc = self.getMediaCreditsAsync() {
                    DispatchQueue.main.async { [weak self] in
                        if self?.crewCollectionViewDelegate.mediaCredits == nil {
                            self?.crewCollectionViewDelegate.mediaCredits = mc
                            sv.reloadData()
                        }
                    }
                }
            }
            
            
            
        } else if indexPath.section == 5 {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
            let sv = UICollectionView(frame: CGRect(x: 0, y: 30, width: cell.frame.width, height: 140), collectionViewLayout: layout)
            sv.automaticallyAdjustsScrollIndicatorInsets = true
            sv.contentInsetAdjustmentBehavior = .automatic
            sv.register(MediaDetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell_3")
            sv.backgroundColor = .clear
            sv.delegate = self.trailersCollectionViewDelegate
            sv.dataSource = self.trailersCollectionViewDelegate
            sv.reloadData()
            
            let sectionLabel = UILabel()
            sectionLabel.text = "TRAILERS"
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            sectionLabel.frame = CGRect(x: 20, y: 0, width: cell.frame.width, height: 20)
            
            for i in cell.contentView.subviews {
                i.removeFromSuperview()
            }
 
            cell.contentView.addSubview(sectionLabel)
            cell.contentView.addSubview(sv)
            cell.contentView.bringSubviewToFront(sv)
            cell.contentView.bringSubviewToFront(sectionLabel)
            
            if self.trailersCollectionViewDelegate.mediaDetail == nil {
                if let mc = self.getMediaDetailAsync() {
                    DispatchQueue.main.async { [weak self] in
                        if self?.trailersCollectionViewDelegate.mediaDetail == nil {
                            self?.trailersCollectionViewDelegate.mediaDetail = mc
                            sv.reloadData()
                        }
                    }
                }
            }
            
            
            
        } else if indexPath.section == 6 {

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            
            let sv = UICollectionView(frame: CGRect(x: 0, y: 30, width: cell.frame.width, height: 140), collectionViewLayout: layout)
            sv.automaticallyAdjustsScrollIndicatorInsets = true
            sv.contentInsetAdjustmentBehavior = .automatic
            sv.register(MediaDetailCollectionViewCell.self, forCellWithReuseIdentifier: "cell_4")
            sv.backgroundColor = .clear
            sv.delegate = self.productionCollectionViewDelegate
            sv.dataSource = self.productionCollectionViewDelegate
            sv.reloadData()
            
            let sectionLabel = UILabel()
            sectionLabel.text = "PRODUCERS"
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            sectionLabel.frame = CGRect(x: 20, y: 0, width: cell.frame.width, height: 20)
            
            for i in cell.contentView.subviews {
                i.removeFromSuperview()
            }

            cell.contentView.addSubview(sectionLabel)
            cell.contentView.addSubview(sv)
            cell.contentView.bringSubviewToFront(sv)
            cell.contentView.bringSubviewToFront(sectionLabel)
            
            if self.productionCollectionViewDelegate.mediaDetail == nil {
                if let md = self.getMediaDetailAsync() {
                   DispatchQueue.main.async { [weak self] in
                        if self?.productionCollectionViewDelegate.mediaDetail == nil {
                            self?.productionCollectionViewDelegate.mediaDetail = md
                            sv.reloadData()
                        }
                   }
                }
            }
                        
        }  else if indexPath.section == 7 {
            
            //TODO revisit - fix to resolve cell repeating issue
            for i in cell.contentView.subviews {
                i.removeFromSuperview()
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
       return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                
        if indexPath.section == 1 {
            
            return 25
        }
               
        if indexPath.section > 2 {
            return 170
        }
              
        
        return tableView.rowHeight
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let y = -scrollView.contentOffset.y


        //hides the image so if does not appear in the nav bar when user scrolls up
        var height = y
        if floor(height) < 0 {
            height = 0
        }

        backdropImageView?.frame = CGRect(x: 0, y: self.topbarHeight, width: view.frame.width, height: height)
      }
    
    
    
    
}

//MARK: - functions to retrieve media data
extension MediaDetailViewController {
    
    func getMediaCreditsAsync(_ page: Int = 1) -> MediaCredits? {

        var mediaCredits: MediaCredits? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async { [weak self] in
                if let media_Id = self?.media?.id {
                    var mediaType = self?.media?.media_Type!
                    var mediaEndPoint = MediaEndpoint.movie
                    if mediaType == MediaType.tvShow {
                        mediaType = MediaType.tvShow
                        mediaEndPoint = MediaEndpoint.tvShow
                    }
                
                    mediaCredits = self?.mediaViewModel.getMediaCreditsAsync(path: mediaEndPoint, mediaType: mediaType!, mediaId: media_Id)
                    
                    semaphore.signal()
                }
            }
        
        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
        return mediaCredits
    }
    
    func getMediaDetailAsync(_ page: Int = 1) -> MediaDetail? {

        var mediaDetail: MediaDetail? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async { [weak self] in
                if let media_Id = self?.media?.id {
                    var mediaType = self?.media?.media_Type!
                    var mediaEndPoint = MediaEndpoint.movie
                    if mediaType == MediaType.tvShow {
                        mediaType = MediaType.tvShow
                        mediaEndPoint = MediaEndpoint.tvShow
                    }
                
                    mediaDetail = self?.mediaViewModel.getMediaDetailAsync(path: mediaEndPoint, mediaType: mediaType!, mediaId: media_Id)
                    
                    semaphore.signal()
                }
            }
        
        let timeoutInSecs = Double(5)
        _ = semaphore.wait(timeout: .now() + timeoutInSecs)
        return mediaDetail
    }
}



//MARK: - collectionView delegate responsible for providing a collection of the media's cast
class CastCollectionViewDelegate : NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var mediaCredits: MediaCredits?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mediaCredits?.cast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 1
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_1", for: indexPath) as! MediaDetailCollectionViewCell
        cell.prepareForReuse()
        cell.backgroundColor = .clear

        let placeholderImage = UIImage(named: "placeholder")?.setAlpha(alpha: 0.5)
        
        if let imageUrl = mediaCredits?.cast?[indexPath.section].imageUrl {
            cell.imageView?.af.setImage(withURL: imageUrl, placeholderImage: placeholderImage, runImageTransitionIfCached: true)
            cell.imageView?.layer.cornerRadius = cell.imageView.frame.width/2
            cell.imageView?.layer.masksToBounds = false;
            cell.imageView?.clipsToBounds = true
        }
                
        if let name = mediaCredits?.cast?[indexPath.section].name {
            
            if let character = mediaCredits?.cast?[indexPath.section].character {
                cell.titleLabel?.text = "\(name)\nas \(character)"
            }
        }
        
        return cell
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       return CGSize(width: 140, height: 140)
    }
}

//MARK: - collectionView delegate responsible for providing a collection of the media's crew
class CrewCollectionViewDelegate : NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var mediaCredits: MediaCredits?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mediaCredits?.crew?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 1
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_2", for: indexPath) as! MediaDetailCollectionViewCell
        cell.prepareForReuse()
        
        
        cell.backgroundColor = .clear

        let placeholderImage = UIImage(named: "placeholder")?.setAlpha(alpha: 0.5)
        
        if let imageUrl = mediaCredits?.crew?[indexPath.section].imageUrl {
            cell.imageView?.af.setImage(withURL: imageUrl, placeholderImage: placeholderImage, runImageTransitionIfCached: true)
            cell.imageView?.layer.cornerRadius = cell.imageView.frame.width/2
            cell.imageView?.layer.masksToBounds = false;
            cell.imageView?.clipsToBounds = true
        }
        
        if let name = mediaCredits?.crew?[indexPath.section].name {
            
            if let job = mediaCredits?.crew?[indexPath.section].job {
                cell.titleLabel?.text = "\(name)\n \(job)"
            }
        }
        
        return cell
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       return CGSize(width: 140, height: 140)
    }
}


//MARK: - collectionView delegate responsible for providing a collection of the media trailers
class TrailersCollectionViewDelegate : NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var mediaDetail: MediaDetail?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mediaDetail?.trailers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 1
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_3", for: indexPath) as! MediaDetailCollectionViewCell
        cell.prepareForReuse()
        cell.backgroundColor = .clear

        let placeholderImage = UIImage(named: "placeholder")?.setAlpha(alpha: 0.5)
        
        
        if let imageUrl = mediaDetail?.trailers?[indexPath.section].youtubeThumbnailUrl {
            cell.imageView?.af.setImage(withURL: imageUrl, placeholderImage: placeholderImage, runImageTransitionIfCached: true)

            let trailerTapGesture = TrailerTapGestureRecognizer(target: self, action: #selector(self.playTrailer))
            trailerTapGesture.trailerUrl = mediaDetail?.trailers?[indexPath.section].youtubeUrl
            cell.addGestureRecognizer(trailerTapGesture)

        }
        
        return cell
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       return CGSize(width: 140, height: 140)
    }
        
    @objc func playTrailer(_ sender : TrailerTapGestureRecognizer) {

        guard let url = sender.trailerUrl else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    class TrailerTapGestureRecognizer: UITapGestureRecognizer {
        var trailerUrl: URL?
    }
}


//MARK: - collectionView delegate responsible for providing a collection of the media production studios
class ProductionCollectionViewDelegate : NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var mediaDetail: MediaDetail?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mediaDetail?.productionCompanies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 1
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_4", for: indexPath) as! MediaDetailCollectionViewCell
        cell.prepareForReuse()
        cell.backgroundColor = .clear

        let placeholderImage = UIImage(named: "placeholder")?.setAlpha(alpha: 0.5)

        if let imageUrl = mediaDetail?.productionCompanies?[indexPath.section].logoPath {
            cell.imageView?.af.setImage(withURL: imageUrl, placeholderImage: placeholderImage, runImageTransitionIfCached: true)
            cell.imageView.contentMode = .scaleAspectFit
        }
        
        if let name = mediaDetail?.productionCompanies?[indexPath.section].name {
            cell.titleLabel?.text = "\(name)"
        }
        
        return cell
    }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
       return CGSize(width: 140, height: 140)
    }
}

//MARK: - View Cell to display the Crew, Cast and Videos
class MediaDetailCollectionViewCell: UICollectionViewCell {

    var titleLabel: UILabel!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                        
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(x: (contentView.frame.width/2)-40 , y: 0, width: 80, height: 80)
        self.imageView.contentMode = .scaleAspectFill

        contentView.addSubview(imageView)
        contentView.bringSubviewToFront(imageView)
        
        self.titleLabel = UILabel(frame: CGRect(x: (contentView.frame.width/2)-60, y: 70, width: 120, height: 50))
        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.init(name: "Helvetica", size: 10)
        self.titleLabel.textAlignment = .center
        self.titleLabel.lineBreakMode = .byWordWrapping
        self.titleLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)
        contentView.bringSubviewToFront(titleLabel)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if imageView != nil {
            imageView.af.cancelImageRequest()
            imageView.layer.removeAllAnimations()
            imageView.image = nil
        }
        
        if titleLabel != nil {
            titleLabel.text = ""
        }
    }
}
