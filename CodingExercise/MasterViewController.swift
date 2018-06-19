//
//  MasterViewController
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

import UIKit

class MasterViewController : UIViewController
    {
    @IBOutlet weak var modeSelectorHeightConstraint : NSLayoutConstraint?
    
    var childTableViewVC : MasterTableViewController?
    
    var defaultModeSelectorHeight : CGFloat = 0.0
    
    @IBAction func performModeSwitch(_ sender : UISegmentedControl)
        {
        guard let tableVC = childTableViewVC
            else {return}
        
        tableVC.curTableMode = MasterTableViewController.MasterTableViewMode(rawValue: sender.selectedSegmentIndex)!
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
        
        // use embed segue to get the child table view controller and store it for later use.
        
        switch segue.identifier
            {
            case "TableEmbedSegue":
            
                childTableViewVC = segue.destination as? MasterTableViewController
            
            default:
                break
            }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
        {
        guard let splitPlaneVC = self.splitViewController
            else {return}
            
        // OK, we really shouldn't be talking iPhone vs. iPad these days. We really should be supporting
        // size classes where we can. So, the spec really only wants the mode selector to be visible
        // when the size class is compact. Otherwise, it always only text
            
        setModeSelectorVisibilty(visible: splitPlaneVC.traitCollection.horizontalSizeClass == .compact)
        }
    }
