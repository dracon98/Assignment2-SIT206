//
//  ViewController.swift
//  SpaceWar
//
//  Created by RICHARDO WIJAYA on 16/05/2017.
//  Copyright © 2017 RICHARDO WIJAYA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        historyBtn.layer.borderColor = UIColor.black.cgColor
        historyBtn.layer.borderWidth = 1
        startBtn.layer.borderWidth = 1
        startBtn.layer.cornerRadius = 10
        startBtn.layer.borderColor = UIColor.black.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
