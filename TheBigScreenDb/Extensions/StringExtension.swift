//
//  StringExtension.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 29/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation

extension String{
    
    func formatedDate() -> String{
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return ""}
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}
