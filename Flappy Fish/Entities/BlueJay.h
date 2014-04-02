//
//  BlueJay.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

static const float kBlueJayMarginWidth = 0.8;
static const float kBlueJayMarginHeight = 0.8;
static const float kBlueJayMoveDuration = 1.5;
static const float kBlueJayForce = 120;

#import "Enemy.h"

@interface BlueJay : Enemy

- (instancetype)initWithScene:(MyScene *)myScene;

@end
