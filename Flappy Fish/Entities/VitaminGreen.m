//
//  VitamineGreen.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 28/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "VitaminGreen.h"
#import "FishPlayer.h"

@implementation VitaminGreen
{
    MyScene *_MyScene;
}


- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"vitamin_green"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        _MyScene = myScene;
    }
    return self;
}

- (void)applyActionsToPlayer
{
    [self removeFromParent];
    for (SKNode *node in _MyScene->_worldNode.children) {
        if ([[node class] isSubclassOfClass:[Entity class]]) {
            SKAction *action = [node actionForKey:@"move"];
            action.speed = 2;
        }
    }
}

@end