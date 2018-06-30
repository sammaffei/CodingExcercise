//
//  Consants.swift
//  CodingExcercise
//
//  Created by Samuel Maffei on 6/18/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

import Foundation

struct Constants
    {
    // Swap these out based on the active compilation conditions set in the target
    
    #if SIMPSONSVIEWERAPP
    
    static let APPRestURL = URL(string: "http://api.duckduckgo.com/?q=simpsons+characters&format=json")!
    
    static let DataTitleStr = "Simpsons Character Viewer"
    
    #elseif WIREVIEWERAPP
    
    static let APPRestURL = URL(string: "http://api.duckduckgo.com/?q=the+wire+characters&format=json")!
    
    static let DataTitleStr = "The Wire Character Viewer"

    #endif

    }
