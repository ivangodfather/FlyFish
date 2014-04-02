//
//  MyScene.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 11/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Obstacle.h"
#import "Enemy.h"
#import "Decorate.h"
#import "Emitter.h"
#import "Vitamin.h"


#import "Background.h"
#import "Entity.h"
#import "SpritePrinter.h"
#import "Emitter.h"
#import "SKAction+SKTSpecialEffects.h"
#import "SKTAudio.h"

#import "FishPlayer.h"
#import "AchievementsHelper.h"
#import "GameKitHelper.h"
#import "PlayerResult.h"


@implementation MyScene
{
    //Game
    GameState _gameState;
    NSTimeInterval _dt, _lastUpdateTime;
    
    NSMutableDictionary *_lastObjects;
    Obstacle *_lastObstacleAdded;
    Decorate *_lastDecorateAdded;
    Enemy *_lastEnemyAdded;
    Emitter *_lastEmitterAdded;
}

- (id)initWithSize:(CGSize)size gameState:(GameState)gameState delegate:(id<MySceneDelegate>)delegate {
    if (self = [super initWithSize:size]) {
        [self.view setIgnoresSiblingOrder:YES]; //TODO VERFIFICAR MEJORA RENDIMIENTO! :_D
        _gameState = gameState;
        _delegate = delegate;
        [self setupScene];
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

#pragma mark Setup

- (void)setupScene
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerAuthenticated)
                                                 name:PlayerAuthenticated
                                               object:nil];
    
    _lastDecorateAdded = [Decorate new];
    _lastEmitterAdded = [Emitter new];
    _lastEnemyAdded = [Enemy new];
    _lastObstacleAdded = [Obstacle new];
    
    _lastObjects = [@{@"_lastObstacleAdded": _lastObstacleAdded,@"_lastDecorateAdded":_lastDecorateAdded,@"_lastEnemyAdded":_lastEnemyAdded,@"_lastEmitterAdded":_lastEmitterAdded} mutableCopy];
    [SpritePrinter setupScene:self];
    if (_gameState == GameStatePlay) {
        for (NSString *obj in @[@"Decorate",@"Vitamin",@"Enemy",@"Emitter",@"Obstacle"]) {
            [self spawner:obj];
        }
        [_player flapFish];
    } else if (_gameState == GameStateTutorial) {
        [SpritePrinter setupTutorial:self];
    }
}

- (void)playerAuthenticated
{
    NSLog(@"Player autenticated ok!");
}

- (void)setScore:(int)score
{
    _score = score;
    _scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    SKAction *scale = [SKAction scaleBy:1.3 duration:0.2];
    SKAction *scaleRev = [scale reversedAction];
    SKAction *repeat = [SKAction repeatAction:[SKAction sequence:@[scale, scaleRev]] count:3];
    SKAction *flash = [SKAction skt_screenZoomWithNode:_scoreLabel amount:CGPointMake(0.1, 0.1) oscillations:3 duration:3];
    [_scoreLabel runAction:repeat];
    [_scoreLabel runAction:flash];
    [self runAction:_soundCoin];
}


#pragma mark GamePlay

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    switch (_gameState) {
        case GameStatePlay:
            [_player flapFish];
            break;
        case GameStateShowingScore:
            [self touchInScore:touchLocation];
            break;
        case GameStateTutorial:
            [self newGame];
        default:
            break;
    }
}

- (void)touchInScore:(CGPoint)touchLocation
{
    if (CGRectContainsPoint([_worldNode childNodeWithName:@"okButton"].frame, touchLocation)) {
        [self newGame];
    }
    else if(CGRectContainsPoint([_worldNode childNodeWithName:@"shareButton"].frame, touchLocation)) {
        [self.delegate screenshot];
        NSString *string = [NSString stringWithFormat: NSLocalizedStringFromTable(@"RECORD_PIPES", @"Translation", @"SHARE RECORD PIPES"), self.score];
        [self.delegate shareString:string image:[self.delegate screenshot]];
    }
    else if(CGRectContainsPoint([_worldNode childNodeWithName:@"gameCenterButton"].frame, touchLocation)) {         [[GameKitHelper sharedGameKitHelper] showGKGameCenterViewController:self.view.window.rootViewController];
    }
}

