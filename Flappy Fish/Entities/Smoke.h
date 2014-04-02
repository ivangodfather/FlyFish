//
//  Smoke.h
//  FlyFlish
//
//  Created by Ivan Ruiz Monjo on 14/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//


static const float kSmokeWidth = 50;
static const float kSmokeHeight = 250;
static const float kSmokeImpulse = 250;


#import "Emitter.h"

@interface Smoke : Emitter
- (instancetype)initWithScene:(MyScene *)myScene;
@end
