//
//  MainMenuViewController.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 05/06/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit/FlatUIKit.h>

#import "UniversalUIViewController.h"

@interface MainMenuViewController : UniversalUIViewController

@property IBOutlet FUIButton * startButton;
@property IBOutlet FUIButton * shareButton;
@property IBOutlet UILabel * titleLabel;
@property IBOutlet UILabel * descriptionLabel;

- (IBAction)startGame:(id)sender;
- (IBAction)share:(id)sender;


@end
