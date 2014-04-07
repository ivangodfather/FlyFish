//
//  ObstacleEmitter.m
//  FlyFlish
//
//  Created by Ivan Ruiz Monjo on 14/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Emitter.h"
#import "Smoke.h"
#import "Rain.h"

static Emitter *_lastAdded;

@implementation Emitter
{
    MyScene *_MyScene;
    CGSize _size;
}

- (instancetype)initWithScene:(MyScene *)myScene
{
    _MyScene = myScene;
    if (self = [super init]) {
        self.zPosition = LayerEmitter;
    }
    return self;
}
+ (CGFloat)spawnDelay
{
    return kEmitterSpawnDelay;
}

- (void)applyActionsToPlayer { //Abstrac method
}

+ (Emitter *)spawnWithScene:(MyScene *)myScene
{
    Emitter *emitter;
    if(RandomFloat() < kEmitterProbability) {
        EmitterType randomEmitter = (EmitterType) (arc4random() % (int) EmitterTypeMax);
        switch (randomEmitter) {
            case EmitterTypeSmoke:
                emitter = [[Smoke alloc] initWithScene:myScene];
                break;
            case EmitterTypeRain:
                if (RandomFloat()>0.9)
                    emitter = [[Rain alloc] initWithScene:myScene];
            default:
                break;
        }
    }
    return emitter;
}

+ (Emitter *)lastAdded
{
    return _lastAdded;
}

+ (void)setLastAdded:(Emitter *)emitter
{
    _lastAdded = emitter;
}

-(float)moveDuration
{
    return kEmitterMoveDuration;
}

@end
