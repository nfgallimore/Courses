//
//  FlipsideViewController.h
//  Storyboard
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Utility Application.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
