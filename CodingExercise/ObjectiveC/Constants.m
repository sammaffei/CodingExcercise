//
//  Constants.m
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 7/1/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

#import "Constants.h"

#if SIMPSONSVIEWERAPP

NSString *const cAppRestURLStr = @"http://api.duckduckgo.com/?q=simpsons+characters&format=json";
NSString *const cDataTitleStr = @"Simpsons Character Viewer";

#elif WIREVIEWERAPP

NSString *const cAppRestURLStr = @"http://api.duckduckgo.com/?q=the+wire+characters&format=json";
NSString *const cDataTitleStr = @"The Wire Character Viewer";

#endif

NSString *const cModelLastUpdatedKeyPath = @"modelLastUpdated";

