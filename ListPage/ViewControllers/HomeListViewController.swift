//
//  HomeListViewController.swift
//  ListPage
//
//  Created by Athul Raj on 10/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class HomeListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var listTableView: UITableView!
    
    var currentPageNumber: Int! = 0
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
        if allPhoto.count > 0{
            for i in (0...allPhoto.count - 1){
                if allPhoto[i].displayPic{
                    var urlFilterForImage = allPhoto[i].imagesMap?.thumbnail!
                    if let range = urlFilterForImage?.range(of: "_") {
                        let firstPart = urlFilterForImage?[(urlFilterForImage?.startIndex)!..<range.lowerBound]
                        urlFilterForImage = firstPart! + "/" + urlFilterForImage!
                    }

                    
                    let url = URL(string: (API.imageFetchBaseURL + urlFilterForImage!))
                    //DispatchQueue.global().async {
                        do{
                            let data = try Data(contentsOf: url!)
                            //DispatchQueue.main.async {
                                //cell.propertyImage.
                                //cell.propertyImage.image = UIImage(data: data)
                                
                                cell.propertyImage.sd_setImage(with: url, placeholderImage: UIImage(named: "noImageIcon"))

                            //}
                        }catch{
                            //  break
                        //}
                    }
                    break
                }else{
                    cell.propertyImage.image = UIImage(named:"noImageIcon");
                }
            }
        }
        
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
        APIManager.fetchAllRooms(with: "\(currentPageNumber!)", and: filterURL) { (responseData: [String:Any]?) in
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
                DispatchQueue.main.async{
                    self.listTableView.reloadData()
                }
                //self.listTableView.reloadInputViews()
            }
        }
    }
    
    func InitialSetUp(){
        self.loadProperty()
        listTableView.setContentOffset(CGPoint.zero, animated: false)
        currentPageNumber = 1
        numberOfProperties = 0
        totalNumberOfProperties = 0
        maximumPages = 0
    }
    
    //MARK: - Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewControllerB = segue.destination as! FilterViewController
        viewControllerB.filterValuePassed = { message in
            print (message)
            self.filterURL = message
            self.loadProperty()
            //self.InitialSetUp()
        }
    }
}
