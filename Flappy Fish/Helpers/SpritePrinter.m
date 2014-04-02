//
//  Spawn.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "SpritePrinter.h"
#import "FishPlayer.h"
#import "SKTAudio.h"


@implementation SpritePrinter
{
    SKSpriteNode *_okButton, *_shareButton;
}

+ (void)setupScene:(MyScene *)myScene
{
    myScene->_worldNode = [SKNode node];
    [myScene addChild:myScene->_worldNode];
    
    [SpritePrinter setupBackground:myScene];
    myScene->_atlas = [SKTextureAtlas atlasNamed:@"sprite"];
    myScene->_noOfCollisionsWithEnemies = 0;
    myScene.speed = 1.0;
    //[[SKTAudio sharedInstance] playBackgroundMusic:@"bgMusic.mp3"];
    myScene.name = @"scene";
    myScene.physicsWorld.gravity = CGVectorMake(0, 0);
    
    
    myScene.player = [[FishPlayer alloc] initWithScene:myScene];
    [myScene->_worldNode addChild:myScene.player];
    [SpritePrinter setupSounds:myScene];
    [SpritePrinter setupScoreLabel:myScene];
}

+ (void)setupBackground:(MyScene *)myScene
{
    for (int i = 1; i < 3; i++) {
        myScene->_background = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"bg%d",i]]];
        myScene->_background.name = @"background";
        myScene->_background.position = CGPointMake((i-1) * myScene->_background.texture.size.width, myScene.size.height);
        myScene->_background.anchorPoint = CGPointMake(0, 1);
        [myScene->_worldNode addChild:myScene->_background];
    }
}

+ (void)setupSounds:(MyScene *)myScene
{
    myScene->_soundCoin = [SKAction playSoundFileNamed:@"coin.wav" waitForCompletion:NO];
    myScene->_soundDing = [SKAction playSoundFileNamed:@"ding.wav" waitForCompletion:NO];
    myScene->_soundFalling = [SKAction playSoundFileNamed:@"falling.wav" waitForCompletion:NO];
    myScene->_soundFlapping = [SKAction playSoundFileNamed:@"flapping.wav" waitForCompletion:NO];
    myScene->_soundHitGround = [SKAction playSoundFileNamed:@"hitGround.wav" waitForCompletion:NO];
    myScene->_soundPop = [SKAction playSoundFileNamed:@"pop.wav" waitForCompletion:NO];
    myScene->_soundWhack = [SKAction playSoundFileNamed:@"whack.wav" waitForCompletion:NO];
}

+ (void)setupTutorial:(MyScene *)myScene
{
    myScene->_tutorialLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    myScene->_tutorialLabel.fontColor = kFontColor;
    myScene->_tutorialLabel.fontSize = (IPAD?kFontIpad:kFontIphone)*1.5;
    myScene->_tutorialLabel.text = NSLocalizedStringFromTable(@"TAP_TO_FLY", @"Translation", @"Tap to fly at first");
    myScene->_tutorialLabel.zPosition = LayerUI;
    myScene->_tutorialLabel.position = CGPointMake(myScene.player.position.x + myScene.player.size.width, myScene.player.position.y);
    myScene->_tutorialLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [myScene->_worldNode addChild:myScene->_tutorialLabel];
}

+ (void)setupScoreLabel:(MyScene *)myScene
{
    myScene->_scoreLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    myScene->_scoreLabel.position = CGPointMake(myScene.size.width/2, myScene.size.height - kMargin * 3);
    myScene->_scoreLabel.fontColor = kFontColor;
    myScene->_scoreLabel.fontSize = (IPAD?kFontIpad:kFontIphone)*3;
    myScene->_scoreLabel.name = @"scorelabel";
    myScene->_scoreLabel.zPosition = LayerUI;
    myScene.score = kLevel;
    [myScene->_worldNode addChild:myScene->_scoreLabel];
}


