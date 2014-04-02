//
//  MyScene.h
//  FlyFish
//

//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#define kLevel 0

#import <SpriteKit/SpriteKit.h>

@class FishPlayer;

@protocol MySceneDelegate <NSObject>
- (UIImage *)screenshot;
- (void)shareString:(NSString *)string image:(UIImage *)image;
@end


@interface MyScene : SKScene <SKPhysicsContactDelegate>
{
@public int testing;
@public SKAction *_soundCoin, *_soundDing, *_soundFalling, *_soundFlapping, *_soundHitGround, *_soundPop, *_soundWhack;
@public SKLabelNode *_scoreLabel, *_tutorialLabel;
@public SKTextureAtlas *_atlas;
@public int _noOfCollisionsWithEnemies;
@public SKNode *_worldNode;
@public SKSpriteNode *_background;
}



//Parameters
@property (nonatomic) CGFloat speed;

- (id)initWithSize:(CGSize)size gameState:(GameState)gameState delegate:(id<MySceneDelegate>)delegate;
- (int)bestScore;


@property (nonatomic) int score;
@property (nonatomic, strong) FishPlayer *player;
@property (nonatomic, weak) id<MySceneDelegate> delegate;




@end

