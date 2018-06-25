//
//  DataMgr.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/25/18.
//  Copyright © 2018 xfinity. All rights reserved.
//
//  Class for hadning data retrieval in the dat nodel for later access
//

import Foundation

typealias FetchErrorProc = (Error?) ->Void
typealias FetchCompletionProc = ()->Void

private let _DataMgrSharedInstance = DataMgr()

class DataMgr
    {
    class var sharedInstance: DataMgr {
        return _DataMgrSharedInstance
        }
    
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
    
    var dataModelArray : [ItemData] = []
    
    // Build a struct array so that we don't have to parse a lot of junk on every reload
    
    fileprivate func buildTableData(topicsArray : NSArray)
    {
        dataModelArray = []
        
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
                dataModelArray.append( ItemData(inTitle: itemsSeparated[0], inDescription: itemsSeparated[1], inImageURL: imageURL))
                }
        }
    }

    func fetchJSONData(compProc : FetchCompletionProc?, errorProc : FetchErrorProc?)
        {
        let fetchTask = URLSession.shared.dataTask(with: Constants.APPRestURL)
            { (optData : Data?, optResp : URLResponse?, err:Error?) in
        
                // if any of these conditions fail, then bail. We can't do the work
        
                guard   let jsonData = optData,
                        let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.init(rawValue: 0)),
                        let jsonDict = jsonResult as? NSDictionary,
                        let relatedTopics = jsonDict.object(forKey: "RelatedTopics"),
                        let relatedTopicsArray = relatedTopics as? NSArray
                    else
                        {
                        errorProc?(err)         // This will be ok, because at this point there will be an error or something unexpected ocurred witht he
                        return                  // data model
                        }
        
                self.buildTableData(topicsArray : relatedTopicsArray)
        
                DispatchQueue.main.async
                    {
                    if let _ = optData
                        {
                        compProc?()
                        }
                    }
            }
    
        fetchTask.resume()
        }
    }
