

import UIKit


class FeaturedViewController: UIViewController {
    
    deinit {
        print("OS reclaiming memory - FeaturedViewController - no retain cycle/memory leaks here")
    }
    
    //MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var featuredHeaderPoster: UIImageView!
    
    private var nowPlayingMovies = [Movie]()
    private var upComingMovies = [Movie]()
    private var trendingMovies = [Movie]()
    
    private var trendingTvShows = [TvShow]()

    
    //MARK: - Featured Header properties
    var timer = Timer()
    var counter = 0
    var selectedPosterIndex = -1
    
    var categories = ["Now Playing", "Coming Soon", "Trending Movies", "Trending TV Shows"]
    
    
    //MARK: - ViewModels
    var moviesViewModel: MoviesViewModelProtocol!
    var tvShowsViewModel: TvShowsViewModelProtocol!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Initialize()
    }
        
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadMoviesAndTvShows()
//    }

    private func Initialize() {
       
       loadMoviesAndTvShows()
        
       tableView.dataSource = self
       tableView.delegate = self
        
       changeFeaturedHeaderImage()
       view.bringSubviewToFront(featuredHeaderPoster)
          
       featuredHeaderPoster.frame = CGRect(x: 0, y:0, width: view.frame.width, height: 200)
       
       tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
       tableView.estimatedRowHeight = 300
       tableView.rowHeight = 200
       tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
       self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeFeaturedHeaderImage), userInfo: nil, repeats: true)
        
    }
    
    func loadMoviesAndTvShows() {
                           
        self.runOnBackgroundThread(page: 1, { page in
            self.getMoviesNowPlayingAsync(page)
        })

        self.runOnBackgroundThread(page: 1, { page in
            self.getUpcomingMoviesAsync(page)
        })

        self.runOnBackgroundThread(page: 1, { page in
            self.getTrendingMoviesAsync(page)
        })
        
        self.runOnBackgroundThread(page: 1, { page in
            self.getTrendingTvShowsAsync(page)
        })
    }
    
    
    @objc func changeFeaturedHeaderImage() {

        selectedPosterIndex = selectedPosterIndex + 1
        
        if selectedPosterIndex > moviesViewModel.featuredHeaderImages.count-1 {
            selectedPosterIndex = 0
        }
        
        DispatchQueue.main.async {
            
            let imageName = self.moviesViewModel.featuredHeaderImages[self.selectedPosterIndex]
            self.featuredHeaderPoster.image = UIImage(named: imageName)
        }
    }
    
    //MARK: - Movies functions
    
    private func getMoviesNowPlayingAsync(_ page : Int = 1){
        
        
        if let nowplayingMovies = self.moviesViewModel.getMoviesAsync(page: page, endpoint: MovieEndPoint.nowplaying_movies) {
            self.nowPlayingMovies = nowplayingMovies
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    private func getUpcomingMoviesAsync(_ page : Int = 1){
        if let upComingMovies = self.moviesViewModel.getMoviesAsync(page: page, endpoint: MovieEndPoint.upcoming_movies) {
            self.upComingMovies = upComingMovies
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    private func getTrendingMoviesAsync(_ page : Int = 1){

        if let trendingMovies = self.moviesViewModel.getMoviesAsync(page: page, endpoint: MovieEndPoint.trending_movies) {
            self.trendingMovies = trendingMovies
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }        
    }
    
    private func getTrendingTvShowsAsync(_ page : Int = 1){

        if let trendingTvShows = self.tvShowsViewModel.getTvShowsAsync(page: page, endpoint: TvShowEndPont.trending_tvshows) {
            self.trendingTvShows = trendingTvShows
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    typealias GetMoviesAndTvShowssHandler = (Int) -> Void
    func runOnBackgroundThread(page: Int, _ getMoviesAnTvShows: @escaping GetMoviesAndTvShowssHandler) {
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {
            
            getMoviesAnTvShows(page)
        }
    }
}


//MARK: - TableViewController section
extension FeaturedViewController : UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCategoryCell", for: indexPath) as! FeaturedCategoryCell
       
        cell.movies = [Movie]()
        cell.tvShows = [TvShow]()
        
        //print("\(categories[indexPath.section])")
        
        if indexPath.section == 0 {
            cell.categoryName = categories[indexPath.section]
             cell.movies = self.nowPlayingMovies
        } else if indexPath.section == 1 {
            cell.categoryName = categories[indexPath.section]
             cell.movies = self.upComingMovies
        } else if indexPath.section == 2 {
            cell.categoryName = categories[indexPath.section]
            cell.movies = self.trendingMovies
        } else if indexPath.section == 3 {
            cell.categoryName = categories[indexPath.section]
            cell.tvShows = self.trendingTvShows
        }
        

       return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y

        let height = max(y, 200)

        featuredHeaderPoster?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        
        
        let button = UIButton(frame: CGRect(x: frame.width-80, y: 13, width: 90, height: 15))
        button.tag = section
        button.setTitle("View All", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: CGFloat(12))
        button.addTarget(self,action:#selector(buttonClicked),for:.touchUpInside)

        button.tag = section //important we tag the section clicked and so we can seque to correct page using this
    
                
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 13, width: 200, height: 17)
        label.text = categories[section]
        label.textColor = .lightGray
        label.font =  UIFont.boldSystemFont(ofSize: 16.0)
        

        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        headerView.addSubview(button)
        headerView.addSubview(label)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
        
    @objc func buttonClicked(sender: UIButton) {
        print("button click\(sender.tag)")
    }
}