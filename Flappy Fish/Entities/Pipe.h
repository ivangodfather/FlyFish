//
//  Tube.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 17/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

static const float kPipeMoveDuration = 4;

#import "Obstacle.h"

@interface Pipe : Obstacle
- (instancetype)initWithScene:(MyScene *)myScene;
+ (void)moveNewObstacle:(Obstacle *)newObstacle fromLastObstacle:(Obstacle *)lastObstacle withScene:(MyScene *)scene;
@end
