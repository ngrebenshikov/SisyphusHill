//
//  SuccessDialogDelegate.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 27/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "SuccessDialogDelegate.h"
#import "AppController.h"
#import "SharingManager.h"
#import "Utils.h"


@implementation SuccessDialogDelegate {
    int level;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AppController * app = [AppController instance];
    if (buttonIndex == 0) {
        [[SharingManager instance] shareScore:app->gameViewController level:app->game.level.number timeString: [Utils getTimeIntervalString:app->game.level.resultSeconds]];
    } else if (buttonIndex == 1) {
        level = app->game.level.number+1;
        if (level > 9) {
            level = 1;
        }
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startGame) userInfo:nil repeats:false];
    } else if (buttonIndex == 2) {
        [app stopGame];
    }
}

- (void) startGame {
    AppController * app = [AppController instance];
    [app startGame:level];
}

@end
