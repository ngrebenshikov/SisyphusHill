//
//  Game.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 22/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Level.h"
#import "GameViewController.h"

@interface Game : NSObject

@property Level * level;
@property NSTimeInterval time;


- (void) start:(Level*) level;
- (id) initWithViewController:(GameViewController *) viewController success:(void (^)(int))success failure:(void (^)(void))failure;
- (void) stop;
- (void) pause;
- (void) resume;
- (void) restart;

- (void) ballInHoleHandler;
- (int) getSpentTime;

@end
