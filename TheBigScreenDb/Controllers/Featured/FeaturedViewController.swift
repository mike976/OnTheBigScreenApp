

import UIKit

class FeaturedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var moviesNowPlayingList = MovieResults() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.Initialize()
    }
    
    var featuredViewModel: FeaturedViewModel!
    
    private func Initialize() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.featuredViewModel.moviesNowPlayingReceivedDelegate = self
        self.featuredViewModel.getMoviesNowPlaying()

    }
}


extension FeaturedViewController : UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesNowPlayingList.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCell", for: indexPath)
        
        let movie = self.moviesNowPlayingList.results[indexPath.row]
        cell.textLabel!.text = movie.title
        
        return cell
    }
    
}

extension FeaturedViewController : UITableViewDelegate {
    
}

extension FeaturedViewController : MoviesNowPlayingReceivedDelegate {
    func moviesNowPlayingReceived() {
        if let moviesNowPlaying = self.featuredViewModel.moviesNowPlayingList {
            self.moviesNowPlayingList = moviesNowPlaying
            print("received movies in FeaturedViewController")
        }
    }
}
    
    

