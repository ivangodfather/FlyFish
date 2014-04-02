//
//  SKNode+Move.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 28/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "SKNode+Move.h"
#import "Enemy.h"

@implementation SKNode (Move)

- (void)moveWithScene:(MyScene *)myScene;
{
    CGFloat duration = kMoveDuration * myScene.speed;
    SKAction *sequence = [SKAction sequence:@[[SKAction moveToX:-100 duration:duration],[SKAction removeFromParent]]];
    sequence.timingMode = SKActionTimingEaseIn;
    [self runAction:sequence withKey:@"move"];
}

@end
