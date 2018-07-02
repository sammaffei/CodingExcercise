//
//  MasterViewController.m
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 6/30/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

#import "MasterViewController.h"
#import "MasterCollectionViewController.h"
#import "DetailViewController.h"
#import "Constants.h"

@interface MasterViewController ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *modeSelectorHeightConstraint;
@property (weak, nonatomic) MasterCollectionViewController *childCollectionVC;

@end

@implementation MasterViewController

CGFloat defaultModeSelectorHeight = 0.0;

- (IBAction)performModeSwitch:(UISegmentedControl *)sender
    {
    if (_childCollectionVC != nil)
        {
        
        }
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_modeSelectorHeightConstraint != nil)
        {
        defaultModeSelectorHeight = _modeSelectorHeightConstraint.constant;
        }
    
    self.title = cDataTitleStr;
}

-(void)setModeSelectorVisibilty:(Boolean)visible
    {
    if (_modeSelectorHeightConstraint != nil)
        {
        _modeSelectorHeightConstraint.constant = visible ? defaultModeSelectorHeight : 0.0;
            
        [self.view setNeedsLayout];
        }
    }


/*     override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
 {
 guard let splitPlaneVC = self.splitViewController
 else {return}
 
 // OK, we really shouldn't be talking iPhone vs. iPad these days. We really should be supporting
 // size classes where we can. So, the spec really only wants the mode selector to be visible
 // when the size class is compact. Otherwise, it always only text
 
 setModeSelectorVisibilty(visible: splitPlaneVC.traitCollection.horizontalSizeClass == .compact)
 } */

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
    {
    // OK, we really shouldn't be talking iPhone vs. iPad these days. We really should be supporting
    // size classes where we can. So, the spec really only wants the mode selector to be visible
    // when the size class is compact. Otherwise, it always only text

    if (self.splitViewController != nil)
        {
        [self setModeSelectorVisibilty:self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact];
        }
    }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // use embed to store MasterCollectionViewController
    
    if ([segue.identifier isEqualToString:@"CollectionEmbedSegue"])
    {
        _childCollectionVC = (MasterCollectionViewController *) segue.destinationViewController;
    }
}



@end
