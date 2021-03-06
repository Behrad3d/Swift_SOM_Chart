//
//  ViewController.swift
//  SOM_Chart
//
//  Created by Behrad Bagheri on 7/20/16.
//  Copyright © 2016 BoringB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var somChart: SOMChart!
    
    var dataValues : [Double]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Load a sammple JSON file 
        if let path = Bundle.main.path(forResource: "sample_som", ofType: "json")
        {
            
            if let jsonData = NSData(contentsOfFile: path)
            {
                do {
                    let json = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    
                    dataValues = json["data"] as? [Double]
                    somChart.distanceMatrix = dataValues
                    
                } catch {
                    print(error)
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

