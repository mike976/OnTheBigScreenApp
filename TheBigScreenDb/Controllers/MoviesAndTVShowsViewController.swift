
import UIKit

private let reuseIdentifier = "VideoCell"

class MoviesAndTVShowsViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewLayout: UICollectionViewFlowLayout!
    
    var selectedCategoryIndex: Int!
    var categories: [String]!
    var movies: [Movie]?
    var tvShows: [TvShow]?    
    var defaultToMovies: Bool = true
    
    //MARK: - ViewModels
    var moviesViewModel: MoviesViewModelProtocol!
    var tvShowsViewModel: TvShowsViewModelProtocol!
    
    private var nextPage = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        if let _ = selectedCategoryIndex,
            let categories = categories {
            navigationItem.title = categories[selectedCategoryIndex]
        }
        
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillLayoutSubviews() {

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        super.viewWillLayoutSubviews()

    }
    
    typealias GetMoviesAndTvShowssHandler = (Int) -> Void
    func runOnBackgroundThread(page: Int, _ getMoviesAnTvShows: @escaping GetMoviesAndTvShowssHandler) {
       
       let dispatchQueue = DispatchQueue.global(qos: .background)
       
       dispatchQueue.async {
           
           getMoviesAnTvShows(page)
       }
    }
    
    func loadData() {
        let nextPage = self.nextPage
        
        switch selectedCategoryIndex {
        case 0:
            self.runOnBackgroundThread(page: nextPage, { page in
                self.getMoviesNowPlayingAsync(page)
            })
            break;
        case 1:
            self.runOnBackgroundThread(page: nextPage, { page in
                self.getUpcomingMoviesAsync(page)
            })
            break;
        case 2:
            self.runOnBackgroundThread(page: nextPage, { page in
                       self.getTrendingMoviesAsync(page)
                   })
            break;
        case 3:
            self.runOnBackgroundThread(page: nextPage, { page in
                self.getTrendingTvShowsAsync(page)
            })
            break;
        default:
            print("no category found")
        }
    }
    
    
    private func getMoviesNowPlayingAsync(_ page : Int = 1){
                
        if let nowplayingMovies = self.moviesViewModel?.getMoviesAsync(page: page, endpoint: MovieEndPoint.nowplaying_movies) {
            
            if self.movies!.count < 20{
                self.stopPagination()
            }
            
            self.movies = self.mergeMovies(currentMovies: self.movies!, newMovies: nowplayingMovies, page: page)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func getUpcomingMoviesAsync(_ page : Int = 1){
        if let upComingMovies = self.moviesViewModel?.getMoviesAsync(page: page, endpoint: MovieEndPoint.upcoming_movies) {
                        
            if self.movies!.count < 20{
                self.stopPagination()
            }
            
            self.movies = self.mergeMovies(currentMovies: self.movies!, newMovies: upComingMovies, page: page)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func getTrendingMoviesAsync(_ page : Int = 1){

        if let trendingMovies = self.moviesViewModel?.getMoviesAsync(page: page, endpoint: MovieEndPoint.trending_movies) {
            
            if self.movies!.count < 20{
                self.stopPagination()
            }
            
            self.movies = self.mergeMovies(currentMovies: self.movies!, newMovies: trendingMovies, page: page)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func getTrendingTvShowsAsync(_ page : Int = 1){

        if let trendingTvShows = self.tvShowsViewModel?.getTvShowsAsync(page: page, endpoint: TvShowEndPont.trending_tvshows) {
            
            if tvShows!.count < 20{
                self.stopPagination()
            }
            
            self.tvShows = self.mergeTvShows(currentTvShows: self.tvShows!, newTvShows: trendingTvShows, page: page)
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
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
    
    private func mergeTvShows(currentTvShows : [TvShow], newTvShows : [TvShow], page : Int) -> [TvShow]{
              if page == 1{
                  return newTvShows
              }else{
                  return currentTvShows + newTvShows
              }
          }
       
       private func stopPagination(){
           nextPage = -1
       }
        
}


extension MoviesAndTVShowsViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let movies = self.movies {
            return movies.count
        }
        
        if let tvshows = self.tvShows {
            return tvshows.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
        
        let placeholder = UIImage(named: "placeholder")
        
        cell.placeholderImage = placeholder
        cell.imageView.image = placeholder
        
        cell.contentView.layer.cornerRadius = 10.0;
        cell.contentView.layer.borderWidth = 1.0;
        cell.contentView.layer.borderColor = UIColor.clear.cgColor;
        cell.contentView.layer.masksToBounds = true;
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(2));
        cell.layer.shadowRadius = 2.0;
        cell.layer.shadowOpacity = 1.0;
        cell.layer.masksToBounds = false;
        cell.contentView.clipsToBounds = true
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath;
        
        cell.imageView.frame = cell.frame
        
        if let movies = self.movies {
            cell.imageView.image = placeholder
            cell.movie = movies[indexPath.row]
            cell.imageView.layer.cornerRadius = 10.0
            return cell
        } else if let tvshows = self.tvShows {
            cell.imageView.image = placeholder
            cell.tvShow = tvshows[indexPath.row]
            return cell
        }
        
        
        cell.movie = nil
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200/2, height: (300/2))
        
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

       if nextPage == -1{
           return
       }

        if self.movies != nil {
            if indexPath.row == self.movies!.count - 1{
                self.loadData()
                nextPage += 1
            }
            return
        }

        if self.tvShows != nil {
            if indexPath.row == self.tvShows!.count - 1{
                self.loadData()
                nextPage += 1
            }
        }
    }
    
    
}



