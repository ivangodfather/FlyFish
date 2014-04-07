//
//  Decorate.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 17/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Entity.h"

@interface Decorate : Entity

+ (Decorate *)spawnWithScene:(MyScene *)myScene;
+ (Decorate *)lastAdded;
+ (void)setLastAdded:(Decorate *)decorate;
+ (CGFloat)spawnDelay;
@end
