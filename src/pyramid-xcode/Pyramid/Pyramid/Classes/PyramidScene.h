/**
 *  PyramidScene.h
 *  Pyramid
 *
 *  Created by Nickolay Grebenshikov on 19/03/14.
 *  Copyright Nickolay Grebenshikov 2014. All rights reserved.
 */


#import <CoreMotion/CoreMotion.h>
#import "CC3Scene.h"

#include "btBulletDynamicsCommon.h"
#include "btBulletCollisionCommon.h"


#define CAMERA_HEIGHT (15.0f)
#define G (5*9.81f)

@interface PyramidScene : CC3Scene {
    @public btDiscreteDynamicsWorld *world;
}

@property bool paused;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CMAttitude *referenceAttitude;

- (void) updateSphere:(int)index visibile:(BOOL)visible size:(int)size;

@end
