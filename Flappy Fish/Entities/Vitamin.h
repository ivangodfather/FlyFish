//
//  Vitamin.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 28/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Entity.h"
static const float kVitaminMoveDuration = 4;



@interface Vitamin : Entity

- (instancetype)initWithTexture:(SKTexture *)texture scene:(MyScene *)myScene;
- (void)applyActionsToPlayer;
+ (Vitamin *)spawnWithScene:(MyScene *)myScene;
+ (Vitamin *)lastAdded;
+ (void)setLastAdded:(Vitamin *)vitamin;
+ (CGFloat)spawnDelay;

@end
