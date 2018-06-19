//
//  MasterCollectionViewController.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

import UIKit



class MasterCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout
    {
    enum CollectionViewMode : Int
        {case textOnly = 0, icon}
    
    struct ItemData
        {
        var title : String
        var description : String
        var imageURL: URL?
        
        init(inTitle : String, inDescription : String, inImageURL : URL?)
            {
            title = inTitle
            description = inDescription
            imageURL = inImageURL
            }
        }
    
    var curMode : CollectionViewMode = .textOnly
        {
        didSet
            {
            self.collectionView?.reloadData()
            }
        }
    
    var tableDataArray : [ItemData] = []
    
    var detailViewController: DetailViewController? = nil
    
    var haveCompactWidth : Bool
        {
        get
            {
            return self.splitViewController!.traitCollection.horizontalSizeClass == .compact
            }
        }

    // Build a struct array so that we don't have to parse a lot of junk on every reload
    
    func buildTableData(topicsArray : NSArray)
        {
        tableDataArray = []
        
        for anItem in topicsArray
            {
            var imageURL : URL?
            
            guard let itemDict = anItem as? NSDictionary,
                let textItem = itemDict.object(forKey: "Text") as? String   // Don't even have text, so skip to next one
                else {continue}
            
            if let iconDict = itemDict.value(forKey: "Icon") as? NSDictionary,  // get the image url, by doing this walk and checking size
                let urlStr = iconDict.value(forKey: "URL") as? String,
                urlStr.count > 0
                {
                imageURL = URL(string: urlStr)
                }
            
            let itemsSeparated = textItem.components(separatedBy: " - ")    // Split text and description, easy enough. If more coplicated
            // would use regular expression
            
            if itemsSeparated.count == 2
                {
                tableDataArray.append( ItemData(inTitle: itemsSeparated[0], inDescription: itemsSeparated[1], inImageURL: imageURL))
                }
            }
        }
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            let fetchTask = URLSession.shared.dataTask(with: Constants.APPRestURL)
            { (optData : Data?, optResp : URLResponse?, err:Error?) in
                
                // if any of these conditions fail, then bail. We can't do the work
                
                guard   let jsonData = optData,
                    let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)),
                    let jsonDict = jsonResult as? NSDictionary,
                    let relatedTopics = jsonDict.object(forKey: "RelatedTopics"),
                    let relatedTopicsArray = relatedTopics as? NSArray
                    else {return}
                
                self.buildTableData(topicsArray : relatedTopicsArray)
                
                DispatchQueue.main.async
                    {
                    self.collectionView?.reloadData()
                        
                    // Select the first item if our width is regular (means both panes can be visible at once.
                        
                    if (!self.haveCompactWidth) && (self.tableDataArray.count > 0)
                        {
                        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
                        self.collectionView?.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .top)
                            
                        self.performSegue(withIdentifier: "TextOnlyShowDetail", sender: nil)
                        }
                    }
            }
        
            fetchTask.resume()
        
            if let split = splitViewController {
                let controllers = split.viewControllers
                detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            }
        }
    
    // MARK: - Collection View Stuff
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int
        {
        return 1
        }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
        return tableDataArray.count
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
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
        var cellIdentifier : String = ""
            
        switch curMode
            {
            case .textOnly:
                cellIdentifier = "TextOnlyCell"
                
            case .icon:
                cellIdentifier = "IconCell"
            }

        let dataProtocol = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SetDataProtocol
            
        dataProtocol.setData(inData: tableDataArray[indexPath.item])
        
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
                    controller.detailItem = tableDataArray[indexPaths[0].item]
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
