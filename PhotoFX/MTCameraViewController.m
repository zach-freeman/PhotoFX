//
//  MTCameraViewController.m
//  PhotoFX
//
//  Created by Zach Freeman on 6/8/14.
//  Copyright (c) 2014 sparkwing. All rights reserved.
//

#import "MTCameraViewController.h"
#import "GPUImage.h"
#import "FilterUtilities.h"

@interface MTCameraViewController () <UIActionSheetDelegate>
{
    GPUImageStillCamera *stillCamera;
    GPUImageFilter *filter;
}

- (IBAction)captureImage:(id)sender;

@end

@implementation MTCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Add Filter Button to Interface
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(applyImageFilter:)];
    self.navigationItem.rightBarButtonItem = filterButton;
    
    // Setup initial camera filter
    filter = [[GPUImageFilter alloc] init];
    //[filter prepareForImageCapture];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    
    // Create custom GPUImage camera
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [stillCamera addTarget:filter];
    
    // Begin showing video camera stream
    [stillCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)applyImageFilter:(id)sender
{
    UIActionSheet *filterActionSheet = [FilterUtilities filterActionSheet:self];
    
    [filterActionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Bail if the cancel button was tapped
    if(actionSheet.cancelButtonIndex == buttonIndex)
    {
        return;
    }
    
    GPUImageFilter *selectedFilter = [FilterUtilities selectedFilter:buttonIndex];
    if (selectedFilter != nil) {
    
        [stillCamera removeAllTargets];
        [filter removeAllTargets];

        filter = selectedFilter;
        GPUImageView *filterView = (GPUImageView *)self.view;
        [filter addTarget:filterView];
        [stillCamera addTarget:filter];
    }
    
}

-(IBAction)captureImage:(id)sender
{
    // Disable to prevent multiple taps while processing
    UIButton *captureButton = (UIButton *)sender;
    captureButton.enabled = NO;
    
    // Snap Image from GPU camera, send back to main view controller
    [stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter withCompletionHandler:^(NSData *processedJPEG, NSError *error)
     {
         if([self.delegate respondsToSelector:@selector(didSelectStillImage:withError:)])
         {
             [self.delegate didSelectStillImage:processedJPEG withError:error];
         }
         else
         {
             NSLog(@"Delegate did not respond to message");
         }
         
         runOnMainQueueWithoutDeadlocking(^{
             [self.navigationController popToRootViewControllerAnimated:YES];
         });
     }];
}

@end
