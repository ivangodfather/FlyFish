//
//  Crab.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

static const float kCrabWidthMargin = 1;
static const float kCrabHeightMargin = 1;
static const float kCrabMoveDuration = 3;
static const float kCrabForce = 300;


#import "Enemy.h"

@interface Crab : Enemy
- (instancetype)initWithScene:(MyScene *)myScene;
@end
