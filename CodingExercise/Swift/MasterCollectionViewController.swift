//
//  MasterCollectionViewController.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

import UIKit

class MasterCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout
    {
    enum CollectionViewMode : Int
        {case textOnly = 0, icon}
    
    
    // what's the current cell type?
    
    var curCellIdentifier : String = TextOnlyColCell.cellIdentifer
    
    var curMode : CollectionViewMode = .textOnly
        {
        didSet
            {
            switch curMode          // set the current cell type based on the mode assignment
                {
                case .textOnly:
                    curCellIdentifier = TextOnlyColCell.cellIdentifer
                case .icon:
                    curCellIdentifier = IconColCell.cellIdentifer
                }
                
                
            self.collectionView?.reloadData()
            }
        }
    
    var detailViewController: DetailViewController? = nil
    
    var haveCompactWidth : Bool
        {
        get
            {
            return self.splitViewController!.traitCollection.horizontalSizeClass == .compact
            }
        }

    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            // add and be notifed if model changes

            DataMgr.sharedInstance.addDataModelObserver(indentifer: String(describing: MasterCollectionViewController.self))
                {
                self.collectionView?.reloadData()
                    
                MBProgressHUD.hide(for: self.view, animated: true) // hide progress hud
                }
        
            if let split = splitViewController {
                let controllers = split.viewControllers
                detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            }
        
            MBProgressHUD.showAdded(to: self.view, animated: true)  // show progress hud
        }
    
    // MARK: - Collection View Stuff
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int
        {
        return 1
        }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
        return DataMgr.sharedInstance.dataModelArray.count
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
        // Looked into warning. This appears to be an interface builder bug where it tries to flag you for
        // no fixed sized items (like you may have mad a mistake). I like to remove warnings too, but this one is
        // way off base.
            
        switch curMode
            {
            case .textOnly:
                return CGSize(width: collectionView.frame.width, height: 40.0)
            
            case .icon:
                return CGSize(width: (collectionView.frame.width / 2) - 5, height: (collectionView.frame.width / 2) - 5)
            }
        
        }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
        let dataProtocol = collectionView.dequeueReusableCell(withReuseIdentifier: curCellIdentifier, for: indexPath) as! SetDataProtocol
            
        dataProtocol.setData(inData: DataMgr.sharedInstance.dataModelArray[indexPath.item])
        
        return dataProtocol as! UICollectionViewCell
        }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier
            {
            case "TextOnlyShowDetail", "IconShowDetail":
            
                if let indexPaths = collectionView?.indexPathsForSelectedItems
                    {
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = DataMgr.sharedInstance.dataModelArray[indexPaths[0].item]
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                        
                    // if compact width, we should deselect the item before we segue so it isn't selected when we come back
                        
                    if haveCompactWidth
                        {
                        collectionView?.selectItem(at: nil, animated: true, scrollPosition: [])
                        }

                    }

            
            default:
                break
            }
        }

    }
