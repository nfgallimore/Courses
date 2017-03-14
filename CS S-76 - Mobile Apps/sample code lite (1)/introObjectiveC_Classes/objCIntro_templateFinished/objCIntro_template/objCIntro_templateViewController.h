//
//  objCIntro_templateViewController.h
//  objCIntro_template
//
//  Created by Shawn Arney on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shape.h"

@interface objCIntro_templateViewController : UIViewController <shapeDisplay>

    @property (nonatomic, retain) IBOutlet UIButton *btnClickMe;

    -(void) buttonClicked:(id) selector; //UIControlEvent

@end


