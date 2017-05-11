//
//  HomeListViewController.swift
//  ListPage
//
//  Created by Athul Raj on 10/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var listTableView: UITableView!
    
    var currentPageNumber: Int!
    //var numberof
    var numberOfProperties: Int!
    var totalNumberOfProperties: Int!
    var maximumPages: Float!
    
    var navigationSubView = CustomNavigationView.init(frame: CGRect.init(x: 0, y: 0, width: 320.0 , height: 75))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPageNumber = 1
        numberOfProperties = 0
        
        self.listTableView.register(UINib(nibName: "HomeListTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeListTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationController()
        self.loadProperty()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //MARK: - Tableview Datasource and Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfProperties
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:HomeListTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "HomeListTableViewCell") as? HomeListTableViewCell)!
        cell.textLabel?.text = "First Word"
        //let taker = takerList[indexPath.row]
        //cell.takerNameLabel.text = taker.name
        //cell.takerPickUpPointLabel.text = taker.destination
        //cell.takerImage.imageFromURL(urlString: taker.photoURL!)
        
        if indexPath.row == self.numberOfProperties - 1 {
            if self.numberOfProperties <= totalNumberOfProperties && currentPageNumber < Int(maximumPages){
                currentPageNumber! += 1
                self.totalNumberOfProperties = 21//parsedModelData?.otherParams?.totalCount
                print("Total number of Properties:\(self.totalNumberOfProperties)")
                self.loadProperty()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 350.0
    }

    
    
    //MARK: - Local Mrthods
    func loadProperty(){
        print("Current page number:\(currentPageNumber)")
        APIManager.fetchAllRooms(with: "\(currentPageNumber)") { (responseData: [String:Any]?) in
            if responseData == nil{
                
            }else{
                //print (responseData!)
                let parsedModelData = Mapper<ListResponseModel>().map(JSONObject: responseData!)
                
                self.maximumPages = ceil(Float((parsedModelData?.otherParams?.totalCount)!)/Float((parsedModelData?.otherParams?.count)!))
                
                self.numberOfProperties! += (parsedModelData?.otherParams?.count)!
                print("Count :\(parsedModelData?.otherParams?.count)!")
                print("Total number of Properties Visible :\(self.numberOfProperties)")
                self.listTableView.reloadData()
            }
        }
    }
}
