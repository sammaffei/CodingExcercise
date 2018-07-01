//
//  DetailViewController.swift
//  CodingExcercise
//
//  Created by Samuel Maffei on 6/18/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var textView : UITextView!

    var detailItem: DataMgr.ItemData?

    func configureView() {
        // Update the user interface for the detail item.
        
        guard let detailData = detailItem
            else {return}
        
        if let imgUrl = detailData.imageURL
            {
            imageView.sd_setImage(with: imgUrl, completed: nil)
            }
        else
            {
            imageView.image = UIImage(named: "MissingImage")
            }
        
        textView.text = detailData.description
        
        self.title = detailData.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

