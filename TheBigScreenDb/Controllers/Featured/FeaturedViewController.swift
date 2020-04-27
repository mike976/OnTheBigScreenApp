

import UIKit

class FeaturedViewController: UIViewController {

    @IBOutlet weak var textField: UILabel!

    
    private let restApiClient = RestAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func executePressed(_ sender: UIButton) {
        
        guard let urlToExecute = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            return
        }
        

        restApiClient.Get(urlToExecute) { (json: Post?, error) in
            if let error = error {
                self.textField.text = error.localizedDescription
            } else {
                
                if let safejson = json! as Post? {
                    self.textField.text = String(safejson.id) + " " + safejson.body
                } else {
                     self.textField.text = "Unable to decode"
                }
            }
        }
        
    }
    
    
}

