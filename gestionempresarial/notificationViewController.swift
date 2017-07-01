//
//  notificationViewController.swift
//  gestionempresarial
//
//  Created by admin on 23/04/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase


class notifiTablecell: UITableViewCell {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var bodytxt: UILabel!
    @IBOutlet weak var timelabel: UILabel!
}
class notificationViewController: UITableViewController {
    
    
    var ref: FIRDatabaseReference!
    var messagelist=[Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMessages()
        tableView.backgroundColor=UIColor(red: 25/255, green: 46/255, blue: 66/255, alpha: 1)
        tableView.separatorColor=UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messagelist.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbcell", for: indexPath) as! notifiTablecell
        cell.titlelabel?.text=messagelist[indexPath.row].title
        cell.bodytxt?.text=messagelist[indexPath.row].body        
        
        
        cell.timelabel?.text = messagelist[indexPath.row].time
        
        cell.backgroundColor=UIColor(red: 25/255, green: 46/255, blue: 66/255, alpha: 1)
        cell.textLabel?.textColor=UIColor.white
        return cell
    }
    
    func fetchMessages(){
        ref=FIRDatabase.database().reference()
        self.messagelist=[Message]()
        ref.child("Notification").observe(.childAdded, with: {
            (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                print(dictionary)
                
                let message = Message()
                
                message.setValuesForKeys(dictionary)
                print(message)
                self.messagelist.append(message)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
            }
        })
    }
    
    
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        fetchMessages()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
