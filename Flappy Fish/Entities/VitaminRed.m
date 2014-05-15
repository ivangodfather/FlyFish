//
//  VitaminRed.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 28/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "VitaminRed.h"
#import "FishPlayer.h"


@implementation VitaminRed
{
    MyScene *_myScene;
}


- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"vitamin_red"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        _myScene = myScene;
    }
    return self;
}

- (void)applyActionsToPlayer
{
    [self removeFromParent];
    SKAction *scaleFish = [SKAction scaleTo:1.5 duration:kVitaminRedDuration/2];
    SKAction *redAction = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.5 duration:kVitaminRedDuration/2];
    SKAction *group = [SKAction group:@[scaleFish, redAction]];
    
    SKAction *scaleFishRev = [SKAction scaleTo:1.0 duration:kVitaminRedDuration/2];
    SKAction *redActionRev = [SKAction colorizeWithColor:[UIColor clearColor] colorBlendFactor:0 duration:kVitaminRedDuration/2];
    SKAction *groupRev = [SKAction group:@[scaleFishRev,redActionRev]];
    
    
    [_myScene.player runAction:[SKAction sequence:@[group,[SKAction waitForDuration:kVitaminRedDuration],groupRev]]];
}

@end
