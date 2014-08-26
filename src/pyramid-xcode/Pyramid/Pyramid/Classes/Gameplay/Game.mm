//
//  Game.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 22/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "GameViewController.h"
#import "Utils.h"
#import "SoundManager.h"
#import <Foundation/Foundation.h>

#import "Game.h"

@implementation Game {
    NSTimer * timer;
    GameViewController * _viewController;
    void ( ^ successHandler )( int );
    void ( ^ failureHandler )( void );
    int activeBallsNumber;
}

- (id) initWithViewController: (GameViewController *) viewController success:(void (^)(int))success failure:(void (^)(void))failure {
    self = [self init];
    _viewController = viewController;
    successHandler = success;
    failureHandler = failure;
    return self;
}

- (void) start:(Level*) level {
    self.level = level;
    activeBallsNumber = self.level.getBallsNumber;
    
    if (level.hasResult) {
        _viewController.progress.hidden = NO;
        _viewController.progress.progress = 0.0;
        self.time = self.level.resultSeconds;
    } else {
        self.time = 0;
    }

    [self startTimer];
    for (int i = 0; i < 3; i++) {
        [[SoundManager instance] playRollingSphereSound:i];
    }
}

- (void) startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void) stop {
    [timer invalidate];
    timer = NULL;
    for (int i = 0; i < 3; i++) {
        [[SoundManager instance] stopRollingSphereSound:i];
    }
}

- (void) onTimer {
    self.time += (self.level.hasResult) ? -1 : 1;
    
    if (self.level.hasResult && self.time <= 0) {
        if (NULL != failureHandler) {
            [self stop];
            [[SoundManager instance] playGameOverSound];
            [_viewController showGameOverDialog];
            failureHandler();
        }
    }

    _viewController.timeLabel.text = [Utils getTimeIntervalString:self.time];
    _viewController.progress.progress = MIN(1.0, (self.level.resultSeconds - self.time) / self.level.resultSeconds);
}

- (void) pause {
    [self stop];
}

- (void) resume {
    [self startTimer];
}


- (void)ballInHoleHandler {
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:[SoundManager instance] selector:@selector(playBallInsideSound) userInfo:nil repeats:false];
    activeBallsNumber -= 1;
    int spentTime = [self getSpentTime];
    if (activeBallsNumber <= 0 && ((self.level.hasResult && self.level.resultSeconds > spentTime) || !self.level.hasResult)) {
        [self stop];
        [[SoundManager instance] playVictorySound];
        [_viewController showSuccessDialog:spentTime];
        self.level.resultSeconds = spentTime;
        successHandler(spentTime);
    }
}

- (int) getSpentTime {
    return self.level.hasResult ? self.level.resultSeconds - self.time : self.time;
}

- (void) restart {
    [self stop];
    [self start:self.level];
}

@end
