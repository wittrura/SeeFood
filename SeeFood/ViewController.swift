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
            
            //convert UIImage to CIImage (core image) to be used by Vision and Core ML
            guard let ciImage = CIImage(image: userSelectedImage) else {
                fatalError("Could not convert UIImage to CIImage")
            }
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) -> Void {
        //attemp to load CoreML Model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            //check in results for first item aka highest confidence interval VNClassificationObservation
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog! \(firstResult.confidence)"
                } else {
                    self.navigationItem.title = "Not Hotdog! (probably a \(firstResult.identifier)"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //display image that was taken by the user
        present(imagePicker, animated: true, completion: nil)
    }
    
}

