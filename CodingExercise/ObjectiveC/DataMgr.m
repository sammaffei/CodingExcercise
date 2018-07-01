//
//  DataMgr.m
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 6/30/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

#import "DataMgr.h"
#import "Constants.h"

@implementation ItemData

NSString* parsedTitle = nil;
NSArray* dataModelArray = nil;

-(id)initWithDict:(NSDictionary *)dataDict
    {
    if ( self = [super init] )
        {
        _savedDataDict = dataDict;
        dataModelArray = [[NSArray alloc] init];
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

- (void)fetchJSONData
    {
    NSURL *appURL = [NSURL URLWithString:cAppRestURLStr];
        
    if (appURL == nil)
        return;
        
    [NSURLSession.sharedSession dataTaskWithURL:appURL
                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response,
                                                  NSError * _Nullable error)
        {
        if (error != nil)
            {
            return;
            }
        
        if (data != nil)
            {
            NSError *err = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &err];

            }
        
        }];
    }

- (void)dealloc
    {
    if (dataModelArray != nil)
        dataModelArray = nil;
        
    if (parsedTitle != nil)
        parsedTitle = nil;
    }

@end
