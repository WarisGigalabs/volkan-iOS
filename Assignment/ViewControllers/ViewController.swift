//
//  ViewController.swift
//  Assignment
//
//  Created by Waris on 11/6/20.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet -
    @IBOutlet weak var tblData: UITableView!
    
    
    
    // MARK: - Variables -
    var usersData: [UserModel] = []
    
    
    // MARK: - UIViewController Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
        self.getUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Methods -
    fileprivate func setupView() {
        
    }
    
    fileprivate func setupTableView() {
        
        self.tblData.rowHeight = UITableView.automaticDimension
        self.tblData.estimatedRowHeight = 180.0
        self.tblData.tableFooterView = UIView()
        
        self.tblData.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
    }
    
    // MARK: - API Methods -
    func getUsers() {
        
        ServicesManager.getUsers { (users) in
            
            self.usersData = users
            self.tblData.reloadData()
            
        } failure: { (error) in
            self.showErrorAlertView(message: error.localizedDescription) {
                
            }
        }

    }
    
    
    // MARK: - Helper Functions -
    
    
    // MARK: - IBActions -
    
    
}

