//
//  FilterViewController.swift
//  ListPage
//
//  Created by Athul Raj on 10/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit
import ObjectMapper
import PKHUD

class FilterViewController: UIViewController {
    @IBOutlet var applyButton: UIButton!

    @IBOutlet var fourPlusBHKButton: RadioButton!
    @IBOutlet var oneBhkButton: RadioButton!
    @IBOutlet var threeBhkButton: RadioButton!
    @IBOutlet var fourBhkButton: RadioButton!
    @IBOutlet var twoBhkButton: RadioButton!
    @IBOutlet var oneRkButton: RadioButton!
    
    @IBOutlet var appartmentButton: RadioButton!
    @IBOutlet var individualFloorButton: RadioButton!
    @IBOutlet var individualHouseButton: RadioButton!
    
    @IBOutlet var furnishedButton: RadioButton!
    @IBOutlet var semiFurnishedButton: RadioButton!
    
    @IBOutlet var refreshButton: UIButton!
    
    var filterValuePassed: ((String) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        refreshButton.imageView?.image = refreshButton.imageView?.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        refreshButton.imageView?.tintColor = UIColor.white
        refreshButton.setImage(refreshButton.imageView?.image, for: .selected)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button Actions
    
    @IBAction func applyButtonTapped(_ sender: Any) {
        self.loadProper()
    }
    
    @IBAction func closeFilterViewTapped(_ sender: Any) {
        //filterValuePassed(filters!)
        self.refresh(sender)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        oneRkButton.isSelected = false
        oneBhkButton.isSelected = false
        twoBhkButton.isSelected = false
        threeBhkButton.isSelected = false
        fourBhkButton.isSelected = false
        fourPlusBHKButton.isSelected = false
        
        appartmentButton.isSelected = false
        individualHouseButton.isSelected = false
        individualFloorButton.isSelected = false
        
        furnishedButton.isSelected = false
        semiFurnishedButton.isSelected = false
    }

    
    //MARK:- Local methods
    
    func getURLSubpartforBHK() -> String{
        var filterBHK = [String]()
        var bhkURLSub : String = "&type="
        
        if oneRkButton.isSelected{
            filterBHK.append("RK1")
        }
        if oneBhkButton.isSelected{
            filterBHK.append("BHK1")
        }
        if twoBhkButton.isSelected{
            filterBHK.append("BHK2")
        }
        if threeBhkButton.isSelected{
            filterBHK.append("BHK3")
        }
        if fourBhkButton.isSelected{
            filterBHK.append("BHK4")
        }
        if fourPlusBHKButton.isSelected{
            filterBHK.append("BHK4+")
        }
        
        if filterBHK.count == 0{
            return ""
        }else{
            for i in (0...filterBHK.count - 1){
                if i != filterBHK.count - 1 {
                    bhkURLSub = bhkURLSub + filterBHK[i] + "/"
                }else{
                    bhkURLSub = bhkURLSub + filterBHK[i]
                }
            }
            return bhkURLSub
        }
    }
    
    func getURLSubpartforAppartment() -> String{
        var filterAppart = [String]()
        var appartURLSub : String = "&buildingType="
        
        if appartmentButton.isSelected{
            filterAppart.append("AP")
        }
        if individualHouseButton.isSelected{
            filterAppart.append("IH")
        }
        if individualFloorButton.isSelected{
            filterAppart.append("IF")
        }
        
        if filterAppart.count == 0{
            return ""
        }else{
        
            for i in (0...filterAppart.count - 1){
                if i != filterAppart.count - 1 {
                    appartURLSub = appartURLSub + filterAppart[i] + "/"
                }else{
                    appartURLSub = appartURLSub + filterAppart[i]
                }
            }
            return appartURLSub
        }
    }
    
    func getURLSubpartforFurniture() -> String{
        var filterFurnit = [String]()
        var furniURLSub : String = "&furnishing="
        
        if furnishedButton.isSelected{
            filterFurnit.append("FULLY_FURNISHED")
        }
        if semiFurnishedButton.isSelected{
            filterFurnit.append("SEMI_FURNISHED")
        }
        
        if filterFurnit.count == 0{
            return ""
        }else{
            for i in (0...filterFurnit.count - 1){
                if i != filterFurnit.count - 1 {
                    furniURLSub = furniURLSub + filterFurnit[i] + "/"
                }else{
                    furniURLSub = furniURLSub + filterFurnit[i]
                }
            }
            return furniURLSub
        }
    }
    
    
    func loadProper(){
        
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show()
        
        let filterURL = getURLSubpartforBHK() + getURLSubpartforAppartment() + getURLSubpartforFurniture()
        APIManager.fetchAllRooms(with: "1", and: filterURL) { (responseData: [String:Any]?) in
            if responseData == nil{
                PKHUD.sharedHUD.hide()
            }else{
                //print (responseData!)
                let parsedModelData = Mapper<ListResponseModel>().map(JSONObject: responseData!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let objectRefHomeListVC:HomeListViewController = appDelegate.nav!.viewControllers.last as! HomeListViewController
                
                objectRefHomeListVC.modelDataArray = (parsedModelData?.dataArray)!
                objectRefHomeListVC.totalNumberOfProperties! = (parsedModelData?.otherParams?.totalCount)!
                objectRefHomeListVC.currentPageNumber = 1
                
                if (parsedModelData?.otherParams?.totalCount)! > 0{
                    
                    objectRefHomeListVC.maximumPages = ceil(Float((parsedModelData?.otherParams?.totalCount)!)/Float((parsedModelData?.otherParams?.count)!))
                    
                    if (1 == Int(objectRefHomeListVC.maximumPages)){
                        objectRefHomeListVC.numberOfProperties! = objectRefHomeListVC.totalNumberOfProperties
                    }else{
                        objectRefHomeListVC.numberOfProperties! = (parsedModelData?.otherParams?.count)!
                    }
                }else{
                    objectRefHomeListVC.numberOfProperties = 0;
                    objectRefHomeListVC.maximumPages = 0;
                    objectRefHomeListVC.currentPageNumber = 1
                }
                self.filterValuePassed(filterURL)
                PKHUD.sharedHUD.hide()
                self.refresh(self)
                self.dismiss(animated: true, completion: nil)
                
                //self.listTableView.reloadInputViews()
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

