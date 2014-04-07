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

@import GameController;

@implementation MyScene
{
    GameState _gameState;
    Obstacle *_lastObstacleAdded;
    Decorate *_lastDecorateAdded;
    Enemy *_lastEnemyAdded;
    Emitter *_lastEmitterAdded;
    GCController *_gameController;
    GCExtendedGamepad *_profile;
}

- (id)initWithSize:(CGSize)size gameState:(GameState)gameState delegate:(id<MySceneDelegate>)delegate {
    if (self = [super initWithSize:size]) {
        [self.view setIgnoresSiblingOrder:YES]; //TODO VERFIFICAR MEJORA RENDIMIENTO! :_D
        _gameState = gameState;
        _delegate = delegate;
        [self setupScene];
        self.physicsWorld.contactDelegate = self;
        
        
        if ([GCController class])
        {
            NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
            
            [center addObserver:self selector:@selector(setupControllers:)
                            name:GCControllerDidConnectNotification object:nil];
            [center addObserver:self selector:@selector(setupControllers:)
                            name:GCControllerDidDisconnectNotification object:nil];
            [self setupControllers:nil];
            
        }
        
    }
    return self;
}

- (void)setupControllers:(NSNotification *)notification
{
    NSArray *controllerArray = [GCController controllers];
    if (controllerArray.count > 0) {
        _gameController = [[GCController controllers] lastObject];

    }
}

- (void)readControls
{
    _profile = _gameController.extendedGamepad;
    if (_profile.buttonA.isPressed | _profile.buttonB.isPressed | _profile.buttonX.isPressed | _profile.leftTrigger.isPressed | _profile.leftShoulder.isPressed) {
        [self.player flapFish];
        SKLabelNode *two = [SKLabelNode labelNodeWithFontNamed:kFontName];
        [_worldNode addChild:two];
        two.text = @"Je";
        two.position = CGPointMake(100, 150);
    }
}

#pragma mark Setup

- (void)setupScene
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerAuthenticated)
                                                 name:PlayerAuthenticated
                                               object:nil];
    
    [SpritePrinter setupScene:self];
    if (_gameState == GameStatePlay) {
        for (Class class in @[[Decorate class],[Enemy class],[Emitter class],[Obstacle class]]) {
            [self spawner:class withDecrement:0];
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
    if ((score % 5) == 0 && score) [self updateVelocity];

    _scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    SKAction *scale = [SKAction scaleBy:1.3 duration:0.2];
    SKAction *scaleRev = [scale reversedAction];
    SKAction *repeat = [SKAction repeatAction:[SKAction sequence:@[scale, scaleRev]] count:3];
    SKAction *flash = [SKAction skt_screenZoomWithNode:_scoreLabel amount:CGPointMake(0.1, 0.1) oscillations:3 duration:3];
    [_scoreLabel runAction:repeat];
    [_scoreLabel runAction:flash];
    [self runAction:_soundCoin];
}

- (void)updateVelocity
{
    [self removeActionForKey:@"spawnObstacle"];
    CGFloat decrement = MIN(1.4, ((float)self.score)/40);

    [self spawner:[Obstacle class] withDecrement:decrement];
}

#pragma mark GamePlay

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    switch (_gameState) {
        case GameStatePlay:
            [_player flapFish];
            [self readControls];
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

- (void)spawner:(Class)class withDecrement:(CGFloat)decrement
{
    SKAction *spawn = [SKAction runBlock:^{
        Class theClass = class;
        id newObj = [theClass spawnWithScene:self];

        id lastObjAdded = [theClass lastAdded];
        
        if ([newObj isKindOfClass:[Obstacle class]]) {
            [self insertScoreWithObstacle:newObj];
        }
        if ([lastObjAdded isKindOfClass:[Obstacle class]]) {
            [[newObj class] moveNewObstacle:newObj fromLastObstacle:lastObjAdded withScene:self];
        }
        if (!newObj && ([theClass class] == [Obstacle class])) {
            newObj = [Vitamin spawnWithScene:self];
        }
        if (newObj) {
            [theClass setLastAdded:newObj];
            [_worldNode addChild:newObj];
        }
    }];
    Class theClass = class;
    [self runAction:[SKAction repeatActionForever: [SKAction sequence:
                                                    @[[SKAction waitForDuration:[theClass spawnDelay] - decrement],spawn]]] withKey:NSStringFromClass(class)];
}

- (void)insertScoreWithObstacle:(Obstacle *)obstacle
{
    NSUInteger obstacleNum = [Obstacle numberOfInstances];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"score.value == %lu",obstacleNum];
    NSSet *scoresOnObstacleSet = [[GameKitHelper sharedGameKitHelper].topScores filteredSetUsingPredicate:pred];
    PlayerResult *playerResult = [scoresOnObstacleSet anyObject];  //TODO Coger el del amigo!! :-)
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
    [self readControls];
    [_background updateBackground];
    [self updatePlayer];
    [self updateScore];
}

- (void)gameStateFalling
{
    [[GameKitHelper sharedGameKitHelper] reportScore:self.score forLeaderboardID:kLeaderBoardID];
    
    for (Class class in @[[Decorate class],[Enemy class],[Emitter class],[Obstacle class], [Vitamin class]]) {
        [self removeActionForKey:NSStringFromClass(class)];
    }
    
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
    [_background updateBackground];
    
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

- (void)updatePlayer
{
    [_player fishGravity];
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
