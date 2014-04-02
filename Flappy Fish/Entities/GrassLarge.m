//
//  GrassLarge.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "GrassLarge.h"

@implementation GrassLarge

- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"grasslarge"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.name = @"grasslarge";
        self.scale = RandomFloatRange(0.8, 1);
    }
    return self;
}

@end
