//
//  GameScene.swift
//  Senkouhanabi2
//
//  Created by Raphael on 2019/09/29.
//  Copyright © 2019 takahashi. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate{

    var fireBall:SKSpriteNode!
    var pati:SKNode!
    var pati2:SKNode!
    var chirachira:SKNode!
    var opening:SKNode!
    var stickNode:SKNode!
    
    //音1のインスタンス
    let sound = SKNode()
    //音２のインスタンス
    let sound2 = SKNode()
    
    // 衝突判定カテゴリー
    let FireBallCategory: UInt32 = 1 << 0       // 0...00001
    let groundCategory: UInt32 = 1 << 1     // 0...00010

    // MotionManagerのインスタンス
    let motionManager = CMMotionManager()
    
    //加速度センサーのX,Y,Z
    var acceleX: Double = 0
    var acceleY: Double = 0
    var acceleZ: Double = 0
    let Alpha = 0.4
    var flg: Bool = false
    
// SKView上にシーンが表示されたときに呼ばれるメソッド
    override func didMove(to view: SKView) {
        // 重力を設定
        physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        physicsWorld.contactDelegate = self
        
        // 背景色を設定
        backgroundColor = UIColor(red: 0, green: 0, blue: 0.2, alpha: 1)
        
        // 棒のノード
        stickNode = SKNode()

        // 各種スプライトを生成する処理をメソッドに分割
        setupOpening()
        setupSound()
        setupSound2()
        setupFireBall()
        setupPatipati()
        setupPatipati2()
        setupChirachira()
        setupGround()
        setupStick()
        
        // zPositionを０に設定.
        stickNode.zPosition = 0
        fireBall.zPosition = 2
        pati.zPosition = 1
        pati2.zPosition = 1
        chirachira.zPosition = 1
        opening.zPosition = 1
        
        
    }
    
//音
    func setupSound(){
        //soundデータを読み込む
        let s1 = SKAction.playSoundFileNamed("fuse1.mp3", waitForCompletion: false)
        let s2 = SKAction.playSoundFileNamed("線香花火.mp3", waitForCompletion: true)
        //s2をループ
        let actionLoop = SKAction.repeatForever(s2)
        //待ち39秒
        let wait = SKAction.wait(forDuration: 39.0)
        // サウンドを削除
        let deleteSound = SKAction.removeFromParent()
        //s1再生→39秒間待機→サウンド削除
        let setSound = SKAction.sequence([s1,actionLoop])
        sound.run(setSound)
        let cancelSound = SKAction.sequence([wait,deleteSound])
        sound.run(cancelSound)
        //サウンドを追加する
        addChild(sound)
      
    }
    
//音2
    func setupSound2(){
        //soundデータを読み込む
        let s1 = SKAction.playSoundFileNamed("線香花火_3.mp3", waitForCompletion: false)
        let s2 = SKAction.playSoundFileNamed("線香花火_2.mp3", waitForCompletion: true)
        
        // 待ち時間3.5秒
        let wait = SKAction.wait(forDuration: 3.5)
        // 待ち時間3秒
        let wait1 = SKAction.wait(forDuration: 3.0)
        // 待ち時間2秒
        let wait2 = SKAction.wait(forDuration: 2.0)
        
        // サウンドを削除
        let deleteSound = SKAction.removeFromParent()
        
        // 待ち→パチパチ→待ち→パチパチ→待ち...
        let PPSound = SKAction.repeatForever(SKAction.sequence([wait,wait1,s1,wait1,s1,wait2,s1,s1,wait2,s1,s1,wait2,s1,s2,s2,s2,s2,deleteSound]))
        
        sound2.run(PPSound)

        //サウンドを追加する
        addChild(sound2)

    }
    
