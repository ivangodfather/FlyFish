//
//  FishPlayer.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 25/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#define kStartPosition _MyScene.size.width*0.25

@interface FishPlayer : SKSpriteNode

- (void)dead;
- (void)flapFish;
- (instancetype)initWithScene:(MyScene *)scene;

@property (nonatomic) CGPoint velocity;

@end
