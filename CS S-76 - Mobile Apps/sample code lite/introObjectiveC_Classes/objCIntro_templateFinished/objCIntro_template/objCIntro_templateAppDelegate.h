//
//  objCIntro_templateAppDelegate.h
//  objCIntro_template
//
//  Created by Shawn Arney on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class objCIntro_templateViewController;

@interface objCIntro_templateAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet objCIntro_templateViewController *viewController;

@end