+ (void)printBoard:(MyScene *)myScene
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, myScene.size.width*0.6, myScene.size.height*0.3) cornerRadius:12];
    SKShapeNode *scorecard = [[SKShapeNode alloc] init];
    scorecard.fillColor = [UIColor blackColor];
    scorecard.alpha = 0.4;
    scorecard.path = path.CGPath;
    
    scorecard.position = CGPointMake(myScene.size.width/2-path.bounds.size.width/2, myScene.size.height/2-path.bounds.size.height/2.3);
    scorecard.name = @"Tutorial";
    scorecard.zPosition = LayerUI;
    [myScene->_worldNode addChild:scorecard];
    
    SKLabelNode *gameOver = [SKLabelNode labelNodeWithFontNamed:kFontName];
    gameOver.position = CGPointMake(myScene.size.width*0.5, myScene.size.height*0.8);
    gameOver.text = NSLocalizedStringFromTable(@"GAME_OVER", @"Translation", @"Game Over title");
    gameOver.fontSize = (IPAD?kFontIpad:kFontIphone)*3.5;
    gameOver.zPosition = LayerUI;
    [myScene->_worldNode addChild:gameOver];
    
    SKLabelNode *lastScoreLabel = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    lastScoreLabel.fontColor = kFontColor;
    lastScoreLabel.position = CGPointMake(myScene.size.width * 0.35, myScene.size.height*0.55);
    lastScoreLabel.zPosition = LayerUI;
    lastScoreLabel.text = NSLocalizedStringFromTable(@"LAST_SCORE", @"Translation", @"LAST SCORE");
    lastScoreLabel.fontSize = (IPAD?kFontIpad:kFontIphone)*2;
    [myScene->_worldNode addChild:lastScoreLabel];
    SKLabelNode *lastScore = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    lastScore.fontColor = kFontColor;
    lastScore.position = CGPointMake(myScene.size.width * 0.35, myScene.size.height*0.40);
    lastScore.zPosition = LayerUI;
    lastScore.text = [NSString stringWithFormat:@"%d", myScene.score];
    lastScore.fontSize = (IPAD?kFontIpad:kFontIphone)*3;
    [myScene->_worldNode addChild:lastScore];
    
    
    
    SKLabelNode *bestScoreLabel = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    bestScoreLabel.fontColor = kFontColor;
    bestScoreLabel.position = CGPointMake(myScene.size.width * 0.65, lastScoreLabel.position.y);
    bestScoreLabel.zPosition = LayerUI;
    bestScoreLabel.text = NSLocalizedStringFromTable(@"BEST_SCORE", @"Translation", @"BEST SCORE");
    bestScoreLabel.fontSize = (IPAD?kFontIpad:kFontIphone)*2;
    [myScene->_worldNode addChild:bestScoreLabel];
    SKLabelNode *bestScore = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    bestScore.fontColor = kFontColor;
    bestScore.position = CGPointMake(myScene.size.width * 0.65, lastScore.position.y);
    bestScore.zPosition = LayerUI;
    bestScore.text = [NSString stringWithFormat:@"%d",[myScene bestScore]];
    bestScore.fontSize = (IPAD?kFontIpad:kFontIphone)*3;
    [myScene->_worldNode addChild:bestScore];
    
    
    
    
    SKSpriteNode *okButton = [SKSpriteNode spriteNodeWithImageNamed:@"fish1"];
    okButton.name = @"okButton";
    okButton.position = CGPointMake(myScene.size.width * 0.25, myScene.size.height/5);
    okButton.zPosition = LayerUI;
    [myScene->_worldNode addChild:okButton];
    SKLabelNode *okButtonLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    okButtonLabel.text = NSLocalizedStringFromTable(@"PLAY", @"Translation", @"Play button");
    okButtonLabel.fontSize = IPAD?kFontIpad:kFontIphone;
    okButtonLabel.position = CGPointMake(0, -okButton.size.height/1.3);
    [okButton addChild:okButtonLabel];
    
    
    
    
    SKSpriteNode *shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"share"];
    shareButton.name = @"shareButton";
    shareButton.position = CGPointMake(myScene.size.width * 0.75, myScene.size.height/5);
    shareButton.zPosition = LayerUI;
    [myScene->_worldNode addChild:shareButton];
    SKLabelNode *shareLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    shareLabel.text = NSLocalizedStringFromTable(@"SHARE", @"Translation", @"Share button");
    shareLabel.fontSize = IPAD?kFontIpad:kFontIphone;
    [shareButton addChild:shareLabel];
    shareLabel.position = CGPointMake(0, okButtonLabel.position.y);
    
    
    SKSpriteNode *gameCenterButton = [SKSpriteNode spriteNodeWithImageNamed:@"gamecenter"];
    gameCenterButton.name = @"gameCenterButton";
    gameCenterButton.position = CGPointMake(myScene.size.width * 0.50, myScene.size.height/5);
    gameCenterButton.zPosition = LayerUI;
    [myScene->_worldNode addChild:gameCenterButton];
    SKLabelNode *gameCenterLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    gameCenterLabel.text = NSLocalizedStringFromTable(@"GAME_CENTER", @"Translation", @"Game Center button");
    gameCenterLabel.fontSize = IPAD?kFontIpad:kFontIphone;
    [gameCenterButton addChild:gameCenterLabel];
    gameCenterLabel.position = CGPointMake(0, okButtonLabel.position.y);
    
    
    
    //    gameOver.scale = 0;
    //    gameOver.alpha = 0;
    //    SKAction *group = [SKAction group:@[[SKAction fadeInWithDuration:0.3], [SKAction scaleTo:1.0 duration:0.3]
    //                                        ]];
    //    group.timingMode = SKActionTimingEaseInEaseOut;
}

@end
