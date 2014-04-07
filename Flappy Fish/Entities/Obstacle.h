//
//  Obstacles.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 19/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Entity.h"
@import GameKit;
@class PlayerResult;

@interface Obstacle : Entity

- (void)addPlayerResult:(PlayerResult *)playerResult;
+ (Obstacle *)spawnWithScene:(MyScene *)myScene;
+ (void)moveNewObstacle:(Obstacle *)newObstacle fromLastObstacle:(Obstacle *)lastObstacle withScene:(MyScene *)scene;
+ (NSUInteger)numberOfInstances;
+ (void)resetNumberOfInstances;
+ (Obstacle *)lastAdded;
+ (void)setLastAdded:(Obstacle *)obstacle;
+ (CGFloat)spawnDelay;

@end
