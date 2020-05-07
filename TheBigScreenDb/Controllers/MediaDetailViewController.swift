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

}
