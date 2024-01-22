//
//  TBVC1.swift
//  FinalProjectV3
//
//  Created by Thanawat Sriwanlop on 3/12/2565 BE.
//

import UIKit
import GRDB
import TableFlip

class TBVC1: UITableViewController {
    
    var taskName:[String]=[]
    var taskDescription:[String]=[]
    var taskHour:[String]=[]
    var taskMinute:[String]=[]
    var taskSecond:[String]=[]

    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.backgroundView = UIImageView.init(image: UIImage(named: "Timer BG.jpg"))

        self.tableView.rowHeight = 190
        connect2DB()
        readDBTask()
        print(taskName,taskDescription,taskHour,taskMinute,taskSecond)    }

    func readDBTask(){
        do {

        let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)

            try dbQueue.inDatabase { db in
                
                let rows = try Row.fetchCursor(db, sql: "SELECT * FROM task")
                while let row = try rows.next() {
                    taskName.append(row["taskname"])
                    taskDescription.append(row["taskdescription"])
                    taskHour.append(row["taskhour"])
                    taskMinute.append(row["taskminute"])
                    taskSecond.append(row["tasksecond"])

                }
            }
        } catch {
        
            print(error.localizedDescription)
           }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // Left Animation
        let leftAnimation = TableViewAnimation.Cell.left(duration: 2.5)
        self.tableView.animate(animation: leftAnimation, indexPaths: nil, completion: nil)
        
        // Custom Animation
        /*
        let degrees = sin(90.0 * CGFloat.pi/180.0)
        let rotationTransform = CGAffineTransform(rotationAngle: degrees)
        let flipTransform = CGAffineTransform(scaleX: -1, y: -1)
        let customTransform = rotationTransform.concatenating(flipTransform)
        let customAnimation = TableViewAnimation.Cell.custom(duration: 0.6, transform: customTransform, options: .curveEaseInOut)

        self.tableView.animate(animation: customAnimation, completion: nil)
         */
        
        // ปั่น Row
        return taskName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "data", for: indexPath) as! TBVCell1

        // Configure the cell...
        
        cell.backgroundColor = UIColor(hex: "f0f8ff")
        tableView.backgroundColor = UIColor(hex: "f0f8ff")

        cell.lbView1.textColor = UIColor(hex: "0E86D4")
        cell.lbView1.text = taskName[indexPath.row]
        
        cell.lbView2.textColor = UIColor(hex: "68BBE3")
        cell.lbView2.text = taskDescription[indexPath.row]
        
        cell.lbView3.text = taskHour[indexPath.row]
        cell.lbView3.textColor = UIColor(hex: "68BBE3")

        cell.lbView4.text = taskMinute[indexPath.row]
        cell.lbView4.textColor = UIColor(hex: "68BBE3")

        cell.lbView5.text = taskSecond[indexPath.row]
        cell.lbView5.textColor = UIColor(hex: "68BBE3")

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
