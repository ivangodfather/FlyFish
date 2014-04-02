//
//  Rain.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 18/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

static const float kRainDuration = 8;
#import "Emitter.h"

@interface Rain : Emitter
- (instancetype)initWithScene:(MyScene *)myScene;
@end
