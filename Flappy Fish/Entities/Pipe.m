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
        self.color = [self randomColor];
        self.colorBlendFactor = 1;
        float minYPosition = -self.size.height/2 + self.size.height/10;
        float maxYPosition = self.size.height*0.4;
        self.position = CGPointMake(myScene.size.width + self.texture.size.width/2, RandomFloatRange(minYPosition, maxYPosition));
        
        SKSpriteNode *top = [[SKSpriteNode alloc] initWithTexture:[myScene->_atlas textureNamed:@"pipe"]];
        top.name = @"pipe_top";
        top.zPosition = LayerObstacle;
        
        top.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        [top skt_attachDebugRectWithSize:top.size color:[SKColor redColor]];
        top.color = self.color;
        top.colorBlendFactor = 1;
        top.zRotation = DegreesToRadians(180);
        top.position = CGPointMake(0, self.size.height + myScene.player.size.height*2);
        top.physicsBody.categoryBitMask = PhysicsCategoryObstacle;
        top.physicsBody.collisionBitMask = 0;
        top.physicsBody.dynamic = NO;
        [self addChild:top];

    }
    return self;
}

- (UIColor *) randomColor {
    return [UIColor colorWithHue:RandomFloatRange(0, 1) saturation:1 brightness:1 alpha:1];
}


+ (void)moveNewObstacle:(Obstacle *)newObstacle fromLastObstacle:(Obstacle *)lastObstacle withScene:(MyScene *)scene
{
    CGFloat distanceObstacles = (newObstacle.position.x - lastObstacle.position.x);
    if (distanceObstacles < scene.player.size.width*2.5) {
        CGFloat amountToMove = RandomFloatRange(-scene.player.size.height*0.8, scene.player.size.height*0.8);
        CGFloat newY = MIN(MAX(lastObstacle.position.y + amountToMove, -newObstacle.size.height/2), newObstacle.size.height*0.4);
        newObstacle.position = CGPointMake(newObstacle.position.x, newY);
    }
}

@end
