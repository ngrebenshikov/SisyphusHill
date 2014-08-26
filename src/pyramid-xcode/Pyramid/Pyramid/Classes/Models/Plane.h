//
//  Plane.h
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 05/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "Node.h"

@interface Plane : Node

- (id) init:(NSString *)name location:(CC3Vector)location rotation:(CC3Vector)rotation color:(ccColor3B)color;

@end
