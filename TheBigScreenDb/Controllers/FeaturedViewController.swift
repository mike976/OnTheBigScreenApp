

import UIKit
import RxSwift

class FeaturedViewController: UIViewController {
    
    deinit {
        print("OS reclaiming memory - FeaturedViewController - no retain cycle/memory leaks here")
    }
    
    //MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var featuredHeaderScrollView: UIScrollView!
    
    private var nowPlayingMovies = [Movie]()
    private var upComingMovies = [Movie]()
    private var trendingMovies = [Movie]()
    private let disposeBag = DisposeBag()
    private var trendingTvShows = [TvShow]()
    private var isActive: Bool = false
    

    private var featuredHeaderImages = [
        "FeaturedHeaderImage1",
        "FeaturedHeaderImage2",
        "FeaturedHeaderImage3"
    ]
    
    var selectedMedia: Media?
    
    //MARK: - Featured Header properties
    var counter = 0
        
    var categories = ["Now Playing", "Coming Soon", "Trending Movies", "Trending TV Shows"]
    
    //MARK: - ViewModels
    var mediaListViewModel: MediaViewModelProtocol?
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
        self.isActive = true
            
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.configureNavBar(hideBar: false)
        self.isActive = false
    }


    private func Initialize() {
       
       subscribeToRxSwiftEvents()
        
       tableView.dataSource = self
       tableView.delegate = self

       let pageControl = UIPageControl()
       pageControl.frame = CGRect(x: (view.frame.width/2) - 75 , y: 200 - 20, width: 150, height: 40)
       pageControl.numberOfPages = 3
        

 
        featuredHeaderScrollView.frame = CGRect(x: 0, y:0, width: view.frame.width, height: 200)
       
        for i in 0..<featuredHeaderImages.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: featuredHeaderImages[i])
            let xPos = CGFloat(i)*view.frame.width
            imageView.frame = CGRect(x: xPos , y: 0, width: view.frame.width, height: 200)
            featuredHeaderScrollView.contentSize.width = view.frame.width*CGFloat(i+1)
            featuredHeaderScrollView.addSubview(imageView)
            featuredHeaderScrollView.backgroundColor = .black
        }
        
        featuredHeaderScrollView.delegate = self
        featuredHeaderScrollView.tag = 999

        view.addSubview(pageControl)
        
        
        view.bringSubviewToFront(featuredHeaderScrollView)
        view.bringSubviewToFront(pageControl)
        
       
        
       tableView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
       tableView.estimatedRowHeight = 300
       tableView.rowHeight = 200
       tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
    
    
    //MARK: - Media requested from MediaListViewModel
    
    private func getMoviesNowPlayingAsync(_ page : Int = 1){
        
        
        if let nowplayingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.nowplaying_movies, nil) {
            self.nowPlayingMovies = nowplayingMovies
                    
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    private func getUpcomingMoviesAsync(_ page : Int = 1){
        if let upComingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.upcoming_movies, nil) {
            self.upComingMovies = upComingMovies

            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        }
    }

    private func getTrendingMoviesAsync(_ page : Int = 1){

        if let trendingMovies:[Movie] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.trending_movies, nil) {
            self.trendingMovies = trendingMovies
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }
        }
    }

    private func getTrendingTvShowsAsync(_ page : Int = 1){

        if let trendingTvShows:[TvShow] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.trending_tvshows, nil) {
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
     
        //navigate to media list page
        if let categoryIndex = sender as? Int {
            let vc = segue.destination as! MediaViewController

            vc.selectedCategoryIndex = categoryIndex
            vc.categories = self.categories
            vc.mediaViewModel = self.mediaListViewModel            
            
            
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
        
        //navigate to media detail page
        if let featuredController = sender as? FeaturedViewController {
            if let vc = segue.destination as? MediaDetailViewController {
             vc.mediaViewModel = featuredController.mediaListViewModel
                vc.media = featuredController.selectedMedia
            }
        }
    }
    
    private func subscribeToRxSwiftEvents() {
        
        MediaSelectionProvider.Instance.selectedMediaObservable.subscribe { [weak self] (mediaEvent) in

            if self!.isActive {
                if let media = mediaEvent.element {
                    self?.selectedMedia = media
                    self?.performSegue(withIdentifier: "FeaturedToMediaDetailSegue", sender: self)
                }
            }
        }.disposed(by: disposeBag)
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

        
        if scrollView.tag == 999 {
            
            let page = scrollView.contentOffset.x/scrollView.frame.width
            if let pc = view.subviews[2] as? UIPageControl {
                pc.currentPage = Int(page)

            }
            
            
        } else {
            
                    let height = y //max(y, 88)
            
            
                    featuredHeaderScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
            
            
            
                    for i in 0..<featuredHeaderScrollView.subviews.count {
            
            
                        let xPos = CGFloat(i)*view.frame.width
            
                        if let imageV = featuredHeaderScrollView.subviews[i] as? UIImageView {
                            imageV.frame = CGRect(x: xPos , y: 0, width: featuredHeaderScrollView.frame.width, height: height)
                        }
                    }
            
            
                    if let pc = view.subviews[2] as? UIPageControl {
                        pc.frame = CGRect(x: (featuredHeaderScrollView.frame.width/2)-75 , y: height-40, width: 150, height: 40)

                    }
        }
        

    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        
        
        let button = UIButton(frame: CGRect(x: frame.width-90, y: 13, width: 100, height: 20))
        button.tag = section
        button.setTitle("See All", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: CGFloat(12))
        button.addTarget(self,action:#selector(buttonClicked),for:.touchUpInside)

        button.tag = section //important we tag the section clicked and so we can seque to correct page using this
    
                
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 13, width: 200, height: 21)
        label.text = categories[section]
        label.font =  UIFont.boldSystemFont(ofSize: 20.0)
        

        
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



