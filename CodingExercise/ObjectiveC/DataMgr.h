//
//  DataMgr.h
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 6/30/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemData : NSObject

    -(id)initWithDict:(NSDictionary *)dataDict;

    @property (nonatomic, readonly) NSString* title;
    @property (nonatomic, readonly) NSString* description;
    @property (nonatomic, readonly) NSURL* imageURL;

    @property (strong, nonatomic) NSDictionary* savedDataDict;

@end

@interface DataMgr : NSObject

    @property(strong) NSDate *modelLastUpdated;

    + (instancetype)sharedInstance;

    - (void)fetchJSONData;

    -(void)addDataModelObserver:(NSObject *)observer;

    -(NSUInteger)numDataItems;

    -(ItemData *)nthItem:(NSUInteger)nth;

@end

