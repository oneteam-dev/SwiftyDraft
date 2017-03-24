//
//  ViewController.swift
//  SwiftyDraftExample
//
//  Created by Atsushi Nagase on 5/2/16.
//  Copyright © 2016 Oneteam Inc. All rights reserved.
//

import UIKit
import SwiftyDraft

class ViewController: UIViewController {

    @IBOutlet var draftView: SwiftyDraft!
    @IBOutlet var metaView: UIView!
    @IBOutlet var metaViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        draftView.setup()
        draftView.scrollViewDelegate = self
        draftView.filePickerDelegate = self
        draftView.imagePickerDelegate = self
//        draftView.paddingTop = metaView.bounds.height
        draftView.defaultHTML = "<h1>Yo</h1><p>Hello</p>"
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        metaViewTopConstraint.constant = scrollView.contentOffset.y
    }
}


extension ViewController: SwiftyDraftImagePickerDelegate {
    public func draftEditor(editor: SwiftyDraft, requestImageAttachment callback: @escaping (SwiftyDraftImageResult) -> Void) {
        let ac = UIAlertController(title: "Image Picker Demo", message: "Fill your example content", preferredStyle: .alert)
        var nameField: UITextField!
        var originalField: UITextField!
        var previewField: UITextField!
        ac.addTextField { tf in
            nameField = tf
            nameField.text = "Swift"
            nameField.placeholder = "Name"
        }
        ac.addTextField { tf in
            originalField = tf
            originalField.text = "https://swift.org/apple-touch-icon-180x180.png"
            originalField.placeholder = "Original URL"
        }
        ac.addTextField { tf in
            previewField = tf
            previewField.text = "https://swift.org/apple-touch-icon-57x57.png"
            previewField.placeholder = "Preview URL"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let name = nameField.text
                , let originalURLString = originalField.text
                , let originalURL = URL(string: originalURLString)
                , let previewURLString = previewField.text
                , let previewURL = URL(string: previewURLString) {
                let result = SwiftyDraftImageResult(name: name, originalURL: originalURL, previewURL: previewURL)
                callback(result)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        self.present(ac, animated: true, completion: nil)
    }
}

extension ViewController: SwiftyDraftFilePickerDelegate {
    public func draftEditor(editor: SwiftyDraft, requestFileAttachment callback: @escaping (SwiftyDraftFileResult) -> Void) {
        
        let ac = UIAlertController(title: "File Picker Demo", message: "Fill your example content", preferredStyle: .alert)
        var nameField: UITextField!
        var downloadField: UITextField!
        var sizeField: UITextField!
        ac.addTextField { tf in
            nameField = tf
            nameField.text = "Swift (8,988 bytes)"
            nameField.placeholder = "Name"
        }
        ac.addTextField { tf in
            downloadField = tf
            downloadField.text = "https://swift.org/apple-touch-icon-180x180.png"
            downloadField.placeholder = "Download URL"
        }
        ac.addTextField { tf in
            sizeField = tf
            sizeField.text = "8988"
            sizeField.placeholder = "File Size"
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let name = nameField.text
                , let downloadURLString = downloadField.text
                , let downloadURL = URL(string: downloadURLString)
                , let dataSizeString = sizeField.text
                , let dataSize = Int(dataSizeString)  {
                let result = SwiftyDraftFileResult(name: name, downloadURL: downloadURL, dataSize: dataSize)
                callback(result)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        self.present(ac, animated: true, completion: nil)
    }
}
