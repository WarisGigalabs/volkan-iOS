//
//  UserTableViewCell.swift
//  Assignment
//
//  Created by Waris on 11/6/20.
//

import UIKit
import WebKit

class UserTableViewCell: UITableViewCell {

    // MARK: - IBOutlet -
    @IBOutlet weak var imgUser: WKWebView!
    
    @IBOutlet weak var lblDetail: UILabel!
    
    
    // MARK: - Variables -
    static var reuseIdentifier: String {
        return String(describing: UserTableViewCell.self)
    }
    static var nib: UINib {
        return UINib(nibName: String(describing: UserTableViewCell.self), bundle: nil)
    }
    
    
    // MARK: - UITableViewCell Life Cycle -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgUser.roundedView()
        self.imgUser.addBorder(UIColor.gray, borderWidth: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private Methods -
    
    
    // MARK: - API Methods -
    
    
    // MARK: - Helper Functions -
    func setCell(_ data: UserModel) {
        if let url = data.name.userImageURL {
            
            self.imgUser.load(URLRequest(url: url))
        }
        
        self.lblDetail.attributedText = data.detailUserInfo
    }
    
    
    // MARK: - IBActions -
    
    
}
