
import UIKit

private let reuseIdentifier = "VideoCell"

class MediaViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewLayout: UICollectionViewFlowLayout!
    
    var selectedCategoryIndex: Int!
    var categories: [String]!
    var mediaList: [Media]?
        
    //MARK: - ViewModels
    var mediaListViewModel: MediaListViewModelProtocol!    
    
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
    
    private func loadData() {
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
                
        if let nowplayingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync (page: page, endpoint: MediaEndpoint.nowplaying_movies, nil) {
            
            if self.mediaList!.count < 20{
                self.stopPagination()
            }
            
            self.mediaList = self.mergeMediaList(currentMediaList: self.mediaList!, newMediaList: nowplayingMovies, page: page)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func getUpcomingMoviesAsync(_ page : Int = 1){
        if let upComingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.upcoming_movies, nil)  {
                        
            if self.mediaList!.count < 20{
                self.stopPagination()
            }
            
            self.mediaList = self.mergeMediaList(currentMediaList: self.mediaList!, newMediaList: upComingMovies, page: page)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func getTrendingMoviesAsync(_ page : Int = 1){

        if let trendingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.trending_movies, nil){
            
            if self.mediaList!.count < 20{
                self.stopPagination()
            }

            self.mediaList = self.mergeMediaList(currentMediaList: self.mediaList!, newMediaList: trendingMovies, page: page)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func getTrendingTvShowsAsync(_ page : Int = 1){

        if let trendingTvShows:[TvShow] = self.self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.trending_tvshows, nil) {
            
            if mediaList!.count < 20{
                self.stopPagination()
            }
            
            self.mediaList = self.mergeMediaList(currentMediaList: self.mediaList!, newMediaList: trendingTvShows, page: page)
                        
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
            }
        }
    }
    
    private func mergeMediaList(currentMediaList : [Media], newMediaList : [Media], page : Int) -> [Media]{
           if page == 1{
               return currentMediaList
           }else{
               return currentMediaList + newMediaList
           }
    }
       
   private func stopPagination(){
       nextPage = -1
   }
}


extension MediaViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let mediaList = self.mediaList {
            return mediaList.count
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
        
        cell.imageTapped = self.test
                            
        if let mediaList = self.mediaList {
            cell.imageView.image = placeholder
            cell.media = mediaList[indexPath.row]
            cell.imageView.layer.cornerRadius = 10.0
            return cell
        }
        
        
        cell.media = nil
        
        return cell
    }
    
    func test() {
        
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

        if self.mediaList != nil {
            if indexPath.row == self.mediaList!.count - 1{
                self.loadData()
                nextPage += 1
            }
            return
        }
    }
}



