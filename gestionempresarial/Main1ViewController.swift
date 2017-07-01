//
//  Main1ViewController.swift
//  gestionempresarial
//
//  Created by admin on 13/04/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class Main1ViewController: UIViewController {
    
    var sc1View:UIScrollView!
    let buttonPadding:CGFloat = 10
    var xOffset:CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
//        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
//        sc1View = UIScrollView(frame: CGRect(x: 0, y: 70, width: view.bounds.width, height: 120))
//        view.addSubview(sc1View)
//        sc1View.showsVerticalScrollIndicator = false
//        sc1View.showsHorizontalScrollIndicator=false
//        //scView.backgroundColor = UIColor.blue
//        sc1View.translatesAutoresizingMaskIntoConstraints = false
//        var images = ["ipc.png","cetes.png","cresimiento.png","euros.png","libras.png","inflacion.png","tasa.png","petroleo.png"]
//        for i in 0 ... 7 {
//            let button = UIButton()
//            button.tag = i
//            //button.backgroundColor = UIColor.darkGray
//            button.setImage(UIImage(named: images[i]), for: UIControlState.normal)
//            //button.setTitle("\(i)", for: .normal)
//            //button.addTarget(self, action: #selector(btnTouch), for: UIControlEvents.touchUpInside)
//            
//            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 100, height: 100)
//            
//            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
//            sc1View.addSubview(button)
        
            
//        }
//        
//        sc1View.contentSize = CGSize(width: xOffset, height: sc1View.frame.height)

    }
    @IBAction func Logout(_ sender: Any) {
        
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }
    

   
}
