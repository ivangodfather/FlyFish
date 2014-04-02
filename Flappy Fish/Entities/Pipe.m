//
//  Tube.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 17/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Pipe.h"
#import "FishPlayer.h"

@implementation Pipe
- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"pipe"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        
        self.name = @"pipe";

        float minYPosition = -self.size.height/2 + self.size.height/10;
        float maxYPosition = self.size.height*0.4;
        self.position = CGPointMake(myScene.size.width + self.texture.size.width/2, RandomFloatRange(minYPosition, maxYPosition));
        
        SKSpriteNode *top = [[SKSpriteNode alloc] initWithTexture:[myScene->_atlas textureNamed:@"pipe"]];
        top.name = @"pipe_top";
        top.zPosition = LayerObstacle;
        
        top.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        [top skt_attachDebugRectWithSize:top.size color:[SKColor redColor]];
        
        top.zRotation = DegreesToRadians(180);
        top.position = CGPointMake(0, self.size.height + myScene.player.size.height*2.5);
        top.physicsBody.categoryBitMask = PhysicsCategoryObstacle;
        top.physicsBody.collisionBitMask = 0;
        top.physicsBody.dynamic = NO;
        [self addChild:top];

    }
    return self;
}



+ (void)moveNewObstacle:(Obstacle *)newObstacle fromLastObstacle:(Obstacle *)lastObstacle withScene:(MyScene *)scene
{ //TODO
//    CGFloat distanceObstacles = (newObstacle.position.x - lastObstacle.position.x)/2;
//    CGFloat newY = lastObstacle.position.y +  RandomFloatRange(-scene.player.size.height/2-distanceObstacles, +scene.player.size.height+distanceObstacles/2);
//    newY = MAX(MIN(lastObstacle.size.height*0.4,newY),-lastObstacle.size.height/2 + lastObstacle.size.height/10);
//    newObstacle.position = CGPointMake(newObstacle.position.x, newY);
}

@end
