import UIKit

private let reuseIdentifier = "VideoCell"

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarIcon: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!
    
    private var mediaList = [Media]()
    
    var mediaListViewModel: MediaViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.searchBar.delegate = self
        
        shouldShowSearchInstructions(show: true)
    }

    func shouldShowSearchInstructions(show: Bool) {
        if show {
            self.searchLabel?.isHidden = false
            self.searchBarIcon?.isHidden = false
            self.collectionView?.backgroundColor = .clear
            return
        }
        
        self.searchLabel?.isHidden = true
        self.searchBarIcon?.isHidden = true
        self.collectionView.backgroundColor = .systemBackground
    }
    
    func loadMediaList(searchText: String) {
                           
        self.runOnBackgroundThread(page: 1, { page in
            self.getMediaListAsync(page, searchText)
        })
    }
        
    private func getMediaListAsync(_ page : Int = 1, _ searchText: String){
                     
       if let mediaList:[Media] = self.mediaListViewModel?.getMediaListAsync(page: page, endpoint: MediaEndpoint.search_movies, searchText) {
           self.mediaList = mediaList
           
            DispatchQueue.main.async {                
               self.collectionView.reloadData()
                
                // show or hide the search instruction label
                if self.searchBar.text?.count == 0  {
                    self.shouldShowSearchInstructions(show: true)
                } else {
                    self.shouldShowSearchInstructions(show: false)
                }
               
            }
        }
    }
    
    typealias GetMediaListHandler = (Int) -> Void
         func runOnBackgroundThread(page: Int, _ getMediaList: @escaping GetMediaListHandler) {
             
             let dispatchQueue = DispatchQueue.global(qos: .background)
             
            dispatchQueue.asyncAfter(deadline: .now() + Double(0.5), execute: {
                getMediaList(page)
                       
            })
         }

}


extension SearchViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
   // MARK: UICollectionViewDataSource

   func numberOfSections(in collectionView: UICollectionView) -> Int {
       // #warning Incomplete implementation, return the number of sections
       return 1
   }


   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // #warning Incomplete implementation, return the number of items
        return self.mediaList.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
    
        let placeholder = UIImage(named: "placeholder")

        cell.placeholderImage = placeholder
        cell.imageView.image = placeholder
        
        cell.media = self.mediaList[indexPath.row]
        //cell.layer.masksToBounds = true;
        
    
       return cell
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 5, height:100)
    }
       
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                  
        self.loadMediaList(searchText: searchText)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

}
