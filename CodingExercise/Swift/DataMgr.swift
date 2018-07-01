//
//  DataMgr.swift
//  CodingExercise
//
//  Created by Samuel Maffei on 6/25/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//
//  Class for hadning data retrieval in the data nodel for later access
//  Data model uses KVO to signal changes to observaers
//

import Foundation

typealias FetchErrorProc = (Error?) ->Void
typealias FetchCompletionProc = ()->Void

typealias DataModelUpdatedProc = ()->Void

private let _DataMgrSharedInstance = DataMgr()

@objcMembers class DataMgr : NSObject
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
    
    dynamic var modelLastUpdated = Date()                                       // Key KVO off of last updated date
    
    fileprivate var observersDict : [String : NSKeyValueObservation] = [:]      // store all KVO procs here, so callers just have to provide proc
    
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

    func fetchJSONData(errorProc : FetchErrorProc?)
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
                        errorProc?(err)         // This will be ok, because at this point there will be an error or something unexpected ocurred within the
                        return                  // data model
                        }
        
                self.buildTableData(topicsArray : relatedTopicsArray)
        
                DispatchQueue.main.async
                    {
                    self.modelLastUpdated = Date()       // udoate this in case someone observing, KVO is based on changed date of last fetch
                    }
            }
    
        fetchTask.resume()
        }
    
    func addDataModelObserver(indentifer: String, proc : @escaping DataModelUpdatedProc)
        {
        // Add a proc to the dict of observers. This mdoel uses KVO to directly signal changes on the data.
        // It is more direct than the NSNotificationCenter approach (and easier to debug)
        // The dict just saves observers so that they don't go away unless some ones them to be removed
            
        observersDict[indentifer] = self.observe(\.modelLastUpdated)
                {(mgr, change) in
                    proc()
                }
        }

    func removeDataModelObserver(indentifer: String)
        {
        observersDict.removeValue(forKey: indentifer)
        }
}
