//
//  ViewController.h
//  PhotoFX
//
//  Created by Zach Freeman on 6/8/14.
//  Copyright (c) 2014 sparkwing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "MTCameraViewController.h"


@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, MTCameraViewControllerDelegate, iCarouselDataSource, iCarouselDelegate>

@end
