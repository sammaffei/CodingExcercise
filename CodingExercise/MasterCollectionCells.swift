//
//  MasterCollectionCells.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

import UIKit

protocol SetDataProtocol
    {
    func setData(inData : ItemData)
    }

class TextOnlyColCell : UICollectionViewCell, SetDataProtocol
    {
    @IBOutlet weak private var textLabel : UILabel!
    
    func setData(inData : ItemData)
        {
        textLabel.text = inData.title
        }
    }

class IconColCell : UICollectionViewCell, SetDataProtocol
    {
    @IBOutlet weak private var imageView : UIImageView!
    
    func setData(inData : ItemData)
        {
        if let imgUrl = inData.imageURL
            {
            imageView.sd_setImage(with: imgUrl, completed: nil)
            }
        else
            {
            imageView.image = UIImage(named: "MissingImage")
            }
        }
    }
