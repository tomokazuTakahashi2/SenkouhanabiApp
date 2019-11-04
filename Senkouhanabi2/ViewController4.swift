//
//  ViewController4.swift
//  Senkouhanabi2
//
//  Created by Raphael on 2019/11/04.
//  Copyright © 2019 takahashi. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController4: UIViewController {
    
    @IBOutlet weak var returnButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //戻るボタンのスタイル
        returnButton.backgroundColor = UIColor.green // 背景色
        returnButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        // SKViewに型を変換する
        let skView = self.view as! SKView
        
        // FPSを表示する
        skView.showsFPS = true
        
        // ノードの数を表示する
        skView.showsNodeCount = true
        
        //SKViewに合わせてスケールする
        let sceneSize = CGSize(width:1000, height:1000)
        let scene = GameScene3(size: sceneSize)
        scene.scaleMode = .aspectFill
        
        // ビューにシーンを表示する
        skView.presentScene(scene)
        
    }
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
}
