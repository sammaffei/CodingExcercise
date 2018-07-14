//
//  MasterCollectionViewController.h
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 7/1/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterCollectionViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

typedef NS_ENUM(NSUInteger, CollectionViewMode)
    {
    textOnlyMode = 0,
    iconMode
    };

@property (nonatomic, assign) CollectionViewMode curColMode;


@end
