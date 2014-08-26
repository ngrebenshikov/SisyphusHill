//
//  Plane.mm
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 05/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#include <math.h>

#import "CC3MeshNode.h"
#import "CC3UtilityMeshNodes.h"

#import "Plane.h"
#import "Converter.h"

@implementation Plane

- (id) init:(NSString *)name location:(CC3Vector)location rotation:(CC3Vector)rotation color:(ccColor3B)color {
    
    CC3PlaneNode * plane = [CC3PlaneNode nodeWithName: name];
    [plane populateAsCenteredRectangleWithSize:CGSizeMake(20.0, 20.0) andTessellation:CC3TessellationMake(10, 10)];
    
    plane.location = location;
    plane.rotation = rotation;
    [plane setColor:color];
    [plane setOpacity:255];
    
    self = [self initWithNode:plane mass:0.0 restitution:0.4 friction:0.3];
    return self;
}


- (void) initPhysics:(float) mass restitution:(float)restitution friction:(float)friction {
    CC3PlaneNode* plane = (CC3PlaneNode*) cc3Node;
    
    btQuaternion rotation;
    rotation.setEulerZYX(M_PI * plane.rotation.z/180, M_PI * plane.rotation.y/180, M_PI * plane.rotation.x/180);
    
    btVector3 position = [Converter convert:plane.location];
    btDefaultMotionState* motionState = new btDefaultMotionState(btTransform(rotation, position));
    
    btStaticPlaneShape * planeShape = new btStaticPlaneShape(btVector3(0,0,1), 0);
    
    btRigidBody::btRigidBodyConstructionInfo bodyCI = btRigidBody::btRigidBodyConstructionInfo(0, motionState, planeShape);
    
    bodyCI.m_restitution = restitution;
    bodyCI.m_friction = friction;
    
    btBody = new btRigidBody(bodyCI);
    btBody->setUserPointer((__bridge void*)self);
    btBody->setLinearFactor(btVector3(1,1,1));
}

@end
