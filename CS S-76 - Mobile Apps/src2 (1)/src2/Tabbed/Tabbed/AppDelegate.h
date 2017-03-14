//
//  AppDelegate.h
//  Tabbed
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Tabbed Application.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UIWindow *window;

@end
