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

//TODO RETOCAR 25
static NSUInteger instances = 0;

@implementation Obstacle
{
    MyScene *_MyScene;
}

- (instancetype)initWithTexture:(SKTexture *)texture scene:(MyScene *)myScene
{
    if (self = [super initWithTexture:texture scene:myScene]) {
        _MyScene = myScene;
        instances++;
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

- (void)addPlayer:(GKPlayer *)player
{
    if (!player) {
        NSLog(@"No player!");
        return;
    }
    NSLog(@"%@",player);
    
    
    [player loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
        SKTexture *texture;
        CGSize size = IPAD?CGSizeMake(kAvatarSize, kAvatarSize):CGSizeMake(kAvatarSize/1.5, kAvatarSize/1.5);
        texture = (error || !photo)?[_MyScene->_atlas textureNamed:@"avatar"]:[SKTexture textureWithImage:photo];
        SKSpriteNode *imageNode = [SKSpriteNode spriteNodeWithTexture:texture];
        [imageNode setSize:size];
        SKCropNode *cropNode = [SKCropNode node];
        SKSpriteNode *maskShapeNode = [SKSpriteNode spriteNodeWithTexture:[_MyScene->_atlas textureNamed:@"picture-frame-mask"]];
        [cropNode setMaskNode:maskShapeNode];
        [cropNode addChild:imageNode];
        cropNode.position = CGPointMake(0, self.size.height/2 + imageNode.size.height/2);
        cropNode.alpha = 0.7;
        [self addChild:cropNode];
    }];
    SKLabelNode *aliasLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    aliasLabel.text = player.alias;
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
    }
    return obstacle;
}

+ (void)moveNewObstacle:(Obstacle *)newObstacle fromLastObstacle:(Obstacle *)lastObstacle withScene:(MyScene *)scene
{
    /* Abstrac Method */
}

+ (NSUInteger) numberOfInstances {
    return instances;
}

+ (void)resetNumberOfInstances
{
    instances = 0;
}


@end