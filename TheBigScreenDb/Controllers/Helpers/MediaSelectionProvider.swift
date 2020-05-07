//
//  MediaSelectionProvider.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 07/05/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation
import RxSwift

class MediaSelectionProvider {
    
    
    static let Instance = MediaSelectionProvider()
    
    private let selectedMediaVariable = Variable(Media(json: ["":""]))
    var selectedMediaObservable: Observable<Media> {
        return self.selectedMediaVariable.asObservable()
    }
    
    var media: Media? {
        didSet {
            if let m = media {
                self.selectedMediaVariable.value = m
            }

        }
    }
    
}
