//
//  ViewController.swift
//  AreaPickerView
//
//  Created by sessionCh on 05/15/2018.
//  Copyright (c) 2018 sessionCh. All rights reserved.
//

import UIKit
import AreaPickerView

class ViewController: UIViewController {
    
    @IBOutlet weak var areaLab: UILabel!
    
    @IBAction func buttonDidClicked(_ sender: Any) {
        
        let defaultValue = areaLab.text
        AreaPickerView.show(window: view.window!, title: "选择地区", defaultValue: defaultValue!) { [weak self] (area) in
            self?.areaLab.text = area
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        areaLab.text = "湖北省武汉市汉阳区"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

