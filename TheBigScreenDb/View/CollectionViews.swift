//
//  CollectionViews.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 29/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import UIKit
import Foundation

class collectionViews {

    static func collectionViewOne() -> UICollectionView {

        let layout = UICollectionViewFlowLayout()
        let collectionViewOne = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100), collectionViewLayout: layout)
        return collectionViewOne

    }

//    static func collectionViewTwo() -> UICollectionView {
//
//        let layout = UICollectionViewFlowLayout()
//        let collectionViewTwo = UICollectionView(frame: CGRect(x: 0, y: 300, width: 200, height: 100), collectionViewLayout: layout)
//        return collectionViewTwo
//
//    }


}


//import UIKit
//
//class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
//
//
//let collectionViewOne = collectionViews.collectionViewOne()
//let collectionViewTwo = collectionViews.collectionViewTwo()
//
//var myArray = ["1", "2"]
//var myArray2 = ["3", "4"]
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//
//
//    collectionViewOne.delegate = self
//    collectionViewOne.dataSource = self
//    collectionViewOne.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
//    view.addSubview(collectionViewOne)
//
//
//    collectionViewTwo.delegate = self
//    collectionViewTwo.dataSource = self
//    collectionViewTwo.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell2")
//    view.addSubview(collectionViewTwo)
//
//}
//
//func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    if collectionView == self.collectionViewOne {
//        return myArray.count
//    } else {
//        return myArray2.count
//    }
//
//}
//
//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    if collectionView == self.collectionViewOne {
//        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath)
//
//        myCell.backgroundColor = UIColor.red
//
//        return myCell
//
//    } else {
//
//        let myCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell2", for: indexPath as IndexPath)
//
//        myCell2.backgroundColor = UIColor.blue
//
//        return myCell2
//    }
//
//}
//
//
//}
