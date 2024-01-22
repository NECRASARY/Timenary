//
//  regisVC.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 1/12/2565 BE.
//

import UIKit
import GRDB

class regisVC: UIViewController {
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtRepass: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtMemname: UITextField!
    @IBOutlet weak var txtMemid: UITextField!
    
    @IBOutlet weak var btnRegistOutlet: UIButton!
    
    @IBOutlet weak var imgSecond: UIImageView!
    
    @IBOutlet weak var viewStroke4Tutorial: UIView!
    
    var animationImages:[UIImage] = [
        UIImage(named: "Tutorial 1.jpg")!,
        UIImage(named: "Tutorial 2.jpg")!,
        UIImage(named: "Tutorial 3.jpg")!,
        UIImage(named: "Tutorial 4.jpg")!,
        UIImage(named: "Tutorial 5.jpg")!,
        UIImage(named: "Tutorial 6.jpg")!
        ]
    
    @objc func tap(sender: UITapGestureRecognizer){
//            print("tapped")
            view.endEditing(true)
    }
    
    @IBAction func txtEmail(_ sender: Any) {
        if (txtEmail.text?.isValidEmail())! == false{
            alertWithTitle(title: "Email Error!", message: "Email Incorrect")
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let Regis2login = storyBoard.instantiateViewController(identifier: "login") as! loginVC
//
//        present(Regis2login , animated: true, completion: nil)
        self.dismiss(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imgSecond.layer.cornerRadius = 15
        btnRegistOutlet.layer.cornerRadius = 15
        self.viewStroke4Tutorial.layer.cornerRadius = 15
        
        self.imgSecond.animationImages = animationImages
        self.imgSecond.animationDuration = 7
        self.imgSecond.animationRepeatCount = 0
        self.imgSecond.startAnimating()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        connect2DB()
        readDB4memberID()
    }

    func alertWithTitle(title: String!, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            if title=="Email Error!"{
                self.txtEmail.becomeFirstResponder()
            }
            else if title=="Member ID Error!"{
                    self.txtMemid.becomeFirstResponder()
            }
            else if title=="Member Name Error!"{
                    self.txtMemname.becomeFirstResponder()
            }
            else if title=="Password Error!"{
                    self.txtPass.becomeFirstResponder()
            }
            else if title=="Repassword Error!"{
                    self.txtPass.becomeFirstResponder()
            }
            else{
                self.txtRepass.becomeFirstResponder()
            }
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    @IBAction func txtRepass(_ sender: Any) {
        if txtPass.text != txtRepass.text{
            alertWithTitle(title: "Repassword Error!", message: "Password doesn't match")
        }
    }
    
    func checkTextfieldisEmpty(){
        if txtMemid.text!.isEmpty {
            alertWithTitle(title: "Member ID Error!", message: "Member ID required")
        }
        else if txtMemname.text!.isEmpty {
            alertWithTitle(title: "Member Name Error!", message: "Member Name Required")
        }
        else if txtPass.text!.isEmpty {
            alertWithTitle(title: "Password Error!", message: "Password Required")
        }
        else if txtRepass.text!.isEmpty {
            alertWithTitle(title: "Repassword Error!", message: "Password doesn't match")
        }
        else if txtEmail.text!.isEmpty {
            alertWithTitle(title: "Email Error!", message: "Email Incorrect")
        }
    }
    
    
    @IBAction func btnRegist(_ sender: Any) {
        checkTextfieldisEmpty()
        var memid:Int = Int(txtMemid.text!)!
        
        do {
            config.readonly=false
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)

            try dbQueue.write {
                db in
                try db.execute(sql: "INSERT INTO register (member_id, member_name,mem_passw,email,active) VALUES (?, ?, ?, ?, ?)",
                               arguments: [memid, txtMemname.text,txtPass.text,txtEmail.text,1])
                } //try dbQueue.write
      
            try dbQueue.write {
                db in
                        
                try db.execute(sql: "update masterctrl set member_id = (?)",
                               arguments: [memid+1])
                } //try dbQueue.write
            
            alertWithTitle(title: "Account Created", message: "Please Log In with your new account")
                   
            } catch {
                    print(error.localizedDescription)
                   }
    }
    
    func readDB4memberID(){
        do {
        let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.inDatabase { db in
                let rows = try Int.fetchOne(db, sql:
                "SELECT member_id FROM masterctrl")
                txtMemid.text=rows?.description
            }
        } catch {
        
            print(error.localizedDescription)
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

} // end class

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
