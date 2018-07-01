//
//  MasterCollectionCells.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

import UIKit

// Since all the cells set stuff with the ItemData data structure, we can use a protocol
// to genericize setting up cells

protocol SetDataProtocol
    {
    static var cellIdentifer: String { get }
    
    func setData(inData : DataMgr.ItemData)
    }

class SelectableColCell : UICollectionViewCell
    {
    @IBInspectable fileprivate var unselectedColor : UIColor!       // Make these inspectable so that you can
    @IBInspectable fileprivate var selectedColor : UIColor!         // set them in interfacebuilder
    }

class TextOnlyColCell : SelectableColCell, SetDataProtocol
    {
    @IBOutlet weak private var textLabel : UILabel!
    
    static var cellIdentifer = "TextOnlyCell"
    
    override var isSelected: Bool{
        didSet
            {
            self.contentView.backgroundColor = self.isSelected ? selectedColor : unselectedColor
            }
    }
    
    func setData(inData : DataMgr.ItemData)
        {
        textLabel.text = inData.title
        }
    }

class IconColCell : SelectableColCell, SetDataProtocol
    {
    @IBOutlet weak private var imageView : UIImageView!
    
    static var cellIdentifer = "IconCell"
    
    override var isSelected: Bool{
        didSet
            {
            imageView.backgroundColor = self.isSelected ? selectedColor : unselectedColor
            }
        }

    
    func setData(inData : DataMgr.ItemData)
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
