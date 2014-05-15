//
//  MyScene.h
//  FlyFish
//

//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#define kLevel 49


#import <SpriteKit/SpriteKit.h>

@class FishPlayer;
@class Background;

@protocol MySceneDelegate <NSObject>
- (UIImage *)screenshot;
- (void)shareString:(NSString *)string image:(UIImage *)image;
@end


@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
@public SKAction *_soundCoin, *_soundFalling, *_soundFlapping, *_soundHitGround, *_soundPop, *_soundWhack;
@public NSTimeInterval _dt, _lastUpdateTime;
@public SKLabelNode *_scoreLabel, *_tutorialLabel, *_gameTitleLabel;
@public SKSpriteNode *_musicButton, *_soundButton;
@public SKTextureAtlas *_atlas;
@public int _noOfCollisionsWithEnemies;
@public SKNode *_worldNode;
@public Background *_background;
}




- (id)initWithSize:(CGSize)size gameState:(GameState)gameState delegate:(id<MySceneDelegate>)delegate;
- (int)bestScore;


@property (nonatomic) int score;
@property (nonatomic, strong) FishPlayer *player;
@property (nonatomic, weak) id<MySceneDelegate> delegate;




@end

