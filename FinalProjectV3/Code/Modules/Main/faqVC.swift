//
//  faqVC.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 2/12/2565 BE.
//

import UIKit

class faqVC: UIViewController {
    
    
    @IBOutlet weak var btntaskHaveOutlet: UIButton!
    
    @IBAction func btnBack2(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btntaskHave(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let faq2taskhave = storyBoard.instantiateViewController(identifier: "alltask") as! TBVC2
        
        present(faq2taskhave , animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btntaskHaveOutlet.layer.cornerRadius = 15

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
