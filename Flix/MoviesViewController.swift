//
//  MoviesViewController.swift
//  Flix
//
//  Created by Tenzing Nyima on 1/30/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var TableView: UITableView!
    
    var movies = [[String:Any]]()
    
    // creatiion of array of dictionaly , how to declare an array and dictionary.
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        //properties avalaible for life time of the screen
        // Do any additional setup after loading the view.
        print("Hello")
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
             
            
            self.movies = dataDictionary["results"] as! [[String:Any]]
            // the above is casting ? Remember what is casting ?
            
            self.TableView.reloadData()
            
            print(dataDictionary)
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    // movies are successfully stored
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        // why dequeReuseable
        // a lot of information in face book, youturb,m
        // that many cells, would take a lot of memory, and reuse memory,
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        // why ! ? its due to swift optionals.
        
        cell.synopsisLabel.text = synopsis
        
        
        //BASE URL IMPORTANT HOW DO WE FIND IT FIGURE IT OUT?
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // ios does allow us to download third party images.
        
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
