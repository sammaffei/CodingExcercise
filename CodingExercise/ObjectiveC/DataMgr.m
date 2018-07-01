//
//  DataMgr.m
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 6/30/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

#import "DataMgr.h"

@implementation ItemData

NSString* parsedTitle = nil;

-(id)initWithDict:(NSDictionary *)dataDict
    {
    if ( self = [super init] )
        {
        _savedDataDict = dataDict;
        }
        
    return self;
    }

-(NSString *)title
    {
    if (parsedTitle == nil)
        {
        NSString *descStr = self.description;
            
        if (descStr != nil)
            {
            NSArray *items = [descStr componentsSeparatedByString:@" - "];
                
            if (items.count > 0)
                {
                parsedTitle = items[0];
                }
            }
        }
        
    return parsedTitle;
    }

-(NSString *)description
    {
    if (_savedDataDict == nil)
        return nil;
    
    return [_savedDataDict objectForKey:@"Text"];
    }

-(NSURL *)imageURL
    {
    return nil;
    }


@end

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
