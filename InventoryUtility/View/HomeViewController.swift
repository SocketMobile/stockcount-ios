//
//  HomeViewController.swift
//  InventoryUtility
//
//  Created by IT Star on 12/24/17.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import UIKit
import RealmSwift

class HomeViewCell : UITableViewCell {
    @IBOutlet weak var lblFileTitle: UILabel!
    @IBOutlet weak var lblFirstScan: UILabel!
    
    func showData(itemData : RMFile?) {
        lblFileTitle.text = itemData?.fileTitle
        lblFirstScan.text = itemData?.firstScan
    }
    
}

class HomeViewController: CustomNavBarViewController, UITableViewDataSource, UITableViewDelegate{
    var realmResult : Results<RMFile>?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let realm = try! Realm()
        realmResult = realm.objects(RMFile.self).sorted(byKeyPath: "updatedTime", ascending: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Init NavigationBar
    override func initNavBarItems() {
        super.initNavBarItems()
        
        if let newBtn = createBarButtonFromImage("NavBar_New", target: self, action: #selector(self.onBtnNew)) {
            self.navigationItem.rightBarButtonItem = newBtn
        }
        
        if let optionBtn = createBarButtonFromImage("NavBar_Option", target: self, action: #selector(self.onBtnOption)) {
            self.navigationItem.leftBarButtonItem = optionBtn
        }
    }
    
    @objc func onBtnNew(){
        if let fileName = FileMgr.createFile() {
            performSegue(withIdentifier: "SEGUE_EditViewController", sender: fileName)
        }
    }
    
    @objc func onBtnOption(){
        performSegue(withIdentifier: "SEGUE_OptionViewController", sender: nil)
    }
    
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL_ITEM") as! HomeViewCell
        
        cell.showData(itemData: realmResult?[indexPath.row])
        
        return cell
    }
    
    //MARK: - TableView Event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let fileName = realmResult?[indexPath.row].fileName {
            performSegue(withIdentifier: "SEGUE_EditViewController", sender: fileName)
        }
    }
    
    //MARK: - Create New
    /*@IBAction func onBtnNew(_ sender: Any) {
        if let fileName = FileMgr.createFile() {
            performSegue(withIdentifier: "SEGUE_EditViewController", sender: fileName)
        }
    }*/
    
    //MARK: - Page Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let fileName = sender as? String, segue.identifier == "SEGUE_EditViewController" {
            if let destController = segue.destination as? EditViewController {
                destController.fileName = fileName
            }
        }
    }
    
    

}

