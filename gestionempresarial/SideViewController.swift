//
//  SideMenuController.swift
//  ExampleSideMenu
//
//  Created by Zahedul Alam on 9/1/16.
//  Copyright © 2016 inov.io. All rights reserved.
//

import UIKit
import Firebase

enum LeftMenu: Int {
    case main = 0
    case profile
    case notification
    case share
    case login
    
}

protocol LeftMenuProtocol: class {
    func changeViewController(_ menu: LeftMenu)
}

class SideViewController: UIViewController, LeftMenuProtocol {
    var imgview = UIImageView()
    var tableView = UITableView()
    var menus = ["Indicadores Externos", "Indicadores Internos","Envio de correos electrónicos","Shared Files","Logout"]
    var images = ["external.png","internal.png","notification.png","share.png","logout.png"]
    var mainViewController: UIViewController!
    var profileViewController: UIViewController!
    var loginViewController: UIViewController!
    var noficationViewController : UIViewController!
    var shareViewController : UIViewController!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewSize:CGSize = self.view.frame.size;
        self.imgview.frame = CGRect(x: 0, y: 0, width: 270, height: 135)
        self.imgview.backgroundColor = UIColor.green
        self.imgview.image = UIImage(named: "logo_s1.png")
        self.view.addSubview(imgview)
        self.tableView.frame = CGRect(x: 0, y: 135, width: 270, height: viewSize.height-135)
        self.tableView.separatorColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.backgroundColor=UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        self.tableView.delegate = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewViewController = storyboard.instantiateViewController(withIdentifier: "MainView") as! MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewViewController)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "SecView") as! SecViewController
        self.profileViewController = UINavigationController(rootViewController: profileViewController)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginView") as! ViewController
        self.loginViewController = UINavigationController(rootViewController: loginViewController)
        let notificationViewController = storyboard.instantiateViewController(withIdentifier: "notification") as! notificationViewController
        self.noficationViewController = UINavigationController(rootViewController: notificationViewController)
        let shareViewController = storyboard.instantiateViewController(withIdentifier: "share") as! shareViewcontroller
        self.shareViewController = UINavigationController(rootViewController: shareViewController)
        self.tableView.registerCellClass(BaseTableViewCell.self)
        self.view.addSubview(self.tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func changeViewController(_ menu: LeftMenu) {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "loginView") as! ViewController
        self.loginViewController = UINavigationController(rootViewController: loginViewController)
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .profile:
            self.slideMenuController()?.changeMainViewController(self.profileViewController, close: true)
        case .notification:
            self.slideMenuController()?.changeMainViewController(self.noficationViewController, close: true)
        case .share:
            self.slideMenuController()?.changeMainViewController(self.shareViewController, close: true)
        case .login:
            
            if FIRAuth.auth()?.currentUser != nil {
                do {
                    try FIRAuth.auth()?.signOut()
                    self.slideMenuController()?.changeMainViewController(self.loginViewController, close: true)
                    print("logout successs!!!!")                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }

        }
    }
}

extension SideViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .main, .profile, .notification,.share, .login :
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
}

extension SideViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(menus.count)
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .main, .profile, .notification,.share,.login:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row],images[indexPath.row])
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
}



public extension UITableView {
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