//加速度センサーのローパスフィルター
    func lowpassFilter(acceleration: CMAcceleration){
        //EMA(指数移動平均）フィルター　　St = α * Yt-1 + (1 -α) * St-1
        //St：t時点でのEMA,α：平滑化係数,Yt-1：１つ前のデータ,St-1：１つ前のEMA
        acceleX = Alpha * acceleration.x + acceleX * (1.0 - Alpha);
        acceleY = Alpha * acceleration.y + acceleY * (1.0 - Alpha);
        acceleZ = Alpha * acceleration.z + acceleZ * (1.0 - Alpha);
        
    //加速度センサーの判定
        //acceleXが0.01より大きかったら、加速度センサーを止め、重力を発生させる
        if acceleX > 0.01 {
            motionManager.stopAccelerometerUpdates()    //加速度センサーをストップ
            fireBall.physicsBody = SKPhysicsBody(circleOfRadius: fireBall.size.height / 2)  //重力を発生
            print("右に傾きました")
        //でなければ何もしない
        }else{
            print("正常です")
        }
        //acceleXが-0.1より小さかったら、加速度センサーを止め、重力を発生させる
        if acceleX < -0.1 {
            motionManager.stopAccelerometerUpdates()    //加速度センサーをストップ
            fireBall.physicsBody = SKPhysicsBody(circleOfRadius: fireBall.size.height / 2) //重力を発生
            print("左に傾きました")
        //でなければ何もしない
        }else{
            print("正常です")
        }
        //acceleZが0.01より大きかったら、加速度センサーを止め、重力を発生させる
        if acceleZ > 0.01{
            motionManager.stopAccelerometerUpdates()    //加速度センサーをストップ
            fireBall.physicsBody = SKPhysicsBody(circleOfRadius: fireBall.size.height / 2) //重力を発生
            print("前に傾きました")
        //でなければ何もしない
        }else{
            print("正常です")
        }
        //acceleZが-0.1よりZ小さかったら、加速度センサーを止め、重力を発生させる
        if acceleZ < -0.1{
            motionManager.stopAccelerometerUpdates()    //加速度センサーをストップ
            fireBall.physicsBody = SKPhysicsBody(circleOfRadius: fireBall.size.height / 2) //重力を発生
            print("後ろに傾きました")
        //でなければ何もしない
        }else{
            print("正常です")
        }
        // 衝突のカテゴリー設定
        fireBall.physicsBody?.categoryBitMask = FireBallCategory        //自分が属するカテゴリ値
        fireBall.physicsBody?.collisionBitMask = 0          //跳ね返りを防止(この値とぶつかってくる相手のcategoryBitMaskの値とをAND算出結果が1で衝突する)
        fireBall.physicsBody?.contactTestBitMask = groundCategory         //物体と衝突した時に、通知として送る値
    }
    
//棒の部分
    func setupStick() {
        // 棒の画像を読み込む
        let stickTexture = SKTexture(imageNamed: "stick")
        //.nearest・・・画像が荒くなるが処理が速い   .linear・・・画像がきれいだが処理が遅い
        stickTexture.filteringMode = .nearest
        
        // テクスチャを指定してスプライトを作成する
        let stickSprite = SKSpriteNode(texture: stickTexture)
        
        // スプライトの表示する位置を指定する
        stickSprite.position = CGPoint(
            x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.7
        )
        
        // シーンにスプライトを追加する
        addChild(stickSprite)
    }
