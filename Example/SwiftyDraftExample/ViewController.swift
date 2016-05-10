//
//  ViewController.swift
//  SwiftyDraftExample
//
//  Created by Atsushi Nagase on 5/2/16.
//  Copyright © 2016 Oneteam Inc. All rights reserved.
//

import UIKit
import SwiftyDraft

class ViewController: UIViewController, UIScrollViewDelegate, SwiftyDraftImagePickerDelegate, SwiftyDraftFilePickerDelegate {

    @IBOutlet var draftView: SwiftyDraft!

    override func viewDidLoad() {
        super.viewDidLoad()
        draftView.scrollViewDelegate = self
        draftView.filePickerDelegate = self
        draftView.imagePickerDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func draftEditor(editor: SwiftyDraft, requestImageAttachment callback: (result: SwiftyDraftImageResult) -> Void) {
        let ac = UIAlertController(title: "Image Picker Demo", message: "Fill your example content", preferredStyle: .Alert)
        var nameField: UITextField!
        var originalField: UITextField!
        var previewField: UITextField!
        ac.addTextFieldWithConfigurationHandler { tf in
            nameField = tf
            nameField.text = "Swift"
            nameField.placeholder = "Name"
        }
        ac.addTextFieldWithConfigurationHandler { tf in
            originalField = tf
            originalField.text = "https://swift.org/apple-touch-icon-180x180.png"
            originalField.placeholder = "Original URL"
        }
        ac.addTextFieldWithConfigurationHandler { tf in
            previewField = tf
            previewField.text = "https://swift.org/apple-touch-icon-57x57.png"
            previewField.placeholder = "Preview URL"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in
            if let name = nameField.text
                , originalURLString = originalField.text
                , originalURL = NSURL(string: originalURLString)
                , previewURLString = previewField.text
                , previewURL = NSURL(string: previewURLString) {
                let result = SwiftyDraftImageResult(name: name, originalURL: originalURL, previewURL: previewURL)
                callback(result: result)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in
        }))
        self.presentViewController(ac, animated: true, completion: nil)
    }

    func draftEditor(editor: SwiftyDraft, requestFileAttachment callback: (result: SwiftyDraftFileResult) -> Void) {
        let ac = UIAlertController(title: "File Picker Demo", message: "Fill your example content", preferredStyle: .Alert)
        var nameField: UITextField!
        var downloadField: UITextField!
        var sizeField: UITextField!
        ac.addTextFieldWithConfigurationHandler { tf in
            nameField = tf
            nameField.text = "Swift (8,988 bytes)"
            nameField.placeholder = "Name"
        }
        ac.addTextFieldWithConfigurationHandler { tf in
            downloadField = tf
            downloadField.text = "https://swift.org/apple-touch-icon-180x180.png"
            downloadField.placeholder = "Download URL"
        }
        ac.addTextFieldWithConfigurationHandler { tf in
            sizeField = tf
            sizeField.text = "8988"
            sizeField.placeholder = "File Size"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: { _ in
            if let name = nameField.text
                , downloadURLString = downloadField.text
                , downloadURL = NSURL(string: downloadURLString)
                , dataSizeString = sizeField.text
                , dataSize = Int(dataSizeString)  {
                let result = SwiftyDraftFileResult(name: name, downloadURL: downloadURL, dataSize: dataSize)
                callback(result: result)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in
        }))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
}

