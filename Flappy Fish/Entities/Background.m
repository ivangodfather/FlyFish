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

- (instancetype)initWithScene:(MyScene *)myScene
{
    _MyScene = myScene;
    if (self = [super init]) {
        for (int i = 1; i < 3; i++) {
            SKSpriteNode *bg = [[SKSpriteNode alloc] initWithImageNamed:[NSString stringWithFormat:@"bg%d",i]];
            bg.name = @"background";
            bg.anchorPoint = CGPointMake(0, 0);
            bg.position = CGPointMake((i-1) * bg.texture.size.width, 0);
            [self addChild:bg];
        }
        self.zPosition = LayerBackground;
    }
    return self;
}



- (void)updateBackground
{
    [_MyScene->_background enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *background = (SKSpriteNode *)node;
        CGPoint amountToMove = CGPointMake(-kBackgroundSpeed * _MyScene->_dt, 0);
        background.position = CGPointAdd(background.position, amountToMove);
        if (background.position.x < -_MyScene.size.width) {
            background.position = CGPointAdd(background.position, CGPointMake(2 * background.size.width, 0));
        }
        
    }];
}

@end
