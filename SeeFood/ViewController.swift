//
//  ViewController.swift
//  SeeFood
//
//  Created by Ryan Wittrup on 12/3/17.
//  Copyright © 2017 Ryan Wittrup. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set imagePicker delegate as current class, getting data from camera and disabling editing
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //acess image user has selected, use optional binding with downcasting
        if let userSelectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //set image view in the background of the app to the image that was selected
            imageView.image = userSelectedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //display image that was taken by the user
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

