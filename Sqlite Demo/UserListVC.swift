//
//  UserListVC.swift
//  Sqlite Demo
//
//  Created by Gourav on 15/02/20.
//  Copyright © 2020 Gourav. All rights reserved.
//

import UIKit
import SDWebImage

class UserListVC: UIViewController {

    @IBOutlet weak var tbl: UITableView!
    
    var responseData = [Json4Swift_Base]()
    override func viewDidLoad() {
        super.viewDidLoad()

     // apiCall()
      
        fetchLocalData()
    
        
    }
    
    func getData(str:String){
        print(str)
    }
    func apiCall(){
        let request = NSMutableURLRequest(url: NSURL(string: "https://jsonplaceholder.typicode.com/photos")! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
              if error != nil {
                  print("Error: \(String(describing: error))")
              } else {
                let decoded = try! JSONDecoder().decode([Json4Swift_Base].self, from: data!)
                self.responseData = decoded
                DispatchQueue.main.async {
                     self.tbl.reloadData()
                    self.storeDataLocaly(data: self.responseData)
                }
               
              }
         })

         task.resume()
    }
    func storeDataLocaly(data:[Json4Swift_Base]){
        DBManager.shared.insertIntoLocalDatabase(data: data)
    }
    func fetchLocalData(){
        self.responseData =  DBManager.shared.fetchFromLocalDatabase()
        self.tbl.reloadData()
    }
}
extension UserListVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let vc = storyboard?.instantiateViewController(identifier: "DetailVC") as! DetailVC
        vc.mainView = self
        self.navigationController?.pushViewController(vc, animated: true)
 
    }
}

extension UserListVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let titleLabel = cell.viewWithTag(100) as! UILabel
        titleLabel.text = responseData[indexPath.row].title
        
        let imageView = cell.viewWithTag(200) as! UIImageView
        imageView.sd_setImage(with: URL(string: responseData[indexPath.row].thumbnailUrl ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseData.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
