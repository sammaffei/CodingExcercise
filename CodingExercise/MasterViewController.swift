//
//  MasterViewController.swift
//  CodingExcercise
//
//  Created by Samuel Maffei on 6/18/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

import UIKit

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


class MasterViewController: UITableViewController {
    
    
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
        
        self.title = Constants.DataTitleStr
        
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
                self.tableView.reloadData() // Drawing must be done on main thread
                }
            }
        
        fetchTask.resume()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = tableDataArray[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = tableDataArray[indexPath.row].title
        return cell
    }


}

