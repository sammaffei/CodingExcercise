//
//  MasterCollectionCells.h
//  SimpsonsViewerOC
//
//  Created by Samuel Maffei on 7/1/18.
//  Copyright © 2018 sammaffei All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataMgr.h"

@protocol SetDataProtocol

@required

+(NSString *)cellIndentifier;

-(void)setData:(ItemData *)inData;

@end

// ------------------------------------------------------------------------------------------------

@interface SelectableColCell : UICollectionViewCell

@property (nonatomic) IBInspectable UIColor *unselectedColor;
@property (nonatomic) IBInspectable UIColor *selectedColor;

@end

// ------------------------------------------------------------------------------------------------

@interface TextOnlyColCell : SelectableColCell<SetDataProtocol>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

+(NSString *)cellIndentifier;

-(void)setData:(ItemData *)inData;

@end

// ------------------------------------------------------------------------------------------------

@interface IconColCell : SelectableColCell<SetDataProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+(NSString *)cellIndentifier;

-(void)setData:(ItemData *)inData;

@end
