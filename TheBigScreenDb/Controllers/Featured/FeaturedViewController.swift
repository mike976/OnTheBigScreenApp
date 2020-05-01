

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
    var moviesViewModel: MoviesViewModel!
    var tvShowsViewModel: TvShowsViewModel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Initialize()
    }
        

    private func Initialize() {
        
       tableView.dataSource = self
       tableView.delegate = self
        
       changeFeaturedHeaderImage()
       view.bringSubviewToFront(featuredHeaderPoster)
          
       featuredHeaderPoster.frame = CGRect(x: 0, y:0, width: view.frame.width, height: 300)
       
       tableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
       tableView.estimatedRowHeight = 300
       tableView.rowHeight = 200
       tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
       getMoviesNowPlayingAsync()
       getUpcomingMoviesAsync()
       getTrendingMoviesAsync()
       getTrendingTvShowsAsync()
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeFeaturedHeaderImage), userInfo: nil, repeats: true)
        
        
    }
    
    
    @objc func changeFeaturedHeaderImage() {

        selectedPosterIndex = selectedPosterIndex + 1
        
        if selectedPosterIndex > moviesViewModel.featuredHeaderImages.count-1 {
            selectedPosterIndex = 0
        }
        
        DispatchQueue.main.async {
            self.featuredHeaderPoster.image = self.moviesViewModel.featuredHeaderImages[self.selectedPosterIndex]
        }
    }
    
    //MARK: - Movies functions
    
    private func getMoviesNowPlayingAsync(page : Int = 1){
        if let nowplayingMovies = self.moviesViewModel.getMoviesAsync(page: page, endpoint: MovieEndPoint.nowplaying_movies) {
            self.nowPlayingMovies = nowplayingMovies
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    private func getUpcomingMoviesAsync(page : Int = 1){
        if let upComingMovies = self.moviesViewModel.getMoviesAsync(page: page, endpoint: MovieEndPoint.upcoming_movies) {
            self.upComingMovies = upComingMovies
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    private func getTrendingMoviesAsync(page : Int = 1){

        if let trendingMovies = self.moviesViewModel.getMoviesAsync(page: page, endpoint: MovieEndPoint.trending_movies) {
            self.trendingMovies = trendingMovies
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }        
    }
    
    private func getTrendingTvShowsAsync(page : Int = 1){

        if let trendingTvShows = self.tvShowsViewModel.getTvShowsAsync(page: page, endpoint: TvShowEndPont.trending_tvshows) {
            self.trendingTvShows = trendingTvShows
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
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

        let height = max(y, 300)

        featuredHeaderPoster?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
}