- (void)newGame
{
    
    SKScene *newScene = [[MyScene alloc] initWithSize:self.size gameState:GameStatePlay delegate:_delegate];
    SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.5];
    [self.view presentScene:newScene transition:transition];
}

- (void)spawner:(NSString *)name
{
    SKAction *spawn = [SKAction runBlock:^{
        Class theClass = NSClassFromString(name);
        id obj = [theClass spawnWithScene:self];
        NSString *key = [NSString stringWithFormat:@"_last%@Added",name];
        id lastObjAdded = [_lastObjects objectForKey:key];
        
        if ([obj isKindOfClass:[Obstacle class]]) {
            [self insertScoreWithObstacle:obj];
        }
        if ([lastObjAdded isKindOfClass:[Obstacle class]]) {
            [[obj class] moveNewObstacle:obj fromLastObstacle:lastObjAdded withScene:self];
        }
        if (obj) {
            _lastObjects[key] = obj;
            [_worldNode addChild:obj];
        }
    }];
    [self runAction:[SKAction repeatActionForever: [SKAction sequence:
                                                    @[[SKAction waitForDuration:kVitaminSpawnDelay],spawn]]] withKey:[NSString stringWithFormat:@"spawn%@",name]];
}

- (void)insertScoreWithObstacle:(Obstacle *)obstacle
{
    NSUInteger obstacleNum = [Obstacle numberOfInstances];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"score.value == %lu",obstacleNum];
    NSArray *scoresOnObstacleArray = [[GameKitHelper sharedGameKitHelper].topScores filteredArrayUsingPredicate:pred];
    PlayerResult *playerResult = [scoresOnObstacleArray lastObject];
    if (playerResult) [obstacle addPlayerResult:playerResult];
}

- (int)bestScore
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"bestScore"];
}

- (void)setBestScore:(int)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"bestScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Contact Delegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if ((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (PhysicsCategoryEnemy | PhysicsCategoryPlayer)) {
        Enemy *enemy = (Enemy *) (contact.bodyA.categoryBitMask == PhysicsCategoryPlayer ? contact.bodyB.node : contact.bodyA.node);
        [self didContactEnemy:enemy];
    }
    
    if ((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (PhysicsCategoryEmitter | PhysicsCategoryPlayer)) {
        SKPhysicsBody *emitter = (contact.bodyA.categoryBitMask == PhysicsCategoryPlayer ? contact.bodyB : contact.bodyA);
        Emitter *obstacleEmitter = (Emitter *)emitter.node;
        [obstacleEmitter applyActionsToPlayer];
    }
    if ((contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (PhysicsCategoryVitamin | PhysicsCategoryPlayer)) {
        SKPhysicsBody *vitaminBody = (contact.bodyA.categoryBitMask == PhysicsCategoryPlayer ? contact.bodyB : contact.bodyA);
        Vitamin *vitamin = (Vitamin *)vitaminBody.node;
        [vitamin applyActionsToPlayer];
    }
}

- (void)didContactEnemy:(Enemy *)enemy
{
    if (!enemy) return;
    enemy.physicsBody.categoryBitMask = 0;
    enemy.physicsBody.contactTestBitMask = 0;
    _noOfCollisionsWithEnemies++;
    [self reportAchievementsForGameState];
    [self runAction:_soundWhack];
    [enemy applyActionsToPlayer:enemy];
}

#pragma mark Achievements
-(void)reportAchievementsForGameState
{
    NSMutableArray *achievements = [NSMutableArray array];
    GKAchievement *gkAchievemnt = [AchievementsHelper achievementWithCollisions:_noOfCollisionsWithEnemies];
    if (gkAchievemnt)[achievements addObject:gkAchievemnt];
    if (achievements.count > 0) {
        [[GameKitHelper sharedGameKitHelper] reportAchievements:achievements];
    }
}

#pragma mark GameStates

- (void)gameStatePlay
{
    [self updateBackground];
    [self updatePlayer];
    [self updateScore];
}

- (void)gameStateFalling
{
    [[GameKitHelper sharedGameKitHelper] reportScore:self.score forLeaderboardID:kLeaderBoardID];
    [self removeActionForKey:@"spawnPipe"];
    [self removeActionForKey:@"spawnDecorate"];
    [self removeActionForKey:@"spawnEnemy"];
    [self removeActionForKey:@"spawnEmitter"];
    [self removeActionForKey:@"spawnVitamin"];
    [self removeActionForKey:@"spawnObstacle"];
    [self runAction:_soundWhack];
    SKAction *shake = [SKAction skt_screenShakeWithNode:_worldNode amount:CGPointMake(0, 70) oscillations:10 duration:1];
    [_worldNode runAction:shake];
    [_player removeAllActions];
    [_scoreLabel setScale:0];
    [Obstacle resetNumberOfInstances];
    
    for (SKNode *node in _worldNode.children) {
        if ([node isKindOfClass:[Entity class]] || [node isKindOfClass:[Emitter class]]) {
            [node removeActionForKey:@"move"];
        }
    }
    _gameState = GameStateGameOver;
    [_player dead];
}

-(void)gameStateGameOver
{
    _gameState = GameStateShowingScore;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:2.0], [SKAction runBlock:^{
        if (self.score > [self bestScore]) {
            [self setBestScore:self.score];
        }
        [SpritePrinter printBoard:self];
    }]]]];
}

