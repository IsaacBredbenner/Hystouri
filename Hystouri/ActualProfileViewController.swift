//  SignOutViewController.swift
//  FirebaseAuthentication
//  Created by Anna Dubnoff (student LM) on 2/10/20.
//  Copyright © 2020 Anna Dubnoff (student LM). All rights reserved.
import FirebaseAuth
import UIKit
import FirebaseStorage

class SignOutViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    var imagePicker : UIImagePickerController?
//    @IBOutlet weak var imageView: UIImageView!
//
//    @IBAction func changeImageTouchedUp(_ sender: UIButton) {
//        self.present(imagePicker!, animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        imagePicker?.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            imageView.image = pickedImage
//            uploadProfilePicture(pickedImage) {url in}
//        }
//        imagePicker?.dismiss(animated: true, completion: nil)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imageView.layer.borderWidth = 1
//        imageView.layer.masksToBounds = false
//        imageView.layer.borderColor = UIColor.black.cgColor
//        imageView.layer.cornerRadius = imageView.frame.height/2
//        imageView.clipsToBounds = true
//
//        imagePicker = UIImagePickerController()
//        imagePicker?.allowsEditing = true
//        imagePicker?.sourceType = .photoLibrary
//        imagePicker?.delegate = self
//
//    }
//    func uploadProfilePicture(_ image: UIImage, _ completion: @escaping((_ url:URL?) -> ())){
//
//
//        //get the current user's userid
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//
//        //get a reference to the storage object
//        let storage = Storage.storage().reference().child("user/\(uid)")
//
//        //images must be saved as data objects to convert and compress the image
//        guard let image = imageView?.image, let imageData = image.jpegData(compressionQuality: 0.75) else {return}
//
//        //store the image
//        storage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in
//        }
//    }
}
