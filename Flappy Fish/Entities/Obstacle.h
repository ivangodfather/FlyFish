//
//  Obstacles.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 19/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Entity.h"
@import GameKit;

@interface Obstacle : Entity

- (void)addPlayer:(GKPlayer *)player;
+ (Obstacle *)spawnWithScene:(MyScene *)myScene;
+ (void)moveNewObstacle:(Obstacle *)newObstacle fromLastObstacle:(Obstacle *)lastObstacle withScene:(MyScene *)scene;
+ (NSUInteger)numberOfInstances;
+ (void)resetNumberOfInstances;
@end
