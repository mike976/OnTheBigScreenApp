

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
    var timer: Timer? = nil
    var counter = 0
    var selectedPosterIndex = -1
    
    var categories = ["Now Playing", "Coming Soon", "Trending Movies", "Trending TV Shows"]
    var featuredHeaderImages: [String] {
        
        get {
            let x = [  "FeaturedHeaderImage1",
                       "FeaturedHeaderImage2",
                       "FeaturedHeaderImage3",
                       "FeaturedHeaderImage4",
                       "FeaturedHeaderImage5",
                       "FeaturedHeaderImage6"]
            
            return x
        }
    }
    
    //MARK: - ViewModels
    var mediaListViewModel: MediaListViewModelProtocol?
    {
        didSet{
            loadMediaList()
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavBar(hideBar: true)
                
        self.Initialize()
        
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureNavBar(hideBar: true)
        
        
        //restart timer if it was initialised by the viewdidload
        //if let safeTimer = self.timer {
        if self.mediaListViewModel != nil {
            self.timer?.invalidate()
            self.timer?.fire()
        }
        //}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.configureNavBar(hideBar: false)
        
    }

    private func Initialize() {
       
       tableView.dataSource = self
       tableView.delegate = self
        
       changeFeaturedHeaderImage()
       view.bringSubviewToFront(featuredHeaderPoster)
          
       featuredHeaderPoster.frame = CGRect(x: 0, y:0, width: view.frame.width, height: 200)
        
       tableView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
       tableView.estimatedRowHeight = 300
       tableView.rowHeight = 200
       tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
       self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeFeaturedHeaderImage), userInfo: nil, repeats: true)
    }
    
    
    func configureNavBar(hideBar: Bool = false) {
        
        if let navBar = self.navigationController?.navigationBar {

            navBar.setBackgroundImage(nil, for: .default)
            navBar.setValue(false, forKey: "hidesShadow")
            
            if hideBar {
                
                navBar.setBackgroundImage(UIImage(), for: .default)
                navBar.setValue(true, forKey: "hidesShadow")
            }
        }
    }
    

    func loadMediaList() {
                           
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

        if selectedPosterIndex > featuredHeaderImages.count-1 {
            selectedPosterIndex = 0
        }

        DispatchQueue.main.async {

            let imageName = self.featuredHeaderImages[self.selectedPosterIndex]
            self.featuredHeaderPoster.image = UIImage(named: imageName)
        }
    }
    
    //MARK: - Movies functions
    
    private func getMoviesNowPlayingAsync(_ page : Int = 1){
        
        
        if let nowplayingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.nowplaying_movies) {
            self.nowPlayingMovies = nowplayingMovies
                    
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    private func getUpcomingMoviesAsync(_ page : Int = 1){
        if let upComingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.upcoming_movies) {
            self.upComingMovies = upComingMovies

            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        }
    }

    private func getTrendingMoviesAsync(_ page : Int = 1){

        if let trendingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.trending_movies) {
            self.trendingMovies = trendingMovies
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        }
    }

    private func getTrendingTvShowsAsync(_ page : Int = 1){

        if let trendingTvShows:[TvShow] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.trending_tvshows) {
            self.trendingTvShows = trendingTvShows
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        }
    }
    
    typealias GetMediaListHandler = (Int) -> Void
    func runOnBackgroundThread(page: Int, _ getMediaList: @escaping GetMediaListHandler) {
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {
            
            getMediaList(page)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if let categoryIndex = sender as? Int {
            let vc = segue.destination as! MediaViewController

            vc.selectedCategoryIndex = categoryIndex
            vc.categories = self.categories
            vc.mediaListViewModel = self.mediaListViewModel            
            
            
            switch categoryIndex {
            case 0:
                vc.mediaList = self.nowPlayingMovies
                break
            case 1:
                vc.mediaList = self.upComingMovies
                break
            case 2:
                vc.mediaList = self.trendingMovies
                break
            case 3:
                vc.mediaList = self.trendingTvShows
                break
            default:
                vc.mediaList = self.nowPlayingMovies
                break
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
       
        cell.mediaList = [Media]()
               
        if indexPath.section == 0 {
            cell.categoryName = categories[indexPath.section]
             cell.mediaList = self.nowPlayingMovies
        } else if indexPath.section == 1 {
            cell.categoryName = categories[indexPath.section]
             cell.mediaList = self.upComingMovies
        } else if indexPath.section == 2 {
            cell.categoryName = categories[indexPath.section]
            cell.mediaList = self.trendingMovies
        } else if indexPath.section == 3 {
            cell.categoryName = categories[indexPath.section]
            cell.mediaList = self.trendingTvShows
        }
        
        cell.collectionView.backgroundColor = .clear
        cell.collectionView.showsHorizontalScrollIndicator = false
        cell.collectionView.reloadData()
        

       return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y

        let height = y //max(y, 88)

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

        let categoryIndex = Int(sender.tag)
        performSegue(withIdentifier: "showCollectionIdentifier", sender: categoryIndex)
    }
    
    
}
