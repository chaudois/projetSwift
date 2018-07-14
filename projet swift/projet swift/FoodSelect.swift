//
//  FoodSelect.swift
//  projet swift
//
//  Created by Developer on 14/06/2018.
//  Copyright © 2018 esgi. All rights reserved.
//

import UIKit

class FoodSelect:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    var foodName : String = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "foodToMap") {
            let vc = segue.destination as? MapControler
            vc?.foodtype=foodName
 
        }
    }

    @IBAction func onFoodClicked(_ sender: Any) {
        foodName = ((sender as! UIButton).titleLabel?.text)!
        performSegue(withIdentifier: "foodToMap", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
