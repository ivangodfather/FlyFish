//
//  Enemy.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 17/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Entity.h"

@interface Enemy : Entity

- (void)attachPhysicsBodyToSpriteWithMarginWidth:(float)marginWidth marginHeight:(float)marginHeight;
+ (Enemy *)spawnWithScene:(MyScene *)myScenes;
- (void)applyActionsToPlayer:(Enemy *)enemy;
- (int)force;

@end
