//
//  Node.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 10/04/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//
#import "AppController.h"
#import "Node.h"

@implementation Node

- (id) init {
    @throw [NSException	exceptionWithName: @"MethodIsNotImplemented" reason: @"Method is not implemented." userInfo:nil];
}

- (id) initWithNode:(CC3Node*)node mass:(float)mass restitution:(float)restitution friction:(float)friction {
    cc3Node = node;
    [self initPhysics:mass restitution:restitution friction:friction];
    return self;
}

- (id) initWithNode:(CC3Node*)node mass:(float)mass {
    cc3Node = node;
    [self initPhysics:mass restitution:0.2f friction:0.1f];
    return self;
}

- (void) createBodyWithMass:(float)mass restitution:(float)restitution friction:(float)friction {
    btQuaternion rotation;
    rotation.setEulerZYX(0,0,0);

    btVector3 position = btVector3(cc3Node.location.x, cc3Node.location.y, cc3Node.location.z);
    btDefaultMotionState* motionState = new btDefaultMotionState(btTransform(rotation, position));
    btScalar bodyMass = mass;
    btVector3 bodyInertia;
    
    btShape->calculateLocalInertia(bodyMass, bodyInertia);
    
    btRigidBody::btRigidBodyConstructionInfo bodyCI = btRigidBody::btRigidBodyConstructionInfo(bodyMass, motionState, btShape, bodyInertia);
    
    bodyCI.m_restitution = restitution;
    bodyCI.m_friction = friction;
    bodyCI.m_rollingFriction = 0.001;
    btBody = new btRigidBody(bodyCI);
    
    btBody->setUserPointer((__bridge void*)self);
    btBody->setLinearFactor(btVector3(1,1,1));
}

-(void)initPhysics:(float)mass restitution:(float)restitution friction:(float)friction{}

- (BOOL) enabled {
    return cc3Node.visible;
}

- (void) setEnabled:(BOOL)enabled {
    if (cc3Node.visible == enabled) return;
    if (enabled) {
        self.world->addRigidBody(btBody);
    } else {
        self.world->removeCollisionObject(btBody);
    }
    cc3Node.visible = enabled;
}

- (btDiscreteDynamicsWorld *) world {
    return ((AppController *) [AppController instance])->pyramidScene->world;
}

@end
