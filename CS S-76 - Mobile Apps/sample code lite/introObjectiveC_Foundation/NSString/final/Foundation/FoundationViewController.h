//
//  FoundationViewController.h
//  Foundation
//
//  Created by Shawn Arney on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundationViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *hangmanImage;
@property (nonatomic, retain) IBOutlet UILabel *hangmanWordLabel;
@property (nonatomic, retain) NSString *correctWord;
@property (nonatomic, retain) NSString *wrongLetters;

- (void) checkHangmanLetter: (NSString *) letterToCheck;
- (void) setupHangmanWord: (NSString *) hangmanWord;

@end
