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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {

    }


@end