- (void)gameStateTutorial
{
    [self updateBackground];
    
}

- (void)gameStateShowingScore
{
    
}



#pragma mark Update

- (void)update:(NSTimeInterval)currentTime
{
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    }
    _lastUpdateTime = currentTime;
    
    switch (_gameState) {
        case GameStatePlay:
            [self gameStatePlay];
            break;
        case GameStateFalling:
            [self gameStateFalling];
            break;
        case GameStateGameOver:
            [self gameStateGameOver];
            break;
        case GameStateShowingScore:
            [self gameStateShowingScore];
            break;
        case GameStateTutorial:
            [self gameStateTutorial];
            break;
        default:
            break;
    }
}

- (void)updateBackground
{
    [_worldNode enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *background = (SKSpriteNode *)node;
        CGPoint amountToMove = CGPointMake(-kBackgroundSpeed * _dt, 0);
        background.position = CGPointAdd(background.position, amountToMove);
        if (background.position.x < -background.size.width) {
            background.position = CGPointAdd(background.position, CGPointMake(2 * background.size.width, 0));
        }
    }];
}

- (void)updatePlayer
{
    CGPoint gravity = CGPointMake(0, kPlayerGravity);
    CGPoint gravityStep = CGPointMultiplyScalar(gravity, _dt);
    _player.velocity = CGPointAdd(_player.velocity, gravityStep);
    CGPoint velocityStep = CGPointMultiplyScalar(_player.velocity, _dt);
    _player.position = CGPointAdd(_player.position, velocityStep);
    if (_player.position.y < _player.size.height/2) {
        _player.position = CGPointMake(_player.position.x, _player.size.height/2);
    }
    int maxY = _background.position.y - _player.size.height/2;
    if (_player.position.y > maxY) {
        _player.position = CGPointMake(_player.position.x, maxY);
    }
    if (_player.position.x < -_player.size.width/2) {
        _gameState = GameStateFalling;
    }
}

- (void)updateScore
{
    [_worldNode enumerateChildNodesWithName:@"pipe" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *pipe = (SKSpriteNode *)node;
        if (!pipe.userData && pipe.position.x < _player.position.x) {
            self.score++;
            pipe.userData = [[NSMutableDictionary alloc] init];
            pipe.userData[@"pass"] = @"pass";
        }
    }];
}
@end
