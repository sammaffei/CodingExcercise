//
//  MasterViewController
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

import UIKit

class MasterViewController : UIViewController
    {
    @IBOutlet weak var modeSelectorHeightConstraint : NSLayoutConstraint?
    
    var childCollectionVC : MasterCollectionViewController?
    
    var defaultModeSelectorHeight : CGFloat = 0.0
    
    var compactInAnyDimension : Bool
        {
        get
            {
            guard let splitPlaneVC = self.splitViewController   // if we can't get it assume we do
                else {return true}
                
            return (splitPlaneVC.traitCollection.horizontalSizeClass == .compact) ||
                    (splitPlaneVC.traitCollection.verticalSizeClass == .compact)
            }
        }
    
    @IBAction func performModeSwitch(_ sender : UISegmentedControl)
        {
        guard let collectionVC = childCollectionVC
            else {return}
        
        collectionVC.curMode = MasterCollectionViewController.CollectionViewMode(rawValue: sender.selectedSegmentIndex)!
        }
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
            
        // save off default height before we possible change it
            
        if let heightConstraint = modeSelectorHeightConstraint
            {
            defaultModeSelectorHeight = heightConstraint.constant
            }
        
        self.title = Constants.DataTitleStr
        }
    
    func setModeSelectorVisibilty(visible : Bool)
        {
        guard let heightConstraint = modeSelectorHeightConstraint
            else {return}
            
        heightConstraint.constant = visible ? defaultModeSelectorHeight : 0.0
            
        self.view.setNeedsLayout()
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // use embed segue to get the child collectionview controller and store it for later use.
        
        switch segue.identifier
            {
            case "CollectionEmbedSegue":
            
                childCollectionVC = segue.destination as? MasterCollectionViewController
            
            default:
                break
            }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
        {
        // OK, we really shouldn't be talking iPhone vs. iPad these days. We really should be supporting
        // size classes where we can. So, the spec really only wants the mode selector to be visible
        // when the size class is compact. Otherwise, it always only text
            
        setModeSelectorVisibilty(visible: self.compactInAnyDimension)
        }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
        {
        // Fixed problem were cells weren't updating correct;y with rotation.
            
        childCollectionVC?.collectionView?.reloadData()
        }
    
    }
