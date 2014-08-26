//
//  Pyramid.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 10/04/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "Pyramid.h"
#include "CC3MeshNode.h"
#include "CC3VertexArrayMesh.h"
#import "CC3PODResourceNode.h"
#include "btBulletDynamicsCommon.h"

@implementation Pyramid

- (id)init {
	CC3ResourceNode* pyramidResourceNode = [CC3PODResourceNode nodeFromFile: @"pyramid-new-mono.pod"];
    pyramidResourceNode.location = cc3v(0, 0, -3.24);
    pyramidResourceNode.rotation = cc3v(0,0,15);

	CC3ResourceNode* pyramidResourceNodeForPhysics = [CC3PODResourceNode nodeFromFile: @"pyramid-new.pod"];
    pyramidResourceNodeForPhysics.location = cc3v(0, 0, -3.24);
    pyramidResourceNodeForPhysics.rotation = cc3v(0,0,15);
    
    self = [self initWithNode:pyramidResourceNodeForPhysics mass:0.0];
    self->cc3Node = pyramidResourceNode;
    
    return self;
}

- (void) initPhysics:(float)mass restitution:(float)restitution friction:(float)friction {
    
    btCompoundShape * compoundShape = new btCompoundShape();

    for (int i=0; i < cc3Node.children.count; i++) {
        CC3MeshNode * node = (CC3MeshNode*) cc3Node.children[i];
        
        size_t indicesSize = node.mesh.faceCount*3*sizeof(GLushort);
        unsigned char * indices =  (unsigned char *)malloc(indicesSize);
        memcpy(indices, node.mesh.vertexIndices.vertices, indicesSize);
        
        size_t locationsSize = node.mesh.vertexCount*3*sizeof(float);
        unsigned char * locations = (unsigned char *)malloc(locationsSize);
        memcpy(locations, node.mesh.vertexLocations.vertices, locationsSize);
        
        btConvexHullShape * hull = new btConvexHullShape((const btScalar *)locations, node.mesh.vertexCount, 3*sizeof(float));

        btTransform trans = btTransform();
        trans.setIdentity();
        
        compoundShape->addChildShape(trans, hull);
    }
    
    btShape = compoundShape;

    [self createBodyWithMass:mass restitution:restitution friction:friction];
}

@end
