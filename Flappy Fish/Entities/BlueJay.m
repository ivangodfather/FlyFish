//
//  BlueJay.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "BlueJay.h"

@implementation BlueJay
{
    MyScene *_MyScene;
}

- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"bluejay1"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        _MyScene = myScene;
        self.name = @"bluejay";
        float min = self.size.height*3.5;
        float max = myScene.size.height - self.size.height/2;
        self.position = CGPointMake(myScene.size.width + self.size.width/2, RandomFloatRange(min,max));
        [self attachPhysicsBodyToSpriteWithMarginWidth:kBlueJayMarginWidth marginHeight:kBlueJayMarginHeight];
        NSArray *textures = [NSArray arrayWithObjects:
                             [myScene->_atlas textureNamed:@"bluejay1"],
                             [myScene->_atlas textureNamed:@"bluejay3"],
                             [myScene->_atlas textureNamed:@"bluejay2"],
                             [myScene->_atlas textureNamed:@"bluejay3"],
                             nil];
        [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.2]]];
    }
    return self;
}

- (void)moveWithScene:(MyScene *)myScene;
{
    SKAction *sequence = [SKAction sequence:@[[SKAction moveToX:-self.size.width/2 duration:kBlueJayMoveDuration],[SKAction removeFromParent]]];
    SKAction *moveY = [SKAction moveByX:0 y:20 duration:0.5];
    SKAction *reverseMoveY = [moveY reversedAction];
    SKAction *fullMoveY = [SKAction repeatActionForever:[SKAction sequence:@[moveY,reverseMoveY]]];
    [self runAction:[SKAction group:@[fullMoveY, sequence]]  withKey:@"move"];
}

- (int)force
{
    return kBlueJayForce;
}

@end
