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
#import "DetailViewController.h"

@interface MasterCollectionViewController ()

@property (readonly, nonatomic) Boolean haveCompactWidth;

@end

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

-(Boolean)getHaveCompactWidth
    {
    if (self.splitViewController == nil)
        return false;
        
    return self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
    NSString *segueID = [segue identifier];
    UICollectionView *colView = self.collectionView;
        
    if ((segueID == nil) || (colView == nil))
        return;
        
    if ([segueID isEqualToString:@"TextOnlyShowDetail"] ||
        [segueID isEqualToString:@"IconShowDetail"])
        {
        DetailViewController    *controller = (DetailViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
        NSArray<NSIndexPath *>  *selectedItems = [colView indexPathsForSelectedItems];
            
        if ((selectedItems != nil) && (selectedItems.count > 0))
            {
            controller.detailItem = [DataMgr.sharedInstance nthItem:[selectedItems objectAtIndex:0].item];
                
            controller.navigationItem.leftItemsSupplementBackButton = TRUE;
            }
            
        if (self.haveCompactWidth)
            {
            [colView selectItemAtIndexPath:nil animated:TRUE scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
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
