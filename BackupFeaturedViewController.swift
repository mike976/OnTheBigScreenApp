//
//  BackupFeaturedViewController.swift
//  TheBigScreenDb
//
//  Created by Michael Bullock on 29/04/2020.
//  Copyright © 2020 Michael Bullock. All rights reserved.
//

import Foundation
import UIKit

//This class is a backup which demonstrates tableview with pagination

class BackupFeaturedViewController: UIViewController {
    
    deinit {
        print("OS reclaiming memory - FeaturedViewController - no retain cycle/memory leaks here")
    }
    
    //MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerCollectionVIew = collectionViews.collectionViewOne()
    @IBOutlet weak var headerPageControl: UIPageControl!

    
    private var nextPage = 2
    private var nowPlayingMovies = [Movie]()

    
    //MARK: - Featured Header properties
    private let tableHeaderHeight: CGFloat = 200.0
    private var tableHeaderCutAway: CGFloat = 30.0
    private var headerPageView: UIPageControl!
    private var headerView: FeaturedHeaderView!
    private var headerMaskLayer: CAShapeLayer!
    var timer = Timer()
    var counter = 0
    
    
    
    //MARK: - ViewModels
    var featuredViewModel: FeaturedViewModel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
            
        configureTableViewHeader()
        updateHeaderView()
        
        self.Initialize()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }
    
    private func Initialize() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getMoviesNowPlaying()
    }
    
    
    //MARK: - Header functions
    private func configureTableViewHeader() {

        headerView = tableView.tableHeaderView as! FeaturedHeaderView
        headerView.backgroundColor = .white
        
        headerCollectionVIew?.delegate = self
        headerCollectionVIew?.dataSource = self
        headerCollectionVIew?.backgroundColor = .white
        
        headerView.collectionView = headerCollectionVIew
        headerView.collectionView.decelerationRate = .normal
        
        headerPageView = headerPageControl
        headerPageView.numberOfPages = 5
        headerPageView.currentPage = 0
        headerView.pageControl = headerPageView
        
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.white.cgColor
        headerView.layer.mask = headerMaskLayer
        

        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeFeaturedHeaderImage), userInfo: nil, repeats: true)
        }
        
    }
    
    private func updateHeaderView() {
        
        let effectiveHeight = tableHeaderHeight - tableHeaderCutAway / 2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: headerView.collectionView.bounds.width, height: tableHeaderHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableHeaderCutAway/2
        }
        
        headerView.frame = headerRect
        
        //cut away
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height - tableHeaderCutAway))
        headerMaskLayer?.path = path.cgPath
        
    }
    
    @objc func changeFeaturedHeaderImage() {
    
        if counter < featuredViewModel.featuredHeaderImages.count {
            let index = IndexPath.init(item: counter, section: 0)
            headerView.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            headerView.pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            headerView.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            headerView.pageControl.currentPage = counter
            counter = 1
        }
    }
    
    //MARK: - Movies functions
    
    private func getMoviesNowPlaying(page : Int = 1){
        self.featuredViewModel.getNowPlayingMovies(page: page)  { [weak self] (movies, response) in
            if !response.isError{
                
                if movies.count < 20{
                    self?.stopPagination()
                }
                
                self?.nowPlayingMovies = self!.mergeMovies(currentMovies: self!.nowPlayingMovies, newMovies: movies, page: page)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func mergeMovies(currentMovies : [Movie], newMovies : [Movie], page : Int) -> [Movie]{
        if page == 1{
            return newMovies
        }else{
            return currentMovies + newMovies
        }
    }
    
    private func stopPagination(){
        nextPage = -1
    }
    
}


//MARK: - TableViewController section
extension BackupFeaturedViewController : UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCell", for: indexPath)
        
        let movie = self.nowPlayingMovies[indexPath.row]
        cell.textLabel!.text = movie.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if nextPage == -1{
            return
        }

        if indexPath.row == nowPlayingMovies.count - 1{
            getMoviesNowPlaying(page: nextPage)
            nextPage += 1
        }
    }
}

extension BackupFeaturedViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
}

//MARK: - CollectionController section
extension BackupFeaturedViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {

        if collectionView == collectionViews.collectionViewOne() {
            return featuredViewModel.featuredHeaderImages.count
           } else {
                return 1
            }
       }

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return 5
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //check for cell type for the other movie collections
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredHeaderCell", for: indexPath)
        
        
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = featuredViewModel.featuredHeaderImages[indexPath.row]
        }
        
        
        return cell
       }
}
