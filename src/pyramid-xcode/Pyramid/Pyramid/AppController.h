//
//  AppController.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 14/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CC3DeviceCameraOverlayUIViewController.h"

#import "LevelSelectionViewController.h"
#import "PyramidScene.h"
#import "Level.h"
#import "Game.h"
#import "GameViewController.h"
#import "MainMenuViewController.h"

#define FRAME_RATE		30		// Animation frame rate

@interface AppController : NSObject {
    CCScene *ccScene;
    @public Game * game;
    @public PyramidScene *pyramidScene;
    GameViewController * gameViewController;
}

@property UIWindow * window;
@property CC3DeviceCameraOverlayUIViewController * ccViewController;
@property LevelSelectionViewController * levelViewController;
@property MainMenuViewController * mainMenuViewController;
@property NSArray * levels;

+ (id)instance;
+ (void) startApplication;

- (void) startGame:(int)level;
- (void) pauseGame;
- (void) resumeGame;
- (void) stopGame;
- (void) restartGame;

- (void) showLevelSelectionView;
- (void) showMainView;
- (void) showShareView;

- (void) ballInHoleHandler;

@end
