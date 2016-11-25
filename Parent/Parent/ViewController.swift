//
//  ViewController.swift
//  Parent
//
//  Created by Young Seok Kim on 11/25/16.
//  Copyright © 2016 TonyKim. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    var machines: [FIRDataSnapshot] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = FIRDatabase.database().reference()
        
        // setup listeners
        addNewMachineListener()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    // MARK: UITableViewDatasource Protocol
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("drawing cell in \(indexPath.row)")
        let cell =  tableView.dequeueReusableCell(withIdentifier: "machineCell", for: indexPath) as! MachineNameCell
        let snapshot = machines[indexPath.row]
        let value = snapshot.value as? NSDictionary
        guard let machineName = value?["machineName"] as? String
            else {
            NSLog("some Error occurred while parsing machine nodes")
            return cell
        }
        cell.machineNameLabel.text = machineName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return machines.count
    }

    
    
    // MARK: UITableViewDelegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMachineDetail" {
            let selectedIndex = self.tableView.indexPathForSelectedRow!.row
            let dest = (segue.destination as! DetailViewController)
            let id = self.machines[selectedIndex].key
            dest.machineRef = self.ref.child("machines").child(id)
            NSLog("reference is handed over : \(id)")
        }
    }

    
    
    // MARK: Firebase
    
    // Listen for new machines added in the Firebase database
    func addNewMachineListener() {
        let machineRef = ref.child("machines")
        machineRef.observe(.childAdded, with: { (snapshot) -> Void in
            NSLog("new child add detectd!")
            self.machines.append(snapshot)
            self.tableView.reloadData()
        })
    }

    
    
    
    
}

