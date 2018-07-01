//
//  DataMgr.m
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 6/30/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

#import "DataMgr.h"

@implementation DataMgr

+ (instancetype)sharedInstance
    {
    static DataMgr *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataMgr alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
    }

@end
