//
//  DetailViewController.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 04/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var name: String?
    
    var media: Media?
    
    var mediaViewModel: MediaViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let receivedMedia = media {
            print(receivedMedia.title)
            titleLabel?.text = receivedMedia.title
            navigationItem.title = receivedMedia.title
        }
        
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        self.runOnBackgroundThread(page: 1, { page in
            self.getMediaDetailAsync(page)
        })
        
        //get credits api
        
    }
    
    typealias GetMediaListHandler = (Int) -> Void
    func runOnBackgroundThread(page: Int, _ getMediaList: @escaping GetMediaListHandler) {
           
           let dispatchQueue = DispatchQueue.global(qos: .background)
           
           dispatchQueue.async {
               
               getMediaList(page)
           }
    }
    
    private func getMediaDetailAsync(_ page : Int = 1){
        
        let media_Id = self.media?.id

        var mediaType = MediaType.movie
        var mediaEndPoint = MediaEndpoint.movie
        if media?.media_Type! == MediaType.tvShow {
            mediaType = MediaType.tvShow
            mediaEndPoint = MediaEndpoint.tvShow
        }
        
//        if let mediaDetail = mediaViewModel.getMediaDetailAsync(path: mediaEndPoint, mediaType: mediaType, mediaId: media_Id) {
//
//            DispatchQueue.main.async {
//                print(mediaDetail)
//
//                if mediaDetail.productionCompanies != nil {
//                    for pc in mediaDetail.productionCompanies! {
//                        print(pc.name + ":" + pc.logoPath!.absoluteString)
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
        
        if let mediaCredits = mediaViewModel.getMediaCreditsAsync(path: mediaEndPoint, mediaType: mediaType, mediaId: media_Id) {
            
            DispatchQueue.main.async {
                print(mediaCredits)
              
//                if mediaDetail.productionCompanies != nil {
//                    for pc in mediaDetail.productionCompanies! {
//                        print(pc.name + ":" + pc.logoPath!.absoluteString)
//                    }
//                }
//
//                if mediaDetail.trailers != nil {
//                    for tr in mediaDetail.trailers! {
//                        print(tr.url!.absoluteString)
//                    }
//                }
            }
        }
    }
}
