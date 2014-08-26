/**
 *  PyramidScene.m
 *  Pyramid
 *
 *  Created by Nickolay Grebenshikov on 19/03/14.
 *  Copyright Nickolay Grebenshikov 2014. All rights reserved.
 */

#import "PyramidScene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CC3UtilityMeshNodes.h"
#import "CC3ShadowVolumes.h"
#import "Utils/Utils.h"
#import "AppController.h"
#import "SoundManager.h"

#include "Pyramid.h"
#include "Sphere.h"
#include "Models/Plane.h"


@implementation PyramidScene {
    btBroadphaseInterface*                  broadphase;
    btDefaultCollisionConfiguration*        collisionConfiguration;
    btCollisionDispatcher*                  dispatcher;
    btSequentialImpulseConstraintSolver*    solver;
    
    Pyramid * pyramid;
    Plane * ground;
    btRigidBody * groundBody;
    Sphere * spheres[3];
}

- (void) initializeScene {
    
	[self initPhysics];
    
    pyramid = [[Pyramid alloc] init];
    [self addChild: pyramid->cc3Node];
    world->addRigidBody(pyramid->btBody);
    

    //Spheres
    for (int i=0; i < 3; i++) {
        spheres[i] = [[Sphere alloc] init];
        [self addChild: spheres[i]->cc3Node];
        world->addRigidBody(spheres[i]->btBody);
    }
    
    ground = [[Plane alloc] init:@"ground" location:cc3v(0, 0, -1) rotation:cc3v(0,0,0) color:ccc3(0x43, 0x82, 0xb7)];
    [self addChild: ground->cc3Node];
    world->addRigidBody(ground->btBody);
    
    //Plane right
    {
        Plane * p = [[Plane alloc] init:@"right-bound" location:cc3v(4, 0, 0) rotation:cc3v(0,-60,0) color:ccc3(0x53, 0x92, 0xc7)];
        [self addChild: p->cc3Node];
        world->addRigidBody(p->btBody);
    }

    //Plane left
    {
        Plane * p = [[Plane alloc] init:@"left-bound" location:cc3v(-4, 0, 0) rotation:cc3v(0,60,0) color:ccc3(0x53, 0x92, 0xc7)];
        [self addChild: p->cc3Node];
        world->addRigidBody(p->btBody);
    }

    //Plane front
    {
        Plane * p = [[Plane alloc] init:@"front-bound" location:cc3v(0, -4, 0) rotation:cc3v(-60,0,0) color:ccc3(0x63, 0xa2, 0xd7)];
        [self addChild: p->cc3Node];
        world->addRigidBody(p->btBody);
    }

    //Plane back
    {
        Plane * p = [[Plane alloc] init:@"back-bound" location:cc3v(0, 4, 0) rotation:cc3v(60,0,0) color:ccc3(0x63, 0xa2, 0xd7)];
        [self addChild: p->cc3Node];
        world->addRigidBody(p->btBody);
    }

    //Plane top
    {
        Plane * p = [[Plane alloc] init:@"back-bound" location:cc3v(0, 0, 12) rotation:cc3v(180,0,0) color:ccc3(0x63, 0xa2, 0xd7)];
        world->addRigidBody(p->btBody);
    }


	// Create the camera, place it back a bit, and add it to the scene
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v(0, 0, CAMERA_HEIGHT );
    cam.forwardDirection = cc3v(0, 0, -CAMERA_HEIGHT);
	[self addChild: cam];

	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp1"];
	lamp.location = cc3v(-4, -4, 2);
    lamp.forwardDirection = cc3v(4, 4, -0.5);
    lamp.attenuation = CC3AttenuationCoefficientsMake(0, 0, 0.03);
    //lamp.spotCutoffAngle = 60;
	lamp.isDirectionalOnly = NO;
	[self addChild: lamp];

	CC3Light* lamp1 = [CC3Light nodeWithName: @"Lamp2"];
	lamp1.location = cc3v(4, 4, 2 );
    lamp1.forwardDirection = cc3v(-4, -4, -0.5);
    lamp1.attenuation = CC3AttenuationCoefficientsMake(0, 0, 0.03);
    //lamp1.spotCutoffAngle = 60;
	lamp1.isDirectionalOnly = NO;
	[self addChild: lamp1];

	CC3Light* lamp3 = [CC3Light nodeWithName: @"Lamp3"];
	lamp3.location = cc3v(0, 0, 10);
	lamp3.isDirectionalOnly = NO;
    lamp3.attenuation = CC3AttenuationCoefficientsMake(0, 0, 0.15);
	[self addChild: lamp3];

    // Create a CMMotionManager
    self.motionManager = [[CMMotionManager alloc] init];
    
    // Tell CoreMotion to show the compass calibration HUD when required
    // to provide true north-referenced attitude
    self.motionManager.showsDeviceMovementDisplay = YES;
    self.motionManager.deviceMotionUpdateInterval = 1.0/30.0;
    
    // Attitude that is referenced to true north
    [self.motionManager startDeviceMotionUpdates];

    self.opacity = 255;
    for (int i=0; i < 3; i++) {
        [spheres[i]->cc3Node addShadowVolumesForLight:lamp3];
    }
	[self selectShaders];
	[self createBoundingVolumes];
	[self createGLBuffers];
	[self releaseRedundantContent];
}

