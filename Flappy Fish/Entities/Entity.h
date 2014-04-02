//
//  Obstacle.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 11/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

static const float kDecorateMoveDuration = 4;

@interface Entity : SKSpriteNode

- (instancetype)initWithTexture:(SKTexture *)texture scene:(MyScene *)myScene;
- (void)attachPhysicsBodyToSpriteWithMarginWidth:(float)marginWidth marginHeight:(float)marginHeight;
- (void)attachRandomPhysicsBodyToSprite;
- (void)addRadmonImpulse;
- (void)attachTrianglePhysicsBodyToSprite;
@end
