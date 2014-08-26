//
//  Converter.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 06/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "Converter.h"

@implementation Converter

+(btVector3) convert:(CC3Vector)ccV {
    return btVector3(ccV.x, ccV.y, ccV.z);
}

@end
