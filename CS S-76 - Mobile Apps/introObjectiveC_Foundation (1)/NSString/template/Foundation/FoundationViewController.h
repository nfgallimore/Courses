//
//  FoundationViewController.h
//  Foundation
//
//  Created by Shawn Arney on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// (31) adds <UITextFieldDelegate> as delegate protocol
// now foundation view controller will be able to override methods available to UITextField
@interface FoundationViewController : UIViewController <UITextFieldDelegate>

/*
 PROPERTIES
*/

// (1) updates hangman image as user loses
@property (nonatomic, retain) IBOutlet UIImageView *hangmanImage;   

// (2) hangman word label
@property (nonatomic, retain) IBOutlet UILabel *hangmanWordLabel;

// (3) tracks the correct word
@property (nonatomic, retain) NSString *correctWord;

// (4) records wrong letters user entered
@property (nonatomic, retain) NSString *wrongLetters;


/*
 FUNCTIONS
*/

// (5) checks if the inputted letter is correct
- (void) checkHangmanLetter: (NSString *) letterToCheck;

// (6) sets up app with initial hangman word
- (void) setupHangmanWord: (NSString *) hangmanWord;
@end
