//
//  ViewController.swift
//  Senkouhanabi2
//
//  Created by Raphael on 2019/09/29.
//  Copyright © 2019 takahashi. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.backgroundColor = UIColor.green // 背景色
        
        button.layer.cornerRadius = 10.0 // 角丸のサイズ
        }

    
}

