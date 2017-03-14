//
//  Shape.h
//  objCIntro_template
//
//  Created by Shawn Arney on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Shape;

@protocol shapeDisplay 

//@optional
- (void) shapeDisplayed: (Shape *) myShape;

@end

@interface Shape : NSObject
{
    @package
        int y;
}

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, retain) NSMutableArray *ary;
@property (nonatomic, readwrite) int x;

- (void) displayImageOnView :(UIView *) view;
- (void) displayImageComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@property (retain) id <NSObject, shapeDisplay > delegateShapeDisplay; 

@end

