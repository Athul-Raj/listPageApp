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
import PKHUD

class HomeListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var listTableView: UITableView!
    
    var currentPageNumber: Int! = 0
    var numberOfProperties: Int!
    var totalNumberOfProperties: Int!
    var maximumPages: Float!
    
    var filterURL = ""
    
    var modelDataArray : [DataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.InitialSetUp()
        self.listTableView.register(UINib(nibName: "HomeListTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeListTableViewCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationController()
        self.title = "Properties near me"
        if (numberOfProperties > 0){
            listTableView.setContentOffset(CGPoint.zero, animated: false)
        }
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
                    var urlFilterForImage = allPhoto[i].imagesMap?.medium!
                    if let range = urlFilterForImage?.range(of: "_") {
                        let firstPart = urlFilterForImage?[(urlFilterForImage?.startIndex)!..<range.lowerBound]
                        urlFilterForImage = firstPart! + "/" + urlFilterForImage!
                    }
                    let url = URL(string: (API.imageFetchBaseURL + urlFilterForImage!))
                                
                    cell.propertyImage.sd_setImage(with: url, placeholderImage: UIImage(named: "noImageIcon"))
                    break
                }else{
                    cell.propertyImage.image = #imageLiteral(resourceName: "noImageIcon")
                }
            }
        }
        if indexPath.row == self.numberOfProperties - 1 && self.currentPageNumber < Int(self.maximumPages) {
            if self.numberOfProperties <= totalNumberOfProperties{
                currentPageNumber! += 1
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
        
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        APIManager.fetchAllRooms(with: "\(currentPageNumber!)", and: filterURL) { (responseData: [String:Any]?) in
            if responseData == nil{
                PKHUD.sharedHUD.hide(afterDelay: 1.0)
            }else{
                //print (responseData!)
                let parsedModelData = Mapper<ListResponseModel>().map(JSONObject: responseData!)
        
                self.modelDataArray = self.modelDataArray + (parsedModelData?.dataArray)!
                
                self.totalNumberOfProperties! = (parsedModelData?.otherParams?.totalCount)!
                
                if (parsedModelData?.otherParams?.totalCount)! > 0{
                    self.maximumPages = ceil(Float((parsedModelData?.otherParams?.totalCount)!)/Float((parsedModelData?.otherParams?.count)!))
                    
                    if (self.currentPageNumber == Int(self.maximumPages)){
                        self.numberOfProperties! = self.totalNumberOfProperties
                    }else{
                        self.numberOfProperties! += (parsedModelData?.otherParams?.count)!
                    }
                    DispatchQueue.main.async{
                        self.listTableView.reloadData()
                        PKHUD.sharedHUD.hide(afterDelay: 0.1)
                    }
                }else{
                    self.listTableView.reloadData()
                    let alert = UIAlertController(title: "Alert", message: "Search Empty", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
                        self.performSegue(withIdentifier: "toFilterSegue", sender: self)
                    }))
                    
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                //self.listTableView.reloadInputViews()
            }
        }
    }
    
    func InitialSetUp(){
        self.loadProperty()
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