//OPアニメ
    func setupOpening() {
        // OPの画像を読み込む
        let OP1 = SKTexture(imageNamed: "OP1")
        OP1.filteringMode = .nearest
        let OP2 = SKTexture(imageNamed: "OP2")
        OP2.filteringMode = .nearest
        let OP3 = SKTexture(imageNamed: "OP3")
        OP3.filteringMode = .nearest
        let OP4 = SKTexture(imageNamed: "OP4")
        OP4.filteringMode = .nearest
        let OP5 = SKTexture(imageNamed: "OP5")
        OP5.filteringMode = .nearest
        let OP6 = SKTexture(imageNamed: "OP6")
        OP6.filteringMode = .nearest
        let OP7 = SKTexture(imageNamed: "OP7")
        OP7.filteringMode = .nearest
        let OP8 = SKTexture(imageNamed: "OP8")
        OP8.filteringMode = .nearest
        let OP9 = SKTexture(imageNamed: "OP9")
        OP9.filteringMode = .nearest
        let OP10 = SKTexture(imageNamed: "OP10")
        OP10.filteringMode = .nearest
        let OP11 = SKTexture(imageNamed: "OP11")
        OP11.filteringMode = .nearest
        let OP12 = SKTexture(imageNamed: "OP12")
        OP12.filteringMode = .nearest
        let OP13 = SKTexture(imageNamed: "OP13")
        OP13.filteringMode = .nearest
        let OP14 = SKTexture(imageNamed: "OP14")
        OP14.filteringMode = .nearest
        let OP15 = SKTexture(imageNamed: "OP15")
        OP15.filteringMode = .nearest
        let OP16 = SKTexture(imageNamed: "OP16")
        OP16.filteringMode = .nearest
        let OP17 = SKTexture(imageNamed: "OP17")
        OP17.filteringMode = .nearest
        let OP18 = SKTexture(imageNamed: "OP18")
        OP18.filteringMode = .nearest
        let OP19 = SKTexture(imageNamed: "OP19")
        OP19.filteringMode = .nearest
        let OP20 = SKTexture(imageNamed: "OP20")
        OP20.filteringMode = .nearest
        let OP21 = SKTexture(imageNamed: "OP21")
        OP21.filteringMode = .nearest
        let OP22 = SKTexture(imageNamed: "OP22")
        OP22.filteringMode = .nearest
        let OP23 = SKTexture(imageNamed: "OP23")
        OP23.filteringMode = .nearest
        let OP24 = SKTexture(imageNamed: "OP24")
        OP24.filteringMode = .nearest
        
        //画像を表示
        let op1 = SKAction.animate(with: [OP1], timePerFrame: 0.5) //OP1（0.5秒）
        let op2 = SKAction.animate(with: [OP2], timePerFrame: 0.1) //OP2（0.1秒）
        let op3 = SKAction.animate(with: [OP3], timePerFrame: 0.1) //OP3（0.1秒）
        let op4 = SKAction.animate(with: [OP4], timePerFrame: 0.1) //OP4（0.1秒）
        let op5 = SKAction.animate(with: [OP5], timePerFrame: 0.1) //OP5（0.1秒）
        let op6 = SKAction.animate(with: [OP6], timePerFrame: 0.1) //OP6（0.1秒）
        let op7 = SKAction.animate(with: [OP7], timePerFrame: 0.1) //OP7（0.1秒）
        let op8 = SKAction.animate(with: [OP8], timePerFrame: 0.1) //OP8（0.1秒）
        let op9 = SKAction.animate(with: [OP9], timePerFrame: 0.1) //OP9（0.1秒）
        let op10 = SKAction.animate(with: [OP10], timePerFrame: 0.1) //OP10（0.1秒）
        let op11 = SKAction.animate(with: [OP11], timePerFrame: 0.1) //OP11（0.1秒）
        let op12 = SKAction.animate(with: [OP12], timePerFrame: 0.1) //OP12（0.1秒）
        let op13 = SKAction.animate(with: [OP13], timePerFrame: 0.1) //OP13（0.1秒）
        let op14 = SKAction.animate(with: [OP14], timePerFrame: 0.1) //OP14（0.1秒）
        let op15 = SKAction.animate(with: [OP15], timePerFrame: 0.1) //OP15（0.1秒）
        let op16 = SKAction.animate(with: [OP16], timePerFrame: 0.1) //OP16（0.1秒）
        let op17 = SKAction.animate(with: [OP17], timePerFrame: 0.1) //OP17（0.1秒）
        let op18 = SKAction.animate(with: [OP18], timePerFrame: 0.1) //OP18（0.1秒）
        let op19 = SKAction.animate(with: [OP19], timePerFrame: 0.1) //OP19（0.1秒）
        let op20 = SKAction.animate(with: [OP20], timePerFrame: 0.1) //OP20（0.1秒）
        let op21 = SKAction.animate(with: [OP21], timePerFrame: 0.1) //OP21（0.1秒）
        let op22 = SKAction.animate(with: [OP22], timePerFrame: 0.3) //OP22（0.3秒）
        let op23 = SKAction.animate(with: [OP23], timePerFrame: 0.1) //OP23（0.1秒）
        let op24 = SKAction.animate(with: [OP24], timePerFrame: 0.1) //OP24（0.1秒）

        // OPを削除
        let delete = SKAction.removeFromParent()
        
        let startMotionSensor = SKAction.run {
            //加速度センサー
            if self.motionManager.isAccelerometerAvailable {
                // センサーの更新間隔（interval）の設定 [sec]
                self.motionManager.accelerometerUpdateInterval = 0.2
                
                // センサー値の取得開始
                self.motionManager.startAccelerometerUpdates(
                    to: OperationQueue.current!,
                    withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                        self.lowpassFilter(acceleration: accelData!.acceleration)
                })
                print("センサーが作動しました")
            }
        }
        
        //アニメーション
        let OPAnimation = SKAction.repeatForever(SKAction.sequence([
            op1,op2,op3,op4,op5,op6,op7,op8,op9,op10,op11,op12,op13,op14,op15,op16,op17,
            op18,op19,op20,op21,op22,op23,op22,op24,op22,op23,op22,op24,delete,startMotionSensor
            ]))
        
        // スプライトを作成(配置)
        opening = SKSpriteNode(texture: OP1)
        opening.position = CGPoint(x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.44)
        
        // アニメーションを設定
        opening.run(OPAnimation)
        
        // スプライトを追加する
        addChild(opening)
 
    }
    
