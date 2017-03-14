//
//  AppDelegate.h
//  Nib1
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Single View Application implemented with a nib, plus IBAction and IBOutlet.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end
