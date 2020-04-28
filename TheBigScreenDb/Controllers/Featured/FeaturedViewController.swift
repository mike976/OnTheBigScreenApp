

import UIKit

class FeaturedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let movieService = MoviesService()
    
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
    
    private func Initialize() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        movieService.moviesNowPlayingReceivedDelegate = self
        
        movieService.getMoviesNowPlaying()
    }
}


extension FeaturedViewController : MoviesNowPlayingReceivedDelegate {
    
    func moviesNowPlayingReceived() {
        if let moviesNowPlaying = self.movieService.moviesNowPlayingList {
            self.moviesNowPlayingList = moviesNowPlaying
        }
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
    
    

