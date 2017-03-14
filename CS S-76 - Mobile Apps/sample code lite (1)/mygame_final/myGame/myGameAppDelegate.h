//
//  myGameAppDelegate.h
//  myGame
//
//  Created by Darshan Arney on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class myGameViewController;

@interface myGameAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet myGameViewController *viewController;

@end
