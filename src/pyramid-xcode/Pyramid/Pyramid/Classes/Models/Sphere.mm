//
//  Pyramid.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 10/04/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "Sphere.h"
#import "CC3PODResourceNode.h"

@implementation Sphere

- (id) init {
	CC3ResourceNode* sphereResourceNode = [CC3PODResourceNode nodeFromFile: @"sphere.pod"];
    CC3Node * sphereNodeSource = sphereResourceNode.children[0];
    CC3Node * sphereNode = [sphereNodeSource copyWithName:[NSString stringWithFormat:@"%@%@", sphereNodeSource, @"Copy"]];
    sphereNode.location = cc3v(1, -1, 1);
    sphereNode.scale = cc3v(0.2, 0.2, 0.2);
    
    self = [self initWithNode:sphereNode mass:1];
    self->btBody->setSleepingThresholds(0.0, 0.0);
    return self;
}

- (void) initPhysics:(float) mass restitution:(float)restitution friction:(float)friction {
    CC3MeshNode* node = (CC3MeshNode*) cc3Node;
    btShape = new btSphereShape((node.boundingBox.maximum.x - node.boundingBox.minimum.x)/2*0.2);
    [self createBodyWithMass:mass restitution:restitution friction:friction];
}

- (id) clone:(NSString *) name {
    return [[Sphere alloc]
            initWithNode:[self->cc3Node copyWithName: name]
                mass: btBody->getInvMass()
                restitution:btBody->getRestitution()
                friction:btBody->getFriction()];
}

- (void) setSize:(int)size {
    BOOL enabled = self.enabled;
    if (enabled) {
        self.enabled = false;
    }
    
    CC3MeshNode* node = (CC3MeshNode*) cc3Node;
    float scale = 0.2 + 0.05*(size-1);
    node.uniformScale = scale;
    ((btSphereShape *)btShape)->setUnscaledRadius((node.boundingBox.maximum.x - node.boundingBox.minimum.x)/2*scale*0.85);
    
    self.enabled = enabled;
}

@end
