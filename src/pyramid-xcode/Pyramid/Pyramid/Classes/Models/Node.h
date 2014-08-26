//
//  Node.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 10/04/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "CC3Node.h"
#include "btBulletCollisionCommon.h"
#include "btBulletDynamicsCommon.h"

@interface Node : NSObject {
    
@public
    btCollisionShape* btShape;
    CC3Node* cc3Node;
    btRigidBody* btBody;
    
}

@property BOOL enabled;
@property (readonly) btDiscreteDynamicsWorld * world;

- (id)init;
- (id)initWithNode:(CC3Node*)node mass:(float)mass;
- (id)initWithNode:(CC3Node*)node mass:(float)mass restitution:(float)restitution friction:(float)friction;
- (void)initPhysics:(float)mass restitution:(float)restitution friction:(float)friction;
- (void)createBodyWithMass:(float)mass restitution:(float)restitution friction:(float)friction;

@end
