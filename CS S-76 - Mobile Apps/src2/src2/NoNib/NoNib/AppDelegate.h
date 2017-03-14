//
//  AppDelegate.h
//  NoNib
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Single View Application with a view implemented without a nib (or storyboard).
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end
