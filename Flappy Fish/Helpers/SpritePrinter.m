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
#import "Background.h"


@implementation SpritePrinter
{
    SKSpriteNode *_okButton, *_shareButton;
}

+ (void)setupScene:(MyScene *)myScene
{
    myScene->_worldNode = [SKNode node];
    [myScene addChild:myScene->_worldNode];
    
    myScene->_atlas = [SKTextureAtlas atlasNamed:@"sprite"];
    myScene->_noOfCollisionsWithEnemies = 0;

    
    myScene.name = @"scene";
    myScene.physicsWorld.gravity = CGVectorMake(0, 0);
    
    myScene.player = [[FishPlayer alloc] initWithScene:myScene];
    myScene->_background = [[Background alloc] initWithScene:myScene];
    [myScene->_worldNode addChild:myScene->_background];
    [myScene->_worldNode addChild:myScene.player];
    [SpritePrinter setupSounds:myScene];
    [SpritePrinter setupScoreLabel:myScene];
    
    [self setupMusicButton:myScene];
    [self setupSoundButton:myScene];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"music"]) {
        [[SKTAudio sharedInstance] playBackgroundMusic:@"bgMusic.mp3"];
    }
}

+ (void)setupSounds:(MyScene *)myScene
{
    myScene->_soundCoin = [SKAction playSoundFileNamed:@"coin.mp3" waitForCompletion:NO];
    myScene->_soundFalling = [SKAction playSoundFileNamed:@"coin.mp3" waitForCompletion:NO];
    myScene->_soundFlapping = [SKAction playSoundFileNamed:@"flap.mp3" waitForCompletion:NO];
    myScene->_soundHitGround = [SKAction playSoundFileNamed:@"hit.mp3" waitForCompletion:NO];
    myScene->_soundPop = [SKAction playSoundFileNamed:@"coin.mp3" waitForCompletion:NO];
    myScene->_soundWhack = [SKAction playSoundFileNamed:@"hit.mp3" waitForCompletion:NO];
}

+ (void)setupTutorial:(MyScene *)myScene
{
    [self setupMusicButton:myScene];
    [self setupSoundButton:myScene];
    
    myScene->_gameTitleLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    myScene->_gameTitleLabel.fontColor = kFontColor;
    myScene->_gameTitleLabel.fontSize = (IPAD?kFontIpad:kFontIphone)*3.5;
    myScene->_gameTitleLabel.text = @"FlyFish";
    myScene->_gameTitleLabel.zPosition = LayerUI;
    myScene->_gameTitleLabel.position = CGPointMake(myScene.size.width/1.8, myScene.size.height/2.2);
    [myScene->_worldNode addChild:myScene->_gameTitleLabel];
    
    myScene->_tutorialLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    myScene->_tutorialLabel.fontColor = kFontColor;
    myScene->_tutorialLabel.fontSize = (IPAD?kFontIpad:kFontIphone)*1.5;
    myScene->_tutorialLabel.text = NSLocalizedStringFromTable(@"TAP_TO_FLY", @"Translation", @"Tap to fly at first");
    myScene->_tutorialLabel.zPosition = LayerUI;
    myScene->_tutorialLabel.position = CGPointMake(myScene.size.width * 0.5, myScene.size.height*0.2);
    myScene->_tutorialLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [myScene->_worldNode addChild:myScene->_tutorialLabel];
}

+ (void)setupMusicButton:(MyScene *)myScene
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"music"]) {
        myScene->_musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"music-on"];
    } else {
        myScene->_musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"music-off"];
    }
    myScene->_musicButton.name = @"musicButton";
    myScene->_musicButton.zPosition = LayerUI;
    myScene->_musicButton.position = CGPointMake(myScene.size.width-myScene->_musicButton.size.width, myScene.size.height*0.9);
    [myScene->_worldNode addChild:myScene->_musicButton];
}

+ (void)setupSoundButton:(MyScene *)myScene
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"sound"]) {
        myScene->_soundButton = [SKSpriteNode spriteNodeWithImageNamed:@"sound-on"];
    } else {
        myScene->_soundButton = [SKSpriteNode spriteNodeWithImageNamed:@"sound-off"];
    }
    myScene->_soundButton.name = @"soundButton";
    myScene->_soundButton.zPosition = LayerUI;
    myScene->_soundButton.position = CGPointMake(myScene.size.width-myScene->_musicButton.size.width * 2.5, myScene.size.height*0.9);
    [myScene->_worldNode addChild:myScene->_soundButton];
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
    
    SKLabelNode *creditsLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    creditsLabel.text = NSLocalizedStringFromTable(@"CREDITS", @"Translation", @"Credits button");
    creditsLabel.zPosition = LayerUI;
    creditsLabel.fontSize = IPAD?kFontIpad/2:kFontIphone/2;
    creditsLabel.position = CGPointMake(myScene.size.width, 0);
    creditsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [myScene->_worldNode addChild:creditsLabel];
    //TODO
    //    gameOver.scale = 0;
    //    gameOver.alpha = 0;
    //    SKAction *group = [SKAction group:@[[SKAction fadeInWithDuration:0.3], [SKAction scaleTo:1.0 duration:0.3]
    //                                        ]];
    //    group.timingMode = SKActionTimingEaseInEaseOut;
}

@end
