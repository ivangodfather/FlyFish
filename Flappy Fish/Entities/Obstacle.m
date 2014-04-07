//
//  Obstacles.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 19/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Obstacle.h"
#import "Pipe.h"
#import "UIImage+AddOn.h"
#import "PlayerResult.h"
#import "Vitamin.h"


static NSUInteger _instances = 0;
static Obstacle *_lastAdded;

@implementation Obstacle
{
    MyScene *_MyScene;
}

- (instancetype)initWithTexture:(SKTexture *)texture scene:(MyScene *)myScene
{
    if (self = [super initWithTexture:texture scene:myScene]) {
        _MyScene = myScene;
        _instances++;
        self.zPosition = LayerObstacle;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        [self skt_attachDebugRectWithSize:self.size color:[SKColor redColor]];
        
        self.physicsBody.categoryBitMask = PhysicsCategoryObstacle;
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.dynamic = NO;
        self.physicsBody.friction = 0;
        
    }
    return self;
}

+ (CGFloat)spawnDelay
{
    return kObstacleSpawnDelay;
}

- (void)addPlayerResult:(PlayerResult *)playerResult
{
    if (!playerResult) {
        NSLog(@"No playerresult!");
        return;
    }
    
    SKTexture *texture;
    CGSize size = IPAD?CGSizeMake(kAvatarSize, kAvatarSize):CGSizeMake(kAvatarSize/1.5, kAvatarSize/1.5);
    texture = (!playerResult.photo)?[_MyScene->_atlas textureNamed:@"avatar"]:[SKTexture textureWithImage:playerResult.photo];
    SKSpriteNode *imageNode = [SKSpriteNode spriteNodeWithTexture:texture];
    [imageNode setSize:size];
    SKCropNode *cropNode = [SKCropNode node];
    SKSpriteNode *maskShapeNode = [SKSpriteNode spriteNodeWithTexture:[_MyScene->_atlas textureNamed:@"picture-frame-mask"]];
    [cropNode setMaskNode:maskShapeNode];
    [cropNode addChild:imageNode];
    cropNode.position = CGPointMake(0, self.size.height/2 + imageNode.size.height/2);
    cropNode.alpha = 0.7;
    [self addChild:cropNode];
    SKLabelNode *aliasLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    aliasLabel.text = playerResult.player.alias;
    aliasLabel.fontSize = IPAD?kFontSize:kFontSize/2;
    aliasLabel.zPosition = 1;
    aliasLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    SKSpriteNode *labelBg = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:aliasLabel.frame.size];
    labelBg.position = CGPointMake(0, self.size.height/2);
    [labelBg addChild:aliasLabel];
    [self addChild:labelBg];
}

+ (Obstacle *)spawnWithScene:(MyScene *)myScene
{
    Obstacle *obstacle;

    if(RandomFloat() < kObstacleProbability) {
        ObstacleType randomObstacle = (ObstacleType) (arc4random() % (int) ObstacleTypeMax);
        switch (randomObstacle) {
            case ObstacleTypePipe:
                obstacle = [[Pipe alloc] initWithScene:myScene];
                break;
            default:
                break;
        }
    } else {
        _lastAdded = nil;
    }
    return obstacle;
}

+ (void)moveNewObstacle:(Obstacle *)newObstacle fromLastObstacle:(Obstacle *)lastObstacle withScene:(MyScene *)scene
{
    /* Abstrac Method */
}

+ (NSUInteger) numberOfInstances {
    return _instances;
}

+ (void)resetNumberOfInstances
{
    _instances = 0;
}

+ (Obstacle *)lastAdded
{
    return _lastAdded;
}

+ (void)setLastAdded:(Obstacle *)obstacle
{
    _lastAdded = obstacle;
}


@end