//火玉
   func setupFireBall() {
        // 火玉の画像を2種類読み込む
        let fireTextureA = SKTexture(imageNamed: "fireBall")
        fireTextureA.filteringMode = .nearest
        let fireTextureB = SKTexture(imageNamed: "fireBall2")
        fireTextureB.filteringMode = .nearest
        let Texture = SKTexture(imageNamed: "m")
        Texture.filteringMode = .nearest
    
        // 2種類のテクスチャを交互に変更するアニメーションを作成
        let texuresAnimation = SKAction.animate(with: [fireTextureA, fireTextureB], timePerFrame: 0.2, resize: true, restore: false)
        let flap = SKAction.repeatForever(texuresAnimation)

        // 待ち時間3.5秒
        let waitAnimation1 = SKAction.animate(with: [Texture], timePerFrame: 3.5)
    
        // 縮小までの待ち時間40秒
        let waitAnimation2 = SKAction.wait(forDuration: 40.0)
    
        //2秒かけて1/2に縮小する
        let action = SKAction.scale(to: 1/2,duration: 2.0)
        //3秒かけてフェードアウトする
        let action2 = SKAction.fadeOut(withDuration: 3.0)
        // 火玉を削除
        let delete = SKAction.removeFromParent()
    
    let Animation = SKAction.sequence([
        waitAnimation1,flap
        ])
    let Animation2 = SKAction.sequence([
        waitAnimation2,action,action2,delete
        ])
    let groupAction = SKAction.group([
        Animation,Animation2
        ])
        // スプライトを作成(配置)
        fireBall = SKSpriteNode(texture: fireTextureA)
        fireBall.position = CGPoint(x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.45)
    
        // 衝突のカテゴリー設定
        fireBall.physicsBody?.categoryBitMask = FireBallCategory        //自分が属するカテゴリ値
        fireBall.physicsBody?.contactTestBitMask = groundCategory       //物体と衝突した時に、通知として送る値

        // アニメーションを設定
        fireBall.run(groupAction)
        // スプライトを追加する
        addChild(fireBall)
    }


