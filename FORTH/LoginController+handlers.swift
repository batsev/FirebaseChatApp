//
//  LoginController+handlers.swift
//  FORTH
//
//  Created by Никита Бацев on 09.05.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit
import Firebase


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleRegister(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let name = nameTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error != nil {return}
            guard let uid = user?.uid else {return}
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {return}
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {return}
                        if let profileImageUrl = url?.absoluteString{
                            let values = ["name" : name, "email": email,"profileImageURL": profileImageUrl]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                        }
                    })
                    
                })
            }
            
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: String]){
        let ref = Database.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                return
            }
            let user = MyUser()
            user.name = values["name"]
            user.email = values["email"]
            user.profileImageURL = values["profileImageURL"]
            self.messagesController?.setupNavBarWithUser(user: user)
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    
    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
