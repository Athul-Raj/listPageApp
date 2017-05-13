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
    var numberOfProperties: Int!
    var totalNumberOfProperties: Int!
    var maximumPages: Float!
    
    var filterURL = ""
    
    var modelDataArray : [DataModel] = []
    
    var navigationSubView = CustomNavigationView.init(frame: CGRect.init(x: 0, y: 0, width: 320.0 , height: 75))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.listTableView.register(UINib(nibName: "HomeListTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeListTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationController()
        self.InitialSetUp()
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

        
        let propertyModel = modelDataArray[indexPath.row]
        cell.propertyTitle.text = propertyModel.propertyTitle
        cell.propertySubTitle.text = propertyModel.secondaryTitle
        cell.sqFeetLabel.text = "\(propertyModel.propertySize!) Sq.ft"
        cell.furnitLabel.text = propertyModel.furnishingDesc! + " Furnished"
        cell.costLabel.text = "₹ \(propertyModel.rent!)"
        if propertyModel.bathroom == 1{
            cell.bathroomLabel.text = "Single Bathroom";
        }else{
            cell.bathroomLabel.text = "\(propertyModel.bathroom!) Bathrooms";
        }
        
        
        let allPhoto = propertyModel.propertyAllImages!
        for i in (0...allPhoto.count - 1){
            if allPhoto[i].displayPic{
                
                var urlFilterForImage = allPhoto[i].imagesMap?.original!
                if let range = urlFilterForImage?.range(of: "_") {
                    let firstPart = urlFilterForImage?[(urlFilterForImage?.startIndex)!..<range.lowerBound]
                    urlFilterForImage = firstPart! + "/" + urlFilterForImage!
                    print(urlFilterForImage!) // print Hello
                }
                
                
                
                
                
                
                
                
                
                
                let url = URL(string: (API.imageFetchBaseURL + urlFilterForImage!))
                DispatchQueue.global().async {
                    do{
                        let data = try Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            cell.propertyImage.image = UIImage(data: data)
                            
                        }
                    }catch{
                      //  break
                    }
                }
                break
            }
        }
        
        /*
         
         
         If key of image is ff8081815848207b01584832ea1d012c_76516_original then you have to access image like
         
         
         http://d3snwcirvb4r88.cloudfront.net/images/ff8081815848207b01584832ea1d012c/ff8081815848207b01584832ea1d012c_76516_original.jpg
        let url = URL(string: modelDataArray[indexPath.row].)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data!)
            }
        }*/
        //cell.imageView?.image = UIImage
        
        print(indexPath.row)
        if indexPath.row == self.numberOfProperties - 1 && self.currentPageNumber < Int(self.maximumPages) {
            if self.numberOfProperties <= totalNumberOfProperties{
                currentPageNumber! += 1
                //print("Total number of Properties:\(self.totalNumberOfProperties)")
                self.loadProperty()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 350.0
    }

    
    
    //MARK: - Local Methods
    func loadProperty(){
        print("Current page number:\(currentPageNumber)")
        APIManager.fetchAllRooms(with: "\(currentPageNumber)", and: filterURL) { (responseData: [String:Any]?) in
            if responseData == nil{
                
            }else{
                //print (responseData!)
                let parsedModelData = Mapper<ListResponseModel>().map(JSONObject: responseData!)
        
                self.modelDataArray = self.modelDataArray + (parsedModelData?.dataArray)!
                
                self.totalNumberOfProperties! = (parsedModelData?.otherParams?.totalCount)!
                self.maximumPages = ceil(Float((parsedModelData?.otherParams?.totalCount)!)/Float((parsedModelData?.otherParams?.count)!))
                
                if (self.currentPageNumber == Int(self.maximumPages)){
                    self.numberOfProperties! = self.totalNumberOfProperties
                }else{
                    self.numberOfProperties! += (parsedModelData?.otherParams?.count)!
                }
                self.listTableView.reloadData()
            }
        }
    }
    
    func InitialSetUp(){
        currentPageNumber = 1
        numberOfProperties = 0
        totalNumberOfProperties = 0
        maximumPages = 0
        self.loadProperty()
    }
    
    //MARK: - Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewControllerB = segue.destination as! FilterViewController
        viewControllerB.filterValuePassed = { message in
            print (message)
            self.filterURL = message
            self.InitialSetUp()
        }
    }
}


