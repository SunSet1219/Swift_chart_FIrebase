//
//  ViewController.swift
//  gestionempresarial
//
//  Created by admin on 13/04/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        view.backgroundColor = UIColor(red: 25/255, green: 46/255, blue: 66/255, alpha: 1)
       self.emailField.delegate=self
        self.passwordField.delegate=self
        
        FIRMessaging.messaging().subscribe(toTopic: "news")
    }

    func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginAction(_ sender: Any) {
        //FIRMessaging.messaging().subscribe(toTopic: "news")
        
        if self.emailField.text == "" || self.passwordField.text == ""
        {
            let alertCtrl = UIAlertController(title: "Alert", message: "Please Insert Email and Password.", preferredStyle: UIAlertControllerStyle.alert )
            
            // create button action
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            // add action to controller
            alertCtrl.addAction(okAction)
            alertCtrl.addAction(cancelAction)
            
            // show alert
            self.present(alertCtrl, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {(user,error) in
                if error == nil
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainView")
                    
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                else{
                    let alertCtrl = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert )
                    
                    // create button action
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                    
                    
                    // add action to controller
                    alertCtrl.addAction(okAction)
                    
                    
                    // show alert
                    self.present(alertCtrl, animated: true, completion: nil)
                }
            })
        }
 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        self.scrollview.contentOffset = .zero
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.scrollview.contentOffset = CGPoint(x:0, y:50)
    }
    

}

