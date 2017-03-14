//
//  AppDelegate.h
//  Utility
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Utility Application.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) UIWindow *window;

@end
