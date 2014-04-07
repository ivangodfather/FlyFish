//
//  SKNode+Move.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 28/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "SKNode+Move.h"
#import "Entity.h"

@implementation SKNode (Move)

- (void)moveWithScene:(MyScene *)myScene;
{
    Entity *entity = (Entity *)self;
    CGFloat duration = MAX([entity moveDuration] - (((float)myScene.score)/30),2);
    SKAction *sequence = [SKAction sequence:@[[SKAction moveToX:-100 duration:duration],[SKAction removeFromParent]]];
    sequence.timingMode = SKActionTimingLinear;
    [self runAction:sequence withKey:@"move"];
}

@end
