//
//  Enemy.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 17/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Enemy.h"
#import "Bug.h"
#import "BlueJay.h"
#import "Crab.h"
#import "FishPlayer.h"

static Enemy *_lastAdded;

@implementation Enemy
{
    MyScene *_MyScene;
}

- (instancetype)initWithTexture:(SKTexture *)texture scene:(MyScene *)myScene
{
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.zPosition = LayerEnemy;
        _MyScene = myScene;
    }
    return self;
}

-(void)attachPhysicsBodyToSpriteWithMarginWidth:(float)marginWidth marginHeight:(float)marginHeight
{
    [super attachPhysicsBodyToSpriteWithMarginWidth:marginWidth marginHeight:marginHeight];
    self.physicsBody.categoryBitMask = PhysicsCategoryEnemy;
    self.physicsBody.collisionBitMask = PhysicsCategoryPlayer;
    self.physicsBody.usesPreciseCollisionDetection = YES;
}

+ (Enemy *)spawnWithScene:(MyScene *)myScene
{
    Enemy *enemy;
    if(RandomFloat() < kEnemyProbability) {
        EnemyType randomEnemy = (EnemyType) (arc4random() % (int) EnemyTypeMax);
        switch (randomEnemy) {
            case EnemyTypeBlueJay:
                enemy = [[BlueJay alloc] initWithScene:myScene];
                break;
            case EnemyTypeCrab:
                enemy = [[Crab alloc] initWithScene:myScene];
                break;
            case EnemyTypeBug:
                enemy = [[Bug alloc] initWithScene:myScene];
                break;
            default:
                break;
        }
    }
    return enemy;
}

- (void)applyActionsToPlayer:(Enemy *)enemy
{
    _MyScene.player.velocity = CGPointMake(-enemy.force, 50);
}

- (int)force
{
    return 70;
}

+ (CGFloat)spawnDelay
{
    return kEnemySpawnDelay;
}

+ (Enemy *)lastAdded
{
    return _lastAdded;
}

+ (void)setLastAdded:(Enemy *)enemy
{
    _lastAdded = enemy;
}

@end
