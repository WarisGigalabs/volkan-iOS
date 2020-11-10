//
//  ViewController+UITableViewDelegate+UITableViewDataSource.swift
//  Assignment
//
//  Created by Waris on 11/6/20.
//

import UIKit


// MARK: - UITableViewDataSource -
extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        
        cell.setCell(self.usersData[indexPath.row])
        cell.removeSeparatorInsets()
        
        return cell
    }
}


// MARK: - UITableViewDelegate -
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
