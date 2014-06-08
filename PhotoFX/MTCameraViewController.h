//
//  MTCameraViewController.h
//  PhotoFX
//
//  Created by Zach Freeman on 6/8/14.
//  Copyright (c) 2014 sparkwing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTCameraViewControllerDelegate

- (void)didSelectStillImage:(NSData *)image withError:(NSError *)error;

@end

@interface MTCameraViewController : UIViewController <UIActionSheetDelegate>

@property(weak, nonatomic) id delegate;

@end
