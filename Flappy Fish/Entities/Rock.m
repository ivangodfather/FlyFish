//
//  Rock.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Rock.h"
static const float kRockMoveDuration = 5;


@implementation Rock

- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"rock"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.name = @"rock";
        self.scale = RandomFloatRange(0.5,1);
    }
    return self;
}

-(float)moveDuration
{
    return kRockMoveDuration;
}

@end
