//
//  VitaminBlue.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/05/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "VitaminBlue.h"
#import "FishPlayer.h"


@implementation VitaminBlue
{
    MyScene *_myScene;
}


- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"vitamin_blue"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        _myScene = myScene;
    }
    return self;
}

- (void)applyActionsToPlayer
{
    [self removeFromParent];
    uint32_t collision =  _myScene.player.physicsBody.collisionBitMask;
    _myScene.player.physicsBody.collisionBitMask = 0;
    _myScene.player.alpha = 0.5;
    SKAction *wait = [SKAction waitForDuration:5.0];
    SKAction *restore = [SKAction runBlock:^{
        _myScene.player.physicsBody.collisionBitMask = collision;
        _myScene.player.alpha = 1;
    }];
    SKAction *sequence = [SKAction sequence:@[wait,restore]];
    [_myScene.player runAction:sequence];
}

@end