//パチパチ
    func setupPatipati() {
    
        //パチパチの画像を取り込む
        let PatiPatiTexture1 = SKTexture(imageNamed: "PatiPati-1")
        PatiPatiTexture1.filteringMode = .nearest
        let PatiPatiTexture2 = SKTexture(imageNamed: "PatiPati-2")
        PatiPatiTexture2.filteringMode = .nearest
        let PatiPatiTexture3 = SKTexture(imageNamed: "PatiPati-3")
        PatiPatiTexture3.filteringMode = .nearest
        let PatiPatiTexture4 = SKTexture(imageNamed: "PatiPati-4")
        PatiPatiTexture4.filteringMode = .nearest
        let PatiPatiTexture5 = SKTexture(imageNamed: "PatiPati-5")
        PatiPatiTexture5.filteringMode = .nearest
        let PatiPatiTexture6 = SKTexture(imageNamed: "PatiPati-6")
        PatiPatiTexture6.filteringMode = .nearest
        let PatiPatiTexture7 = SKTexture(imageNamed: "PatiPati-7")
        PatiPatiTexture7.filteringMode = .nearest
        let PatiPatiTexture8 = SKTexture(imageNamed: "PatiPati-8")
        PatiPatiTexture8.filteringMode = .nearest
        let PatiPatiTexture9 = SKTexture(imageNamed: "PatiPati-9")
        PatiPatiTexture9.filteringMode = .nearest
        let PatiPatiTexture10 = SKTexture(imageNamed: "PatiPati-10")
        PatiPatiTexture10.filteringMode = .nearest
        let PatiPatiTexture11 = SKTexture(imageNamed: "PatiPati-11")
        PatiPatiTexture11.filteringMode = .nearest
        let PatiPatiTexture12 = SKTexture(imageNamed: "PatiPati-12")
        PatiPatiTexture12.filteringMode = .nearest
        let PatiPatiTexture13 = SKTexture(imageNamed: "Pati-1")
        PatiPatiTexture13.filteringMode = .nearest
        let PatiPatiTexture14 = SKTexture(imageNamed: "Pati-2")
        PatiPatiTexture14.filteringMode = .nearest
        let PatiPatiTexture15 = SKTexture(imageNamed: "Pati-3")
        PatiPatiTexture15.filteringMode = .nearest
        let PatiPatiTexture16 = SKTexture(imageNamed: "Pati-4")
        PatiPatiTexture16.filteringMode = .nearest
        let Texture = SKTexture(imageNamed: "m")
        Texture.filteringMode = .nearest
        
        // 待ち時間3.5秒
        let wait = SKAction.animate(with: [Texture], timePerFrame: 3.5)
        // 待ち時間3秒
        let m = SKAction.animate(with: [Texture], timePerFrame: 3.0)
        // 待ち時間2秒
        let m2 = SKAction.animate(with: [Texture], timePerFrame: 2.0)
        // 待ち時間0.2秒
        let m3 = SKAction.animate(with: [Texture], timePerFrame: 0.2)
        
        //パチパチを表示
        let pp1 = SKAction.animate(with: [PatiPatiTexture1], timePerFrame: 0.1) //パチパチ1（0.1秒）
        let pp2 = SKAction.animate(with: [PatiPatiTexture2], timePerFrame: 0.1) //パチパチ2（0.1秒）
        let pp3 = SKAction.animate(with: [PatiPatiTexture3], timePerFrame: 0.1) //パチパチ3（0.1秒）
        let pp4 = SKAction.animate(with: [PatiPatiTexture4], timePerFrame: 0.1) //パチパチ4（0.1秒）
        let pp5 = SKAction.animate(with: [PatiPatiTexture5], timePerFrame: 0.1) //パチパチ5（0.1秒）
        let pp6 = SKAction.animate(with: [PatiPatiTexture6], timePerFrame: 0.1) //パチパチ6（0.1秒）
        let pp7 = SKAction.animate(with: [PatiPatiTexture7], timePerFrame: 0.1) //パチパチ7（0.1秒）
        let pp8 = SKAction.animate(with: [PatiPatiTexture8], timePerFrame: 0.1) //パチパチ8（0.1秒）
        let pp9 = SKAction.animate(with: [PatiPatiTexture9], timePerFrame: 0.1) //パチパチ9（0.1秒）
        let pp10 = SKAction.animate(with: [PatiPatiTexture10], timePerFrame: 0.1) //パチパチ10（0.1秒）
        let pp11 = SKAction.animate(with: [PatiPatiTexture11], timePerFrame: 0.1) //パチパチ11（0.1秒）
        let pp12 = SKAction.animate(with: [PatiPatiTexture12], timePerFrame: 0.1) //パチパチ12（0.1秒）
        let pp13 = SKAction.animate(with: [PatiPatiTexture13], timePerFrame: 0.1) //パチパチ13（0.1秒）
        let pp14 = SKAction.animate(with: [PatiPatiTexture14], timePerFrame: 0.1) //パチパチ14（0.1秒）
        let pp15 = SKAction.animate(with: [PatiPatiTexture15], timePerFrame: 0.1) //パチパチ15（0.1秒）
        let pp16 = SKAction.animate(with: [PatiPatiTexture16], timePerFrame: 0.1) //パチパチ16（0.1秒）
        
        // パチパチを削除
        let delete = SKAction.removeFromParent()
        
        // 待ち→パチパチ→待ち→パチパチ→待ち...
        let PPAnimation = SKAction.repeatForever(SKAction.sequence([wait,m,pp1,m,pp4,m2,pp3,pp4,m2,pp5,pp6,m2,pp1,pp7,pp8,pp2,pp9,pp1,pp3,pp5,pp10,pp4,pp11,pp12,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,pp1,pp3,pp5,pp10,pp4,pp11,pp1,pp7,pp8,pp2,pp9,pp1,pp3,pp5,pp10,pp4,pp11,pp12,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,pp12,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,pp1,pp3,pp5,pp10,pp4,pp11,pp1,pp7,pp8,pp2,pp9,pp1,pp3,pp5,pp10,pp4,pp11,pp12,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,pp12,pp1,pp7,pp8,pp2,pp9,pp1,pp3,pp5,pp10,pp4,pp11,pp12,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,pp1,pp3,pp5,pp4,pp11,pp3,pp1,pp7,pp8,pp10,pp4,pp11,pp12,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,pp2,pp9,pp1,pp3,pp5,pp10,pp4,pp11,pp12,pp3,pp5,pp6,pp1,pp7,pp8,pp2,pp9,m3,pp13,pp15,pp16,m3,pp14,pp16,m3,pp13,pp14,m3,pp13,pp13,pp15,pp16,m3,pp14,pp16,m3,pp13,pp14,m3,pp13,pp13,pp15,pp16,m3,pp14,pp16,m3,pp13,pp14,m3,pp13,pp13,pp15,pp16,m3,pp14,pp16,m3,pp13,pp14,m3,pp13,pp13,delete
            ]))

        // スプライトを作成(配置)
        pati = SKSpriteNode(texture: PatiPatiTexture1)
        pati.position = CGPoint(x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.4)
    
        // アニメーションを設定
        pati.run(PPAnimation)

        // スプライトを追加する
        addChild(pati)
    
    }
    
