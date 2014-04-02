//
//  Bug.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 14/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

static const float kBugMarginWidth = 0.8;
static const float kBugMarginHeight = 0.8;
static const float kBugMoveDuration = 4;
static const float kBugForce = 50;


#import "Enemy.h"

@interface Bug : Enemy
- (instancetype)initWithScene:(MyScene *)myScene;
@end
