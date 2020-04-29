

import UIKit

class FeaturedViewController: UIViewController {
    
    deinit {
        print("OS reclaiming memory - FeaturedViewController - no retain cycle/memory leaks here")
    }
    
    @IBOutlet weak var tableView: UITableView!

    private var nextPage = 2
    private var nowPlayingMovies = [Movie]()

    
    private let tableHeaderHeight: CGFloat = 250.0
    private var tableHeaderCutAway: CGFloat = 50.0
    private var headerView: FeaturedHeaderView!
    private var headerMaskLayer: CAShapeLayer!
     
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
    
    func configureTableViewHeader() {

        headerView = tableView.tableHeaderView as! FeaturedHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = headerMaskLayer
        
    }
    
    func updateHeaderView() {
        
        let effectiveHeight = tableHeaderHeight - tableHeaderCutAway / 2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        
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
    
    var featuredViewModel: FeaturedViewModel!
    
    private func Initialize() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getMoviesNowPlaying()
    }
    
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


extension FeaturedViewController : UITableViewDataSource, UITableViewDelegate {
   
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

extension FeaturedViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
}
