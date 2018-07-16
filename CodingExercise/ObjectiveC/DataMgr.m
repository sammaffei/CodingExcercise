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
    {
    NSString* parsedTitle;
    NSString* parseDescription;
    NSURL* createdURL;
    }

-(id)initWithDict:(NSDictionary *)dataDict
    {
    if ( self = [super init] )
        {
        parsedTitle = nil;
        parseDescription = nil;
        createdURL = nil;
            
        _savedDataDict = dataDict;
        }
        
    return self;
    }

-(void)parseTitleDescription
    {
    if (parsedTitle != nil)     // parsed data already, bail
        return;
        
    NSString *fullText = [_savedDataDict objectForKey:@"Text"];
        
    parsedTitle = NSLocalizedString(@"?Title?", nil);
    parseDescription = NSLocalizedString(@"?Description?", nil);
        
    if ((fullText == nil) || (fullText.length < 1))
        {
        return;
        }
        
    NSArray *brokenTextItems = [fullText componentsSeparatedByString:@" - "];
        
    if (brokenTextItems.count > 0)
        {
        parsedTitle = brokenTextItems[0];
            
        if (brokenTextItems.count > 1)
            parseDescription = brokenTextItems[1];
        }
    }

-(NSString *)title
    {
    [self parseTitleDescription];
        
    return parsedTitle;
    }

-(NSString *)description
    {
    [self parseTitleDescription];
    
    return parseDescription;
    }

-(NSURL *)imageURL
    {
    if (createdURL == nil)
        {
        NSDictionary *iconDict = [_savedDataDict objectForKey:@"Icon"];
            
        if ((iconDict == nil) || (![iconDict isKindOfClass:[NSDictionary class]]))
            return nil;
            
        NSString *urlStr = [iconDict objectForKey:@"URL"];
        
        if ((urlStr == nil) || (![urlStr isKindOfClass:[NSString class]]))
            return nil;
            

        createdURL = [NSURL URLWithString:urlStr];
        }
        
    return createdURL;
    }


@end

@implementation DataMgr


NSMutableArray* dataModelArray = nil;

NSMutableArray* observerArray = nil;

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

-(id)init
    {
    if ( self = [super init] )
        {
        dataModelArray = [[NSMutableArray alloc] init];
            
        NSAssert(dataModelArray != nil, @"Fatal Error : Couldn't allocate data manager.");
            
        observerArray = [[NSMutableArray alloc] init];
            
        NSAssert(observerArray != nil, @"Fatal Error : Couldn't allocate observerArray.");
        }
        
    return self;
    }


-(void)buildTableData:(NSArray *)topicsArray
    {
    if (topicsArray == nil)
        return;
        
    [dataModelArray removeAllObjects];
        
    for (NSDictionary* dataDict in topicsArray)
        {
        if (![dataDict isKindOfClass:[NSDictionary class]])
            continue;
            
        ItemData *newItemData = [[ItemData alloc] initWithDict:dataDict];
            
        if (newItemData != nil)
            [dataModelArray addObject:newItemData];
        }
        
    // Execute on main thread because callers don't know this is the result of an asynch network thread.
        
    dispatch_async(dispatch_get_main_queue(), ^{
            self.modelLastUpdated = [NSDate date];
        });
    
    }

- (void)fetchJSONData
    {
    NSURL *appURL = [NSURL URLWithString:cAppRestURLStr];
        
    if (appURL == nil)
        return;
        
    NSURLSessionDataTask *fetchTask = [NSURLSession.sharedSession dataTaskWithURL:appURL
                                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
        {
        if (error != nil)
            {
            return;
            }
        
        if (data != nil)
            {
            NSError *err = nil;
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &err];

            if ((dataDict == nil) || (![dataDict isKindOfClass:[NSDictionary class]]))
                return;
                  
            NSArray *dataItemsArray = [dataDict valueForKey:@"RelatedTopics"];
                                        
            if ((dataItemsArray == nil) || (![dataItemsArray isKindOfClass:[NSArray class]]))
                return;

            [self buildTableData:dataItemsArray];
            }
        
        }];
        
    [fetchTask resume];
    }

-(void)addDataModelObserver:(NSObject *)observer
    {
    [observerArray addObject:observer];
        
    NSString *keyPath = NSStringFromSelector(@selector(modelLastUpdated));
        
    [self addObserver:observer forKeyPath:keyPath options:0 context:nil];
    }

-(NSUInteger)numDataItems
    {
    if (dataModelArray != nil)
        return [dataModelArray count];
        
    return 0;
    }

-(ItemData *)nthItem:(NSUInteger)nth
    {
     if ((dataModelArray != nil) && (nth < [dataModelArray count]))
         return [dataModelArray objectAtIndex:nth];
        
    return nil;
    }

- (void)dealloc
    {
    dataModelArray = nil;
    observerArray = nil;
    }

@end
