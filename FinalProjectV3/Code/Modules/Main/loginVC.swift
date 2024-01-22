//
//  loginVC.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 30/11/2565 BE.
//

import UIKit
import GRDB
import ViewAnimator
import FlipLabel

class loginVC: UIViewController {

    @IBOutlet weak var label: FlipLabel!
    @IBOutlet weak var label1: FlipLabel!
    private weak var messageTimer: Timer?
    private var currentMessageIndex = -1
    private var messages = ["ยินดีต้อนรับ","タイムナリー","Welcome"]
    private var messages1 = ["สู่ไทม์นารี่","へようこそ","To Timenary "]
    
    @IBOutlet weak var imgFirst: UIImageView!
    
    @IBOutlet weak var txtPassw: UITextField!
    @IBOutlet weak var txtMemid: UITextField!
    
    @IBOutlet weak var btnLoginOutlet: UIButton!
    
    @IBOutlet weak var btnSignupOutlet: UIButton!
    
    @IBOutlet weak var btnFaqOutlet: UIButton!
    
    var animationImages:[UIImage] = [
        UIImage(named: "Use 1.jpg")!,
        UIImage(named: "Use 2.jpg")!,
        UIImage(named: "Use 3.jpg")!,
        UIImage(named: "Use 4.jpg")!,
        UIImage(named: "Use 5.jpg")!
        ]
    
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    //ใช้เก็บค่า Session พิเศษ รับค่าเป็น Array user
    var defaults = UserDefaults.standard
    var user:[String]=[]
    
    @IBAction func btnSignin(_ sender: Any) {
        print("-------------BEGIN4RECHECK------------")
        readDB4memberID(memid: Int(txtMemid.text!)!, mempass: txtPassw.text!)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil {
           return true
        } else {
           return false
        }
    }
    
    func connect2DB(){
         config.readonly = true
         do{
          dbPath = try fileManager
             .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
             .appendingPathComponent("Account_TaskDBTest8.sqlite")
             .path
             if !fileManager.fileExists(atPath: dbPath) {
                 dbResourcePath = Bundle.main.path(forResource: "Account_TaskDBTest8", ofType: "sqlite")!
                 try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
             }
         }catch{
             print("An error has occured")
         }
       }
    
    func alertWithTitle(title: String!, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
                if title=="ERROR"{
                    self.txtPassw.becomeFirstResponder()
                }
            });
            alert.addAction(action)
            self.present(alert, animated: true, completion:nil)
        }
    
    func readDB4memberID(memid:Int,mempass:String){
        do {

        let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)

            try dbQueue.inDatabase { db in

                //Select all data from the table named tablename residing in SQLite

               let rows = try Row.fetchCursor(db, sql: "SELECT member_id,member_name,mem_passw FROM register where active=1 and member_id = (?) and mem_passw = (?)",
               arguments: [memid,mempass])

                while let row = try rows.next() {
                     if memid == row["member_id"] &&
                            mempass == row["mem_passw"] {
                        //Goto NewTaskViewController
                        alertWithTitle(title: "Welcome Back", message: "Nice to see you again")
                        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let mvc = storyBoard.instantiateViewController(identifier: "MainNC") as! NewTaskViewController
                        user.append(row["member_id"])
                        user.append(row["member_name"])
                        user.append(row["mem_passw"])
                        defaults.set(user, forKey: "savedUser")

                        self.view.window?.rootViewController = mvc
                    }
                    else if memid == row["member_id"] &&
                    mempass != row["mem_passw"] {
                            alertWithTitle(title: "ERROR", message: "Password Incorrect")
                        }
                     else{
                        alertWithTitle(title: "Error", message: "Member ID Incorrect")
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
           }
    }
    
    @IBAction func btnRegist(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let login2Regis = storyBoard.instantiateViewController(identifier: "regis") as! regisVC
        
        present(login2Regis , animated: true, completion: nil)

    }
    
    
    @IBAction func btnFaq(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let login2Faq = storyBoard.instantiateViewController(identifier: "faq") as! faqVC
        
        present(login2Faq , animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLoginOutlet.layer.cornerRadius = 15
        btnSignupOutlet.layer.cornerRadius = 15
        btnFaqOutlet.layer.cornerRadius = 15
        imgFirst.layer.cornerRadius = 15
        
        self.imgFirst.animationImages = animationImages
        self.imgFirst.animationDuration = 20
        self.imgFirst.animationRepeatCount = 0
        self.imgFirst.startAnimating()
        
        let animation = AnimationType.zoom(scale: 20)
        view.animate(animations: [animation])
        
        self.messageTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(switchMessage), userInfo: nil, repeats: true)
        
//        let animation = AnimationType.rotate(angle: 180)
//        view.animate(animations: [animation])

        connect2DB()
    }
    
    @objc private func switchMessage() {
        self.currentMessageIndex = (self.currentMessageIndex + 1) % self.messages.count
        self.currentMessageIndex = (self.currentMessageIndex + 1) % self.messages1.count
        self.label.playFlip(text: self.messages[self.currentMessageIndex])
        self.label1.playFlip(text: self.messages1[self.currentMessageIndex])
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
