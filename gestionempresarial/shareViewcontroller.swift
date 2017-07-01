//
//  shareViewcontroller.swift
//  gestionempresarial
//
//  Created by admin on 09/05/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class shareViewcontroller: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate=self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var uploadImg: UIImageView!

    @IBOutlet weak var listView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    @IBAction func upload(_ sender: Any) {
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.uploadImg.image!) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
//                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                    
//                    let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
//                    
//                    self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
//                }
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadImg.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func uploadBut(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
}
