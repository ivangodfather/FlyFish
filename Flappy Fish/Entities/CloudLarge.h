//
//  CloudLarge.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Decorate.h"
static const float kCloudLargeMoveDuration = 5;

@interface CloudLarge : Decorate
- (instancetype)initWithScene:(MyScene *)myScene;
-(float)moveDuration;
@end
