//
//  MasterCollectionCells.m
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 7/1/18.
//  Copyright © 2018 sammaffei. All rights reserved.
//

#import "MasterCollectionCells.h"
#import <SDWebImage/UIImageView+WebCache.h>

// ------------------------------------------------------------------------------------------------

@implementation SelectableColCell   // Implement to satify compiler

@end

// ------------------------------------------------------------------------------------------------

@implementation TextOnlyColCell

+(NSString *)cellIndentifier
    {
    return @"TextOnlyCell";
    }

-(void)setData:(ItemData *)inData
    {
    _textLabel.text = (inData == nil) ? nil : inData.description;
    }

@end

// ------------------------------------------------------------------------------------------------

@implementation IconColCell

+(NSString *)cellIndentifier
    {
    return @"IconCell";
    }

-(void)setData:(ItemData *)inData
    {
    if ((inData == nil) || (inData.imageURL == nil))
        {
        _imageView.image = [UIImage imageNamed:@"MissingImage"];
        }
    else
        {
        [_imageView sd_setImageWithURL:inData.imageURL];
        }
    }

@end
