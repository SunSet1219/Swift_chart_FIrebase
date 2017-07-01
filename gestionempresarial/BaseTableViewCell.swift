//
//  BaseTableViewCell.swift
//  ExampleSideMenu
//
//  Created by Zahedul Alam on 9/1/16.
//  Copyright © 2016 inov.io. All rights reserved.
//

import UIKit

open class BaseTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
        print("hello setup")
    }
    
    open class func height() -> CGFloat {
        return 54
    }
    
    open func setData(_ data: Any?,_ data1:Any?) {
        self.backgroundColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        
        self.textLabel?.font = UIFont(name: "Roboto-Regular", size: 12)
        self.textLabel?.textColor = UIColor.black
        
        if let menuText = data as? String {
            self.textLabel?.text = menuText
           
        }
        if let image = data1 as? String {
            self.imageView?.image=UIImage(named: image)
            
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
    
}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
}
