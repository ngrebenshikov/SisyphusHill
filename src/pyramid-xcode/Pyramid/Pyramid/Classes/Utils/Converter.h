//
//  Converter.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 06/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "btBulletCollisionCommon.h"
#import "CC3World.h"

@interface Converter : NSObject

+(btVector3) convert:(CC3Vector)v;

@end
