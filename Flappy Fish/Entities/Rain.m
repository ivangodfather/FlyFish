//
//  Rain.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 18/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Rain.h"

@implementation Rain
{
    MyScene *_MyScene;
}

- (instancetype)initWithScene:(MyScene *)myScene
{
    if (self = [super initWithScene:myScene]) {
        _MyScene = myScene;
        self.position = CGPointMake(myScene.size.width/2, myScene.size.height);
        NSString *type = RandomFloat()>0.5?@"Rain":@"Snow";
        SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                      [[NSBundle mainBundle] pathForResource:type
                                                                      ofType:@"sks"]];
        emitterNode.particlePositionRange = CGVectorMake(myScene.size.width, 0);
        if (IPAD) {
            emitterNode.particleLifetime = emitterNode.particleLifetime * 2;
        }
        
        [self addChild:emitterNode];
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kRainDuration], [SKAction removeFromParent]]]];
    }
    return self;
}

@end
