//
//  CloudSmall.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "CloudSmall.h"

@implementation CloudSmall
{
    MyScene *_MyScene;
}

- (instancetype)initWithScene:(MyScene *)myScene
{
    _MyScene = myScene;
    SKTexture *texture = [myScene->_atlas textureNamed:@"cloudsmall"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.name = @"cloudsmall";
        self.scale = RandomFloatRange(0.7, 1);
        self.position = CGPointMake(myScene.size.width + self.texture.size.width/2, myScene.size.height - RandomFloatRange(self.size.height/2, self.size.height*2.5));
    }
    return self;
}

@end
