//
//  MasterCollectionCells.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

import UIKit

class TextOnlyColCell : UICollectionViewCell
    {
    @IBOutlet weak private var textLabel : UILabel!
    
    func setText(inText : String)
        {
        textLabel.text = inText
        }
    }

class IconColCell : UICollectionViewCell
    {
    @IBOutlet weak private var imageView : UIImageView!
    
    func setImage(usingURL : URL?)
        {
        if let imgUrl = usingURL
            {
            imageView.sd_setImage(with: imgUrl, completed: nil)
            }
        else
            {
            imageView.image = UIImage(named: "MissingImage")
            }
        }
    }
