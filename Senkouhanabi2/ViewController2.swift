import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var difficultButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //むずかいしいボタンのスタイル
        difficultButton.backgroundColor = UIColor.green // 背景色
        difficultButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        //ふつうボタンのスタイル
        normalButton.backgroundColor = UIColor.green // 背景色
        normalButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
        //かんたんボタンのスタイル
        easyButton.backgroundColor = UIColor.green // 背景色
        easyButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        
    }
    
    @IBAction func difficultButton(_ sender: Any) {
        performSegue(withIdentifier: "nextViewController", sender: nil)
    }
    
    @IBAction func normalButton(_ sender: Any) {
        performSegue(withIdentifier: "viewController3", sender: nil)
    }
    @IBAction func easyButton(_ sender: Any) {        performSegue(withIdentifier: "viewController4", sender: nil)      
        
    }
}
