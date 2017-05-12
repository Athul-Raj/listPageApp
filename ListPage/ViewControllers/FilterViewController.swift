//
//  FilterViewController.swift
//  ListPage
//
//  Created by Athul Raj on 10/05/17.
//  Copyright © 2017 Athul Raj. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

   // var filterValuePassed: ((String) -> Void)!

    @IBOutlet weak var b: RadioButton!
    @IBOutlet weak var a: RadioButton!
    @IBOutlet weak var c: RadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    
    @IBAction func closeFilterViewTapped(_ sender: Any) {
        //filterValuePassed(filters!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refresh(_ sender: Any) {
        
        b.isSelected = false
        a.isSelected = false
        c.isSelected = false
        
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