//パチパチ2
    func setupPatipati2() {

        //パチパチの画像を取り込む
        let PatiPatiTexture1 = SKTexture(imageNamed: "PatiPati-1")
        PatiPatiTexture1.filteringMode = .nearest
        let PatiPatiTexture2 = SKTexture(imageNamed: "PatiPati-2")
        PatiPatiTexture2.filteringMode = .nearest
        let PatiPatiTexture3 = SKTexture(imageNamed: "PatiPati-3")
        PatiPatiTexture3.filteringMode = .nearest
        let PatiPatiTexture4 = SKTexture(imageNamed: "PatiPati-4")
        PatiPatiTexture4.filteringMode = .nearest
        let PatiPatiTexture5 = SKTexture(imageNamed: "PatiPati-5")
        PatiPatiTexture5.filteringMode = .nearest
        let Texture = SKTexture(imageNamed: "m")
        Texture.filteringMode = .nearest

        // 待ち時間3.5秒
        let wait = SKAction.animate(with: [Texture], timePerFrame: 3.5)
        // 待ち時間3秒
        let m = SKAction.animate(with: [Texture], timePerFrame: 13.0)

        //パチパチを表示
        let pp1 = SKAction.animate(with: [PatiPatiTexture1], timePerFrame: 0.1) //パチパチ1（0.1秒）
        let pp2 = SKAction.animate(with: [PatiPatiTexture2], timePerFrame: 0.1) //パチパチ2（0.1秒）
        let pp3 = SKAction.animate(with: [PatiPatiTexture3], timePerFrame: 0.1) //パチパチ3（0.1秒）
        let pp4 = SKAction.animate(with: [PatiPatiTexture4], timePerFrame: 0.1) //パチパチ4（0.1秒）

        //2秒かけてフェードアウトする
        let fadeOut = SKAction.fadeOut(withDuration: 1.0)
        // パチパチ２を削除
        let delete = SKAction.removeFromParent()

        // 待ち→パチパチ→待ち→パチパチ→待ち...
        let PPAnimation = SKAction.repeatForever(SKAction.sequence([wait,m,pp1,pp3,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp1,pp3,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp1,pp3,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp1,pp3,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp1,pp3,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,pp4,pp1,pp2,pp3,pp1,pp2,fadeOut,delete]))

        pati2 = SKSpriteNode(texture: PatiPatiTexture1)
        pati2.position = CGPoint(x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.4)

        // アニメーションを設定
        pati2.run(PPAnimation)

        // スプライトを追加する
        addChild(pati2)
    }
    
