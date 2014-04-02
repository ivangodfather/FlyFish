//
//  Background.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 11/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Background.h"


@implementation Background
{
    MyScene *_MyScene;
}

- (instancetype)initWithTexture:(SKTexture *)texture position:(CGPoint)position scene:(MyScene *)myScene
{
    if (self = [super initWithTexture:texture]) {
        _MyScene = myScene;
        self.position = position;
        self.name = @"background";
        self.anchorPoint = CGPointMake(0.5, 1);
        self.zPosition = LayerBackground;
    }
    return self;
}

@end
