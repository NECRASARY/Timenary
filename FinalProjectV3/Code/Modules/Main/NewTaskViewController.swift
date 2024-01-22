//
//  NewTaskViewController.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 6/11/2565 BE.
//

import UIKit
import ViewAnimator
import GRDB

class NewTaskViewController: UIViewController {
    var userName:[String]=[]
    //เรียกใช้จากค่า Session ต้องประกาศใช้ก่อนทุกครั้ง
    var defaults = UserDefaults.standard
    
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    
    // MARK: - outlets
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var nameDescriptionContainerView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbuserName: UILabel!
    
    
    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var txtTaskDesc: UITextField!
    
    @IBOutlet weak var taskHistoryOutlet: UIButton!
    
    
    // MARK: - variables
    var taskViewModel: TaskViewModel!
    
    
    @IBAction func btnTaskHistory(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newTask2History = storyBoard.instantiateViewController(identifier: "history") as! TBVC1
        
        present(newTask2History , animated: true, completion: nil)
    }
    
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskViewModel = TaskViewModel()
//        collectionView.backgroundView = UIImageView.init(image: UIImage(named: "Timer BG.jpg"))
        
        let animation = AnimationType.zoom(scale: 5)
        view.animate(animations: [animation])
        
        //เช็คว่าใคร Log In เข้ามา
        print(defaults.object(forKey: "savedUser") as! [String])
//        รับค่าจาก Session ไว้ในโครงสร้าง Array userName
        userName=defaults.object(forKey: "savedUser") as! [String]
//        ดึงเฉพาะตำแหน่งที่ 1 คือ member_name
        
        print(userName[1])
        lbuserName.text="For K."+userName[1]
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: TaskTypeCollectionViewCell.description(), bundle: .main), forCellWithReuseIdentifier: TaskTypeCollectionViewCell.description())
        
        self.startButton.layer.cornerRadius = 12
        self.taskHistoryOutlet.layer.cornerRadius = 12
        
        self.nameDescriptionContainerView.layer.cornerRadius = 12
        
        [self.hourTextField, self.minuteTextField, self.secondTextField].forEach {
            $0?.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.font : UIFont(name: "Futura-Bold", size: 50)!, NSAttributedString.Key.foregroundColor: UIColor.white])
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(Self.textFieldInputChanged(_:)), for: .editingChanged)
            
            connect2DB()
            
        }
        
        
//        self.taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Task Name", attributes: [NSAttributedString.Key.font : UIFont(name: "LayijiTaMaiTine1", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.55)])
        self.taskNameTextField.addTarget(self, action: #selector(Self.textFieldInputChanged(_:)), for: .editingChanged)
        
//        self.taskDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "Short Description", attributes: [NSAttributedString.Key.font : UIFont(name: "LayijiTaMaiTine1", size: 25)!, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.55)])
        self.taskDescriptionTextField.addTarget(self, action: #selector(Self.textFieldInputChanged(_:)), for: .editingChanged)
        
        self.disableButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Self.viewTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        
        self.taskViewModel.getHours().bind { hours in
            self.hourTextField.text = hours.appendZeros()
        }
        
        self.taskViewModel.getMinutes().bind { minutes in
            self.minuteTextField.text = minutes.appendZeros()
        }
        
        self.taskViewModel.getSeconds().bind { seconds in
            self.secondTextField.text = seconds.appendZeros()
        }
    }
    
    
    // MARK: - Outlets & objc functions
    @IBAction func startButtonPressed(_ sender: Any) {
        guard let timerVC = self.storyboard?.instantiateViewController(withIdentifier: TimerViewController.description()) as? TimerViewController else { return }
        taskViewModel.computeSeconds()
        timerVC.taskViewModel = taskViewModel
        self.present(timerVC, animated: true)
    }
    
    @IBAction func startButtonDB(_ sender: Any) {
        var taskID:String = String(taskNameTextField.text!)
        
        do {
            config.readonly=false
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)

            try dbQueue.write {
                db in
                try db.execute(sql: "INSERT INTO task (taskname,taskdescription,taskhour,taskminute,tasksecond) VALUES (?, ?, ?, ?, ?)",
                               arguments: [taskID,taskDescriptionTextField.text,hourTextField.text,minuteTextField.text,secondTextField.text])
                } //try dbQueue.write
                   
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
    
    
    @IBAction func multiplyButtonPressed(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newtask2Login = storyBoard.instantiateViewController(identifier: "login") as! loginVC
        
        present(newtask2Login , animated: true, completion: nil)
    }
    
    
    @objc func textFieldInputChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if (textField == taskNameTextField) {
            self.taskViewModel.setTaskName(to: text)
            
        } else if (textField == taskDescriptionTextField) {
            self.taskViewModel.setTaskDescription(to: text)
            
        } else if (textField == hourTextField) {
            
            guard let hours = Int(text) else { return }
            self.taskViewModel.setHours(to: hours)
            
        } else if (textField) == minuteTextField {
            
            guard let minutes = Int(text) else { return }
            self.taskViewModel.setMinutes(to: minutes)
            
        } else {
            guard let seconds = Int(text) else { return }
            self.taskViewModel.setSeconds(to: seconds)
        }
     
        if taskViewModel.isTaskValid() {
            // enable button
            enableButton()
        } else {
            // disable button
            disableButton()
        }
        
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - functions
    override class func description() -> String {
        return "NewTaskViewController"
    }
    
    func enableButton() {
        if (self.startButton.isUserInteractionEnabled == false) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 1
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func disableButton() {
        if (self.startButton.isUserInteractionEnabled) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 0.25
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
}


extension NewTaskViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = 2
        
        let currentText: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentText.replacingCharacters(in: range, with: string) as NSString
        
        guard let text = textField.text else { return false }
            
        if (text.count) == 2 && text.starts(with: "0") {
            textField.text?.removeFirst()
            textField.text? += string
            self.textFieldInputChanged(textField)
        }
                
        return newString.length <= maxLenght
    }
}


extension NewTaskViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskViewModel.getTaskType().count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3.75
        let width: CGFloat = collectionView.frame.width
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let adjustWidth = width - (flowLayout.minimumLineSpacing * (columns - 1))
        
        return CGSize(width: adjustWidth / columns, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskTypeCollectionViewCell.description(), for: indexPath) as! TaskTypeCollectionViewCell
        cell.setupCell(taskType: self.taskViewModel.getTaskType()[indexPath.item], isSelected: taskViewModel.getSelectedIndex() == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.taskViewModel.setSelectecIndex(to: indexPath.item)
        self.collectionView.reloadSections(IndexSet(0..<1))
    }
    
    
}
