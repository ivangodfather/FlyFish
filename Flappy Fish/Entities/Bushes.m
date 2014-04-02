//
//  Bushes.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 15/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Bushes.h"

@implementation Bushes

- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"bushes"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.name = @"bushes";
        self.scale = RandomFloatRange(0.5, 1);
    }
    return self;
}

@end
