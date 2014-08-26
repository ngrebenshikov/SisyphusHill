//
//  LevelSelectionViewController.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 13/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversalUIViewController.h"

@interface LevelSelectionViewController : UniversalUIViewController

@property IBOutlet UILabel * titleLabel;

- (void) updateButtons;
@end
