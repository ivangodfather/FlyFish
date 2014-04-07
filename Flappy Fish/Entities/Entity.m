//
//  Obstacle.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 11/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Entity.h"
#import "SKAction+SKTSpecialEffects.h"
#import "SKNode+Move.h"

@implementation Entity
{
    MyScene *_MyScene;
}

- (instancetype)initWithTexture:(SKTexture *)texture scene:(MyScene *)myScene
{
    if (self = [super initWithTexture:texture]) {
        _MyScene = myScene;
        [self moveWithScene:myScene];
    }
    return self;
}

- (void)attachPhysicsBodyToSpriteWithMarginWidth:(float)marginWidth marginHeight:(float)marginHeight
{
    CGSize size = CGSizeMake(self.size.width * marginWidth, self.size.height * marginHeight);
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    [self skt_attachDebugRectWithSize:size color:[SKColor redColor]];
}

- (void)attachRandomPhysicsBodyToSprite
{
    if ((arc4random()%4) > 2) {
        [self attachPhysicsBodyToSpriteWithMarginWidth:0.8 marginHeight:0.8];
        self.physicsBody.dynamic = NO;
        self.colorBlendFactor = 0.7;
        self.color = [UIColor redColor];
    }
}

- (void)addRadmonImpulse
{
    float time = RandomFloat() * 4 + 1;
    CGVector impulseVector = CGVectorMake(0, RandomFloatRange(3, 4));
    
    [self runAction: [SKAction sequence:@[[SKAction waitForDuration:time], [SKAction runBlock:^{
        if (self.physicsBody) {
            self.physicsBody.dynamic = YES;
            [self.physicsBody applyImpulse:impulseVector];
        }
    }], [SKAction waitForDuration:time/2], [SKAction runBlock:^{
        [self.physicsBody applyImpulse:CGVectorMake(0, -RandomFloatRange(5, 6))];
    }]
                                          ]]];
}

- (void)attachTrianglePhysicsBodyToSprite
{
    CGMutablePathRef trianglePath = CGPathCreateMutable();
    CGPathMoveToPoint(trianglePath, nil, -self.size.width/2, -self.size.height/2);
    CGPathAddLineToPoint(trianglePath, nil, self.size.width/2, -self.size.height/2);
    CGPathAddLineToPoint(trianglePath, nil, 0,self.size.height/2);
    CGPathAddLineToPoint(trianglePath, nil, -self.size.width/2, -self.size.height/2);
    self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:trianglePath];
    [self skt_attachDebugFrameFromPath:trianglePath color:[UIColor blueColor]];
    self.physicsBody.dynamic = NO;
}

-(float)moveDuration
{
    return kMoveDuration;
}

@end