/**
 * By populating this method, you can add add additional scene content dynamically and
 * asynchronously after the scene is open.
 *
 * This method is invoked from a code block defined in the onOpen method, that is run on a
 * background thread by the CC3Backgrounder available through the backgrounder property.
 * It adds content dynamically and asynchronously while rendering is running on the main
 * rendering thread.
 *
 * You can add content on the background thread at any time while your scene is running, by
 * defining a code block and running it on the backgrounder. The example provided in the
 * onOpen method is a template for how to do this, but it does not need to be invoked only
 * from the onOpen method.
 *
 * Certain assets, notably shader programs, will cause short, but unavoidable, delays in the
 * rendering of the scene, because certain finalization steps from shader compilation occur on
 * the main thread when the shader is first used. Shaders and certain other critical assets can
 * be pre-loaded and cached in the initializeScene method, prior to the opening of this scene.
 */
-(void) addSceneContentAsynchronously {}


#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities after
 * the transformMatrix of the 3D nodes in the scen have been recalculated.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {}


#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {

	// Add additional scene content dynamically and asynchronously, on a background thread
	// after rendering has begun on the rendering thread, using the CC3Backgrounder singleton.
	// Asynchronous loading must be initiated after the scene has been attached to the view.
	// It cannot be started in the initializeScene method. However, it does not need to be
	// invoked only from the onOpen method. You can use the code in the line here as a template
	// for use whenever your app requires background content loading after the scene has opened.
	[CC3Backgrounder.sharedBackgrounder runBlock: ^{ [self addSceneContentAsynchronously]; }];

	// Move the camera to frame the scene. The resulting configuration of the camera is output as
	// an [info] log message, so you know where the camera needs to be in order to view your scene.
	//[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self fromDirection: cc3v( 0.0, 0.0, 1.0 ) withPadding: 0.1f ];

	// Uncomment this line to draw the bounding box of the scene.
//	self.shouldDrawWireframeBox = YES;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Drawing

/**
 * Template method that draws the content of the scene.
 *
 * This method is invoked automatically by the drawScene method, once the 3D environment has
 * been established. Once this method is complete, the 2D rendering environment will be
 * re-established automatically, and any 2D billboard overlays will be rendered. This method
 * does not need to take care of any of this set-up and tear-down.
 *
 * This implementation simply invokes the default parent behaviour, which turns on the lighting
 * contained within the scene, and performs a single rendering pass of the nodes in the scene 
 * by invoking the visit: method on the specified visitor, with this scene as the argument.
 * Review the source code of the CC3Scene drawSceneContentWithVisitor: to understand the
 * implementation details, and as a starting point for customization.
 *
 * You can override this method to customize the scene rendering flow, such as performing
 * multiple rendering passes on different surfaces, or adding post-processing effects, using
 * the template methods mentioned above.
 *
 * Rendering output is directed to the render surface held in the renderSurface property of
 * the visitor. By default, that is set to the render surface held in the viewSurface property
 * of this scene. If you override this method, you can set the renderSurface property of the
 * visitor to another surface, and then invoke this superclass implementation, to render this
 * scene to a texture for later processing.
 *
 * When overriding the drawSceneContentWithVisitor: method with your own specialized rendering,
 * steps, be careful to avoid recursive loops when rendering to textures and environment maps.
 * For example, you might typically override drawSceneContentWithVisitor: to include steps to
 * render environment maps for reflections, etc. In that case, you should also override the
 * drawSceneContentForEnvironmentMapWithVisitor: to render the scene without those additional
 * steps, to avoid the inadvertenly invoking an infinite recursive rendering of a scene to a
 * texture while the scene is already being rendered to that texture.
 *
 * To maintain performance, by default, the depth buffer of the surface is not specifically
 * cleared when 3D drawing begins. If this scene is drawing to a surface that already has
 * depth information rendered, you can override this method and clear the depth buffer before
 * continuing with 3D drawing, by invoking clearDepthContent on the renderSurface of the visitor,
 * and then invoking this superclass implementation, or continuing with your own drawing logic.
 *
 * Examples of when the depth buffer should be cleared are when this scene is being drawn
 * on top of other 3D content (as in a sub-window), or when any 2D content that is rendered
 * behind the scene makes use of depth drawing. See also the closeDepthTestWithVisitor:
 * method for more info about managing the depth buffer.
 */
