//
//  MasterCollectionCells.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

import UIKit

// Since all the cells set stuff with the ItemData data structure, we can use a protocol
// to genericize setting up cells

protocol SetDataProtocol
    {
    func setData(inData : MasterCollectionViewController.ItemData)
    }

class TextOnlyColCell : UICollectionViewCell, SetDataProtocol
    {
    @IBOutlet weak private var textLabel : UILabel!
    
    func setData(inData : MasterCollectionViewController.ItemData)
        {
        textLabel.text = inData.title
        }
    }

class IconColCell : UICollectionViewCell, SetDataProtocol
    {
    @IBOutlet weak private var imageView : UIImageView!
    
    func setData(inData : MasterCollectionViewController.ItemData)
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
