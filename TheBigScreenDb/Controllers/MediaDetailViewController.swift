//
//  DetailViewController.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 04/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController {
        
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
           return 6
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        if indexPath.section == 0 {
            //show title
            cell.textLabel?.text = "\(media?.title ?? "") (\(media?.release_year ?? ""))"
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)

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
            
            let scoreImageView = UIImageView()
            scoreImageView.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
            scoreImageView.backgroundColor = .darkGray
            
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect:blurEffect)
            blurView.frame = backgroundImageView.bounds
            scoreImageView.alpha = 1.0
            scoreImageView.tintColor = .gray
            scoreImageView.addSubview(blurView)

    
            cell.contentView.addSubview(blurView)
            cell.contentView.addSubview(scoreLabel)
            cell.contentView.bringSubviewToFront(scoreLabel)
            
            cell.sizeToFit()
            
        } else if indexPath.section == 2 {
            cell.textLabel?.text = media?.overview
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        } else if indexPath.section == 3 {
            cell.textLabel?.text = "Cast collection View"
            
            
            
        } else if indexPath.section == 4 {
            cell.textLabel?.text = "Crew Collection View"
        } else if indexPath.section == 5 {
            cell.textLabel?.text = "Videos Collection View"
        }
        
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        var textLabel = ""
        switch section {
        case 3:
            textLabel = "CAST"
            break
        case 4:
            textLabel = "CREW"
            break
        case 5:
            textLabel = "VIDEOS"
            break
        default:
            textLabel = ""
            break
        }
        
        if section > 2 {
                        
            let frame = tableView.frame
            let label = UILabel()
            label.frame = CGRect.init(x: 10, y: 13, width: 200, height: 21)
            label.text = textLabel
    //        label.textColor = .lightGray
            label.font =  UIFont.boldSystemFont(ofSize: 16.0)
        
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            headerView.addSubview(label)

            return headerView
            
        }

        
        return tableView.headerView(forSection: section)
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section < 3 {
            return 0
        } else {
            return tableView.sectionHeaderHeight
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 1 {
            
            return 25
        }
        
        return tableView.rowHeight
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let y = -scrollView.contentOffset.y

        let height = y //max((y - self.topbarHeight) , 200)

        backdropImageView?.frame = CGRect(x: 0, y: self.topbarHeight, width: view.frame.width, height: height)
      }
    
}
    
//    typealias GetMediaListHandler = (Int) -> Void
//    func runOnBackgroundThread(page: Int, _ getMediaList: @escaping GetMediaListHandler) {
//
//           let dispatchQueue = DispatchQueue.global(qos: .background)
//
//           dispatchQueue.async {
//
//               getMediaList(page)
//           }
//    }
//
//    private func getMediaDetailAsync(_ page : Int = 1){
//
//        let media_Id = self.media?.id
//
//        var mediaType = MediaType.movie
//        var mediaEndPoint = MediaEndpoint.movie
//        if media?.media_Type! == MediaType.tvShow {
//            mediaType = MediaType.tvShow
//            mediaEndPoint = MediaEndpoint.tvShow
//        }
//
//        if let mediaDetail = mediaViewModel.getMediaDetailAsync(path: mediaEndPoint, mediaType: mediaType, mediaId: media_Id) {
//
//            DispatchQueue.main.async {
//
//                if mediaDetail.productionCompanies != nil {
//                    for pc in mediaDetail.productionCompanies! {
//                        print(pc.name + ":" + pc.logoPath!.absoluteString )
//                    }
//                }
//
//                if mediaDetail.trailers != nil {
//                    for tr in mediaDetail.trailers! {
//                        print(tr.url!.absoluteString)
//                    }
//                }
//            }
//        }
//
//        if let mediaCredits = mediaViewModel.getMediaCreditsAsync(path: mediaEndPoint, mediaType: mediaType, mediaId: media_Id) {
//
//            DispatchQueue.main.async {
//
//                if mediaCredits.cast != nil {
//                    for cast in mediaCredits.cast! {
//                        print(cast.name + " : " + cast.character + " : " + cast.imageUrl!.absoluteString)
//                    }
//
//                }
//
//               if mediaCredits.crew != nil {
//                    for crew in mediaCredits.crew! {
//                        print(crew.name + " : " + crew.job + " : " + crew.imageUrl!.absoluteString)
//                    }
//
//                }
//
//            }
//        }
//    }

