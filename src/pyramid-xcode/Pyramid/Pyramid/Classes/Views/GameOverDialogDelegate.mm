//
//  GameOverDialogDelegate.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 03/06/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "GameOverDialogDelegate.h"
#import "AppController.h"

@implementation GameOverDialogDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    AppController * app = [AppController instance];
    if (buttonIndex == 0) {
        [app restartGame];
    } else if (buttonIndex == 1){
        [app stopGame];
    }
}

@end
