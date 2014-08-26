//
//  GameViewController.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 21/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "UniversalUIViewController.h"

@interface GameViewController : UniversalUIViewController<FUIAlertViewDelegate>

@property IBOutlet UILabel * timeLabel;
@property IBOutlet UIProgressView * progress;
@property IBOutlet FUIButton * pauseButton;
@property IBOutlet UILabel * ballSuccessLabel;

- (void) showBallSuccess;
- (void) showSuccessDialog:(int)resultSeconds;
- (void) showGameOverDialog;

@end
