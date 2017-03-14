//
//  AppDelegate.h
//  SingleView
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Single View Application.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end
