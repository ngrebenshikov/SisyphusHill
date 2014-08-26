//
//  SoundManager.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 17/06/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface SoundManager : NSObject {
    ALCcontext* context;
    ALCdevice*  device;
    NSMutableArray*    bufferStorageArray;
    NSMutableDictionary* soundDictionary;
}
+ (SoundManager *) instance;
- (void) playRollingSphereSound:(int)sphereIndex;
- (void) stopRollingSphereSound:(int)sphereIndex;
- (void) playCollisionSound:(int)sphereIndex withVolume:(float)volume;
- (void) changeRollingSphereVelocity:(int)sphereIndex velocity:(float)velocity;
- (void) playGameOverSound;
- (void) playBallInsideSound;
- (void) playVictorySound;

@end
