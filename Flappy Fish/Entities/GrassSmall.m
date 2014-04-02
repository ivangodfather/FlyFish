//
//  GrassSmall.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "GrassSmall.h"

@implementation GrassSmall

- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"grasssmall"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.name = @"grasssmall";
        self.scale = RandomFloatRange(0.5, 1);
    }
    return self;
}

@end
