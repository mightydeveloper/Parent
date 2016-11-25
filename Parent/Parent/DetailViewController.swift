//
//  DetailViewController.swift
//  Parent
//
//  Created by Young Seok Kim on 11/26/16.
//  Copyright © 2016 TonyKim. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailViewController: UIViewController {

    
    var machineRef: FIRDatabaseReference!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        machineRef.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func makeLabel(currentIteration current:UInt, totalIterations total:UInt) -> String {
        return "\(current) / \(total)"
    }
    
    func handleSnapshot(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as? NSDictionary
        NSLog("\(value)")
        guard
            let machineName = value?["machineName"] as? String,
            let iterations = value?["iterations"] as? UInt,
            let totaliterations = value?["totaliterations"] as? UInt
            else {
                NSLog("some Error occurred while parsing machine nodes")
                return
        }
        
        self.navigationTitle.title = machineName
        self.progressLabel.text = self.makeLabel(currentIteration: iterations, totalIterations: totaliterations)
        self.progressView.setProgress(Float(iterations)/Float(totaliterations), animated: true)
    }

    func addObserver() {
//        machineRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
//            self.handleSnapshot(snapshot: snapshot)
//        })
        machineRef.observe(.value, with: { (snapshot) -> Void in
            NSLog("change detected")
            self.handleSnapshot(snapshot: snapshot)
        })
    }
    
}
