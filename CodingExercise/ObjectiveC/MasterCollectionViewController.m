//
//  MasterCollectionViewController.m
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 7/1/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

#import "MasterCollectionViewController.h"
#import "DataMgr.h"
#import "Constants.h"
#import "MasterCollectionCells.h"

@implementation MasterCollectionViewController

static NSArray *cellIDStrs;

+(void)initialize
    {
    cellIDStrs = @[[TextOnlyColCell cellIndentifier],[IconColCell cellIndentifier]];
    }

-(void)setCurColMode:(CollectionViewMode)newMode
    {
    if (_curColMode != newMode)
        {
        _curColMode = newMode;
            
        if (self.collectionView != nil)
            [self.collectionView reloadData];
        }
    }

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
    {
    if ([keyPath isEqualToString:cModelLastUpdatedKeyPath])
        {
        if (self.collectionView != nil)
            [self.collectionView reloadData];
        }
    }

-(void)viewDidLoad
    {
    [super viewDidLoad];
        
    [DataMgr.sharedInstance addDataModelObserver:self];
    }

#pragma mark Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
    {
    return 1;
    }

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
    return [DataMgr.sharedInstance numDataItems];
    }

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
    switch (self.curColMode)
        {
        case textOnlyMode:
            return CGSizeMake(collectionView.frame.size.width, 40);
                
        default:
        case iconMode:
            {
            CGFloat side = (collectionView.frame.size.width / 2) - 5;
                
            return CGSizeMake(side, side);
            }
        }
    }

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
    UICollectionViewCell<SetDataProtocol> *dataCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIDStrs[self.curColMode]
                                                                                                forIndexPath:indexPath];
    ItemData    *iData = [DataMgr.sharedInstance nthItem:indexPath.item];
        
    if ((iData != nil) && (dataCell != nil))
        {
        [dataCell setData:iData];
            
        return dataCell;
        }
        
    return nil;
    }



@end
