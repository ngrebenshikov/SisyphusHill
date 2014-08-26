//
//  AppController.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 14/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "CC3CC2Extensions.h"

#import "PyramidLayer.h"
#import "PyramidScene.h"
#import "SoundManager.h"

#import "AppController.h"

@implementation AppController

+ (id)instance {
    static AppController *c = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        c = [[self alloc] init];
    });
    return c;
}

+ (void) startApplication {
    AppController * app = [AppController instance];
    [app showMainView];
    //[app startGame:1];
}

- (id)init {
    if (self = [super init]) {
        // Create the window, make the controller (and its view) the root of the window, and present the window
        self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [self initCocos3d];
        [self initLevels];

    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (void) startGame:(int)level {
    [self updateSpheres:level];
    
    gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    [gameViewController.view insertSubview:self.ccViewController.view atIndex:0];
    [gameViewController willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0.0];
    [self.window addSubview: gameViewController.view];
    self.window.rootViewController = gameViewController;
    [self.window makeKeyAndVisible];
    if (NULL == [[CCDirector sharedDirector] runningScene]) {
        [CCDirector.sharedDirector runWithScene: ccScene];
    } else {
        [[CCDirector sharedDirector] resume];
    }
    
    game = [[Game alloc] initWithViewController:gameViewController
                                        success:^(int resultSeconds) {
                                            [self.levelViewController updateButtons];
                                        }
                                        failure:^{}];
    [game start:self.levels[level-1]];
    
    pyramidScene.paused = false;
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    
}

- (void) pauseGame {
    pyramidScene.paused = true;
    [game pause];
}

- (void) resumeGame {
    pyramidScene.paused = false;
    [game resume];
}

- (void) restartGame {
    [self updateSpheres:game.level.number];
    [game restart];
    pyramidScene.paused = false;
}

- (void)  stopGame {
    pyramidScene.paused = true;
    [game stop];
    [[CCDirector sharedDirector ] pause];
    [self showMainView];
}

- (void) showLevelSelectionView {
    if (nil == self.levelViewController) {
        self.levelViewController= [[LevelSelectionViewController alloc] initWithNibName:@"LevelSelectionViewController" bundle:nil];
    }
    self.window.rootViewController = self.levelViewController;
    [self.window makeKeyAndVisible];
}

- (void) showMainView {
    if (nil == self.mainMenuViewController) {
        self.mainMenuViewController= [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    }
    self.window.rootViewController = self.mainMenuViewController;
    [self.window makeKeyAndVisible];
}

- (void) updateSpheres:(int) level {

    int size = [Level getBallSize:level];
    int ballsNumber = [Level getBallsNumber:level];
    
    for (int i = 1; i <= 3; i++) {
        [pyramidScene updateSphere:i visibile:(i <= ballsNumber) size:size];
    }
}

- (void) initLevels {
    NSMutableArray * levels = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 9; i++) {
        [levels addObject:[[Level alloc] initWithNumber:i]];
    }
    self.levels = levels;
}

-(void) establishCocos3dDirectorController {
	self.ccViewController = CC3DeviceCameraOverlayUIViewController.sharedDirector;
	self.ccViewController.supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
	self.ccViewController.viewShouldUseStencilBuffer = YES;		// Set to YES if using shadow volumes
	self.ccViewController.viewPixelSamples = 1;					// Set to 4 for antialiasing multisampling
	self.ccViewController.animationInterval = (1.0f / FRAME_RATE);
	//self.ccViewController.displayStats = YES;
	[self.ccViewController enableRetinaDisplay: YES];
}

-(void) initCocos3d {
    if (nil == self.ccViewController) {
        [self establishCocos3dDirectorController];
        
        // Create the customized CC3Layer that supports 3D rendering.
        CC3Layer* cc3Layer = [PyramidLayer layer];
        
        // Create the customized 3D scene and attach it to the layer.
        // Could also just create this inside the customer layer.
        pyramidScene = [PyramidScene scene];
        cc3Layer.cc3Scene = pyramidScene;
        
        // Assign to a generic variable so we can uncomment options below to play with the capabilities
        CC3ControllableLayer* controlledLayer = cc3Layer;
        
        // Set the layer in the controller
        self.ccViewController.controlledNode = controlledLayer;
        
        // Wrap the layer in a 2D scene and run it in the director
        ccScene = [CCScene node];
        [ccScene addChild: controlledLayer];
    }
}

- (void) ballInHoleHandler {
    [game ballInHoleHandler];
    [gameViewController showBallSuccess];
}

@end
