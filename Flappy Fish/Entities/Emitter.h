//
//  ObstacleEmitter.h
//  FlyFlish
//
//  Created by Ivan Ruiz Monjo on 14/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

static const float kEmitterMoveDuration = 4;


@interface Emitter : SKNode

- (instancetype)initWithScene:(MyScene *)myScene;
- (void)applyActionsToPlayer;
+ (Emitter *)spawnWithScene:(MyScene *)myScene;
+ (Emitter *)lastAdded;
+ (void)setLastAdded:(Emitter *)emitter;
+ (CGFloat)spawnDelay;
-(float)moveDuration;

@end
