//
//  Smoke.m
//  FlyFlish
//
//  Created by Ivan Ruiz Monjo on 14/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Smoke.h"
#import "FishPlayer.h"
#import "SKNode+Move.h"

@implementation Smoke
{
    MyScene *_MyScene;
}
//TODO SKNode
- (instancetype)initWithScene:(MyScene *)myScene
{
    CGSize size = CGSizeMake(kSmokeWidth, kSmokeHeight);
    if (self = [super initWithScene:myScene]) {
        _MyScene = myScene;
        
        self.position = CGPointMake(myScene.size.width + size.width/2, 0);
        SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                      [[NSBundle mainBundle] pathForResource:@"Smoke"
                                                                      ofType:@"sks"]];
        if (IPAD) {
            emitterNode.particleLifetime = emitterNode.particleLifetime * 2;
            size = CGSizeMake(kSmokeWidth*2, kSmokeHeight*2);
        }
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        self.physicsBody.categoryBitMask = PhysicsCategoryEmitter;
        self.physicsBody.collisionBitMask = 0;
        

        
        [self addChild:emitterNode];
        [self moveWithScene:myScene];
        
    }
    return self;
}

- (void)applyActionsToPlayer
{
    _MyScene.player.velocity = CGPointMake(_MyScene.player.velocity.x, _MyScene.player.velocity.y + kSmokeImpulse);
}

@end
