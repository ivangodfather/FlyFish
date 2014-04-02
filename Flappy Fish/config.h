//
//  config.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 11/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#ifndef Flappy_Fish_config_h
#define Flappy_Fish_config_h

static const BOOL kDebugDrawEnabled = NO;
static NSString* const testFlightKey = @"d6afc20c-afbe-47d1-8af4-85b2fbe34e4f";
static NSString* const kLeaderBoardID = @"topscore";

typedef NS_ENUM(int, Layer)
{
    LayerBackground,
    LayerDecorate,
    LayerObstacle,
    LayerVitamin,
    LayerEnemy,
    LayerEmitter,
    LayerPlayer,
    LayerUI,
};

typedef NS_ENUM(int, GameState) {
    GameStateMainMenu,
    GameStateTutorial,
    GameStatePlay,
    GameStateFalling,
    GameStateShowingScore,
    GameStateGameOver
};

typedef NS_OPTIONS(int, PhysicsCategory)
{
    PhysicsCategoryPlayer = 1 << 0,
    PhysicsCategoryEnemy = 1 << 1,
    PhysicsCategoryEmitter = 1 << 3,
    PhysicsCategoryObstacle = 1 << 4,
    PhysicsCategoryVitamin = 1 << 5,
};

typedef NS_ENUM(int, DecorateType)
{
    DecorateTypeTree = 0,
    DecorateTypeRock,
    DecorateTypeGrassLarge,
    DecorateTypeGrassSmall,
    DecorateTypeCloudLarge,
    DecorateTypeCloudSmall,
    DecorateTypeSmoke,
    DecorateTypeBushes,
    DecorateTypeMax,
};

typedef NS_ENUM (int, EnemyType)
{
    EnemyTypeBlueJay = 0,
    EnemyTypeCrab,
    EnemyTypeBug,
    EnemyTypeMax,
};

typedef NS_ENUM (int, VitaminType)
{
    VitaminTypeRed,
    VitaminTypeGreen,
    VitaminTypeMax,
};

typedef NS_ENUM(int, ObstacleType)
{
    ObstacleTypePipe,
    ObstacleTypeMax,
};

typedef NS_ENUM (int, EmitterType)
{
    EmitterTypeSmoke,
    EmitterTypeRain,
    EmitterTypeMax,
};

/* ### GAMEPLAY ### */

static const float kMoveDuration = 4; //4

static const float kObstacleSpawnDelay = 0.5; //0.5
static const float kObstacleProbability = 1; //0.4

static const float kEnemyProbability = 0.8; //0.8
static const float kEnemySpawnDelay = 1;  //1

static const float kEmitterProbability = 0.6; //0.7
static const float kEmitterSpawnDelay = 2;  //2

static const float kDecorateProbability = 0.8;  //0.8
static const float kDecorateSpawnDelay = 1.5;  //1.5

static const float kVitaminProbability = 0.7;
static const float kVitaminSpawnDelay = 1;



static const float kBackgroundSpeed = 100;
static const float kPlayerGravity = -1000;
static const float kFlapImpulse = 300;
static const float kTimeSpawnObstacle = 4;
static const float kMinDelay = 0.1;


static const float kMargin = 20;
static NSString* const kFontName = @"AmericanTypewriter-Bold";
static const float kFontSize = 30;
static const float kScoreFontSize = 40;
static const float kAvatarSize = 100;

#define kFontColor [SKColor whiteColor];

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

static const float kFontIpad = 24;
static const float kFontIphone  = 15;

#endif
