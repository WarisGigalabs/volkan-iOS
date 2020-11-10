//
//  Extensions.swift
//  Assignment
//
//  Created by Waris on 11/6/20.
//

import UIKit


// MARK: - UITableViewCell -
extension UITableViewCell {
    
    func removeSeparatorInsets() {
        
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }
}

// MARK: - NSAttributedString -
extension NSAttributedString {
    
    convenience init(_ part1: String,
                     font1: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold),
                     color1: UIColor = UIColor.black,
                     part2: String? = nil,
                     font2: UIFont = UIFont.systemFont(ofSize: 14.0),
                     color2: UIColor = UIColor.gray) {
        
        let completeString = (part2 != nil ? part1 + " " + part2! : part1) as NSString
        
        let part1Range = completeString.range(of: part1)
        let part2Range = completeString.range(of: part2 ?? "")
        
        let attributedString = NSMutableAttributedString(string: completeString as String)
        attributedString.addAttributes([.foregroundColor: color1, .font: font1], range: part1Range)
        
        if part2 != nil && part2Range.location != NSNotFound {
            attributedString.addAttributes([.foregroundColor: color2, .font: font2], range: part2Range)
        }
        
        self.init(attributedString: attributedString)
    }
}


// MARK: - UIView -
extension UIView {
    
    func roundCorner(_ radius:CGFloat)
    {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func roundedView(_ withBorder: Bool = false)
    {
        self.layer.layoutIfNeeded()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        if withBorder {
            self.addBorder()
        }
    }
    
    func addBorder(_ borderColor: UIColor = UIColor.gray,
                   borderWidth: CGFloat = 0.5) {
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}


// MARK: - UIImageView -
extension UIImageView {
    public func setUserImage(name: String) {
        
        loadImageUsingCache(withUrl: K.kImageBaseURL + "\(name).svg?options[mood][]=happy")
    }
    
    func loadImageUsingCache(withUrl urlString : String) {
        
        let url = URL(string: urlString)
        if url == nil {return}
        
        // check cached image
        let imageCache = NSCache<NSString, UIImage>()
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil { print(error!); return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
            
        }).resume()
    }
}

// MARK: - UIViewController -
extension UIViewController {
    func showErrorAlertView(title: String = "Error", message: String = "", actionHandler:(() -> Void)? = nil) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction) in
            actionHandler?()
        }))
        self.presentAlertView(alertView)
    }
    
    func presentAlertView(_ alertView: UIViewController, completion: (() -> Void)? = nil) {
        
        alertView.modalPresentationStyle = UIModalPresentationStyle.popover
        
        if let popoverController = alertView.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            popoverController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertView, animated: true, completion: completion)
    }
}


// MARK: - UIPopoverPresentationController -
extension UIPopoverPresentationController {
    var dimmingView: UIView? {
        return value(forKey: "_dimmingView") as? UIView
    }
}

// MARK: - String -
extension String {
    public var userImageURL: URL? {
        
        let urlString = K.kImageBaseURL + "\(self).svg?options[mood][]=happy&options[h][]=375&options[w][]=375"
        if let value = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: value) {
            
            return url
        }
        
        return nil
    }
}

// MARK: - UITableView -
public extension UITableView {
    
    func removeCellSeparatorOffset() {
        self.separatorInset = .zero
        
        self.preservesSuperviewLayoutMargins = false
        
        self.layoutMargins = .zero
        
    }
    
    func removeSeperateIndicatorsForEmptyCells() {
        self.tableFooterView = UIView()
    }
}