-(void) drawSceneContentWithVisitor: (CC3NodeDrawingVisitor*) visitor {

    if (!self.paused) {
        float h = CAMERA_HEIGHT;
        float g = G;
        
        
        CMAttitude * attitude = self.motionManager.deviceMotion.attitude;
        
        if (NULL != attitude) {
            
            float roll = [Utils minByAbs:attitude.roll absolut:M_PI_4];
            float pitch = [Utils minByAbs:attitude.pitch absolut:M_PI_4];
            
            self.activeCamera.location = cc3v(h * cos(roll) * sin(pitch), h * sin(roll) * cos(pitch), h*cos(roll));
            self.activeCamera.targetLocation = cc3v(0,0,0);

            world->setGravity(btVector3(-g * cos(roll) * sin(pitch),
                                        -g * sin(roll) * cos(pitch),
                                        -g*cos(roll)));

        }
        
        // Save velocity before simultation step
        btVector3 prevV[3];
        for (int i = 0; i < 3; i++) {
            prevV[i] = spheres[i]->btBody->getLinearVelocity();
        }
        
        world->stepSimulation(visitor.deltaTime);
        
        //Update spheres and play sounds
        for (int i = 0; i < 3; i++) {
            if (!spheres[i].enabled) continue;
            btTransform trans = spheres[i]->btBody->getWorldTransform();
            spheres[i]->cc3Node.location = cc3v(trans.getOrigin().x(),trans.getOrigin().y(),trans.getOrigin().z());
            spheres[i]->cc3Node.quaternion = CC3Vector4Make(trans.getRotation().getX(), trans.getRotation().getY(), trans.getRotation().getZ(), trans.getRotation().getW());
            
            btVector3 v = spheres[i]->btBody->getLinearVelocity();
            btVector3 subV = spheres[i]->btBody->getLinearVelocity();
            subV -= prevV[i];
            
            
            [self checkSphereInHole:spheres[i]];
            if ([self hasSphereContact:spheres[i]]) {
                float strength = subV.length();
                if (strength > 1.5) {
                    //NSLog(@"|(%f,%f,%f) - (%f,%f,%f)| = %f", prevV.getX(), prevV.getY(), prevV.getZ(), v.getX(), v.getY(), v.getZ(), subV.length());
                    [[SoundManager instance] playCollisionSound:i withVolume:MIN(0.1, strength/200)];
                }
                
                [[SoundManager instance] changeRollingSphereVelocity:i velocity:sqrtf(spheres[i]->btBody->getLinearVelocity().length()/100)];
                [[SoundManager instance] playRollingSphereSound:i];
            } else {
                [[SoundManager instance] stopRollingSphereSound:i];
            }
        }
    }

    [super drawSceneContentWithVisitor: visitor];
}

- (BOOL) hasSphereContact: (Sphere *) s {
    int numManifolds = world->getDispatcher()->getNumManifolds();
	for (int i=0; i < numManifolds; i++)
	{
		btPersistentManifold* contactManifold =  world->getDispatcher()->getManifoldByIndexInternal(i);
        if (contactManifold->getBody0() == s->btBody || contactManifold->getBody1() == s->btBody) {
            int numContacts = contactManifold->getNumContacts();
            if (numContacts > 0) {
                return true;
            }
        }
    }
    return false;
}

- (void) checkSphereInHole:(Sphere *) s {
    if (s.enabled) {
        float x = s->cc3Node.location.x;
        float y = s->cc3Node.location.y;
        if (sqrtf(x*x + y*y) < 0.1) {
            AppController * app = [AppController instance];
            [app ballInHoleHandler];
            s.enabled = false;
        }
    }
}


#pragma mark Handling touch events

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touc
 h events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {}

/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {}


#pragma mark Bullet Physics staff
-(void)initPhysics
{
    broadphase = new btDbvtBroadphase();
    collisionConfiguration = new btDefaultCollisionConfiguration();
    dispatcher = new btCollisionDispatcher(collisionConfiguration);
    solver = new btSequentialImpulseConstraintSolver();
    world = new btDiscreteDynamicsWorld(dispatcher, broadphase, solver, collisionConfiguration);
    world->setGravity(btVector3(0, 0, -G));
}

- (void) updateSphere:(int)index visibile:(BOOL)visible size:(int)size {
    Sphere * s = spheres[index-1];

    if (visible) {
        [s setSize:size];
        s.enabled = true;

        //Change location to start
        
        btTransform t = s->btBody->getWorldTransform();
        t.setOrigin(btVector3(3, 3, 5+index));
        s->btBody->setWorldTransform(t);
        s->cc3Node.location = cc3v(2, 2, 5+index);
        
    } else {
        s.enabled = false;
    }
}

@end

