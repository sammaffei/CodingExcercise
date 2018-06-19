//
//  MasterCollectionViewController.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/19/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

import UIKit

class MasterCollectionViewController : UICollectionViewController
    {
    enum CollectionViewMode : Int
        {case textOnly = 0, icon}
    
    var curMode : CollectionViewMode = .textOnly
        {
        didSet
            {
            self.collectionView?.reloadData()
            }
        }
    
    var tableDataArray : [ItemData] = []
    
    var detailViewController: DetailViewController? = nil

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
        return 0
        //return tableDataArray.count
        }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPaths = collectionView?.indexPathsForSelectedItems
                {
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = tableDataArray[indexPaths[0].item]
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
        }
    }


    }
