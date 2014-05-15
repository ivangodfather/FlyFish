//
//  Crab.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Crab.h"

@implementation Crab
{
    MyScene *_myScene;
}

- (instancetype)initWithScene:(MyScene *)myScene
{
    _myScene = myScene;
    SKTexture *texture = [myScene->_atlas textureNamed:@"crab1"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.name = @"crab";
        float min = self.size.height/2;
        float max = self.size.height * 1.3;
        self.position = CGPointMake(myScene.size.width + self.size.width/2, RandomFloatRange(min,max));
        [self attachPhysicsBodyToSpriteWithMarginWidth:kCrabWidthMargin marginHeight:kCrabHeightMargin];
        NSArray *textures = [NSArray arrayWithObjects:
                             [myScene->_atlas textureNamed:@"crab1"],
                             [myScene->_atlas textureNamed:@"crab3"],
                             [myScene->_atlas textureNamed:@"crab3"],
                             [myScene->_atlas textureNamed:@"crab1"],
                             [myScene->_atlas textureNamed:@"crab3"],
                             [myScene->_atlas textureNamed:@"crab2"],
                             nil];
        [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.5]]];
    }
    return self;
}

- (void)moveWithScene:(MyScene *)myScene
{
    [self addRadmonImpulse];
    SKAction *sequence = [SKAction sequence:@[[SKAction moveToX:-self.size.width/2 duration:kCrabMoveDuration],[SKAction removeFromParent]]];
    SKAction *moveY = [SKAction moveByX:20 y:0 duration:0.5];
    SKAction *reverseMoveY = [moveY reversedAction];
    SKAction *fullMoveY = [SKAction repeatActionForever:[SKAction sequence:@[moveY,reverseMoveY]]];
    sequence.timingMode = SKActionTimingEaseIn;
    [self runAction:[SKAction group:@[fullMoveY, sequence]] withKey:@"move"];
}

- (int)force
{
    return kCrabForce;
}

@end
