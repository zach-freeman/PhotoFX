//
//  FilterUtilities.h
//  PhotoFX
//
//  Created by Zach Freeman on 6/8/14.
//  Copyright (c) 2014 sparkwing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface FilterUtilities : NSObject

+(UIActionSheet*)filterActionSheet:(id)sender;
+(GPUImageFilter*)selectedFilter:(NSInteger)buttonIndex;

@end
