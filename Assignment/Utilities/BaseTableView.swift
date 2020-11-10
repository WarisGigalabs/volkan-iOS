//
//  BaseTableView.swift
//  Assignment
//
//  Created by Waris on 11/10/20.
//

import UIKit

class BaseTableView: UITableView {
    

    // MARK: - Variables
    lazy var refreshController: UIRefreshControl = {
        let control = UIRefreshControl()
        self.refreshControl = control
        return control
    }()
    
    var longPressCompletion: ((_ indexPath: IndexPath) -> Void)! { didSet { self.addLongPressRecognizer() } }
    
    
    // MARK: - Custom Init
    convenience init() {
        
        self.init(frame: .zero, style: .plain)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        estimatedRowHeight = 44.0
        rowHeight = UITableView.automaticDimension
        
        removeCellSeparatorOffset()
        removeSeperateIndicatorsForEmptyCells()
    }
    
    
    // MARK: - Public Methods
    public func reloadDataWithoutScrolling() {
        
        let contentOffset = self.contentOffset
        self.reloadData()
        self.layoutIfNeeded()
        self.setContentOffset(contentOffset, animated: false)
    }

    
    
    // MARK: - Private Methods
    fileprivate func addLongPressRecognizer() {
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(BaseTableView.handleLongPress(_:)))
        
        longTapGesture.minimumPressDuration = 1.0
        
        self.addGestureRecognizer(longTapGesture)
    }
    
    @objc fileprivate func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            let point = gestureRecognizer.location(in: self)
            
            if let indexes = self.indexPathForRow(at: point) {
                if longPressCompletion != nil {
                    self.longPressCompletion(indexes)
                }
                
            }
        }
    }
}
