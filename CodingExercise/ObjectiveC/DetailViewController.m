//
//  DetailViewController.m
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 6/30/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView
    {
    // Update the user interface for the detail item.
    
    if ((_detailItem == nil) || (_detailItem.imageURL == nil))
        {
        _imageView.image = [UIImage imageNamed:@"MissingImage"];
        }
    else
        {
        [_imageView sd_setImageWithURL:_detailItem.imageURL];
        }
    
    
    _textView.text = ((_detailItem == nil) || (_detailItem.title == nil)) ? nil : _detailItem.title;

    self.title = _textView.text == nil ? @"Missing" : _textView.text;
    }


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(ItemData *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


@end