//チラチラ
    func setupChirachira() {
        
        //チラチラの画像を取り込む
        let ChiraChira1 = SKTexture(imageNamed: "Pati1")
        ChiraChira1.filteringMode = .nearest
        let ChiraChira2 = SKTexture(imageNamed: "Pati2")
        ChiraChira2.filteringMode = .nearest
        let ChiraChira3 = SKTexture(imageNamed: "Pati3")
        ChiraChira3.filteringMode = .nearest
        let ChiraChira4 = SKTexture(imageNamed: "Pati4")
        ChiraChira4.filteringMode = .nearest
        let ChiraChira5 = SKTexture(imageNamed: "Pati5")
        ChiraChira5.filteringMode = .nearest
        let ChiraChira6 = SKTexture(imageNamed: "Pati6")
        ChiraChira6.filteringMode = .nearest
        let ChiraChira7 = SKTexture(imageNamed: "Pati7")
        ChiraChira7.filteringMode = .nearest
        let ChiraChira8 = SKTexture(imageNamed: "Pati8")
        ChiraChira8.filteringMode = .nearest
        let Texture = SKTexture(imageNamed: "m")
        Texture.filteringMode = .nearest
        
        // 待ち時間3.5秒
        let wait = SKAction.animate(with: [Texture], timePerFrame: 3.5)
        // 待ち時間34.5秒
        let m = SKAction.animate(with: [Texture], timePerFrame: 34.5)
        // チラチラを削除
        let delete = SKAction.removeFromParent()
        
        //チラチラを表示
        let pp1 = SKAction.animate(with: [ChiraChira1], timePerFrame: 0.1) //チラチラ1（0.1秒）
        let pp2 = SKAction.animate(with: [ChiraChira2], timePerFrame: 0.1) //チラチラ2（0.1秒）
        let pp3 = SKAction.animate(with: [ChiraChira3], timePerFrame: 0.2) //チラチラ3（0.1秒）
        let pp4 = SKAction.animate(with: [ChiraChira4], timePerFrame: 0.2) //チラチラ4（0.1秒）
        let pp5 = SKAction.animate(with: [ChiraChira5], timePerFrame: 0.1) //チラチラ5（0.1秒）
        let pp6 = SKAction.animate(with: [ChiraChira6], timePerFrame: 0.1) //チラチラ6（0.1秒）
        let pp7 = SKAction.animate(with: [ChiraChira7], timePerFrame: 0.2) //チラチラ7（0.1秒）
        let pp8 = SKAction.animate(with: [ChiraChira8], timePerFrame: 0.2) //チラチラ8（0.1秒）
        
        // 待ち→チラチラ→待ち→チラチラ→待ち...
        let PPAnimation = SKAction.repeatForever(SKAction.sequence([wait,m,pp1,pp3,pp4,pp1,pp2,pp5,pp1,pp6,pp4,pp1,pp2,pp7,pp1,pp4,pp8,pp1,pp2,pp3,pp1,delete]))
        
        chirachira = SKSpriteNode(texture: ChiraChira1)
        chirachira.position = CGPoint(x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.45)
        
        // アニメーションを設定
        chirachira.run(PPAnimation)
    
        // スプライトを追加する
        addChild(chirachira)
    }
    
//見えざる地面
    func setupGround() {
        
        // 見えざる地面のノード
        let GroundNode = SKNode()
        
        //スプライトの表示する位置を指定する
        GroundNode.position = CGPoint(x: self.frame.size.width * 0.5,y: self.frame.size.height * 0.3)
        
        // スプライトに物理演算を設定する
        GroundNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width, height: self.frame.size.height/3))
        GroundNode.physicsBody?.isDynamic = false
        GroundNode.physicsBody?.categoryBitMask = self.groundCategory
        GroundNode.physicsBody?.contactTestBitMask = self.FireBallCategory
        
        // 衝突の時に動かないように設定する
        GroundNode.physicsBody?.isDynamic = false
        
        addChild(GroundNode)
    }
    
// SKPhysicsContactDelegateのメソッド。衝突したときに呼ばれる
    func didBegin(_ contact: SKPhysicsContact) {
        
        // もし見えざる地面と衝突したら、
        if (contact.bodyA.categoryBitMask & groundCategory) == groundCategory || (contact.bodyB.categoryBitMask & groundCategory) == groundCategory {
            
            // サウンドを削除する
            let deleteSound = SKAction.removeFromParent()
            sound.run(deleteSound)
            let deleteSound2 = SKAction.removeFromParent()
            sound2.run(deleteSound2) 
            print("サウンド削除")
            
            // パチパチを削除する
            pati.removeFromParent()
            print("パチパチ削除")
            
            // パチパチ2を削除する
            pati2.removeFromParent()
            
            //チラチラを削除する
            chirachira.removeFromParent()
          
        }
    }
    
}
