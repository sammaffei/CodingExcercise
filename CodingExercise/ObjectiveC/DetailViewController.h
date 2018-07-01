//
//  DetailViewController.h
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 6/30/18.
//  Copyright © 2018 xfinity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataMgr.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) ItemData *detailItem;

@end

