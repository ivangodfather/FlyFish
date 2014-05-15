//
//  FishPlayer.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 25/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "FishPlayer.h"
#import "Background.h"
#define SOUND_IS_ON ([[NSUserDefaults standardUserDefaults] integerForKey:@"sound"])


@implementation FishPlayer
{
    MyScene *_myScene;
    SKAction *_soundFlapping;
}

- (instancetype)initWithScene:(MyScene *)myScene
{
    if (self = [super initWithTexture:[myScene->_atlas textureNamed:@"fish1.png"]]) {
        _myScene = myScene;
        _soundFlapping = [SKAction playSoundFileNamed:@"flap.mp3" waitForCompletion:NO];
        
        self.position = CGPointMake(kStartPosition, myScene.size.height*0.5);
        self.name = @"fish";
        self.zPosition = LayerPlayer;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = PhysicsCategoryPlayer;
        self.physicsBody.collisionBitMask = PhysicsCategoryObstacle;
        self.physicsBody.contactTestBitMask = PhysicsCategoryEnemy | PhysicsCategoryEmitter | PhysicsCategoryVitamin | PhysicsCategoryObstacle;
        NSArray *textures = [NSArray arrayWithObjects:
                             [myScene->_atlas textureNamed:@"fish1.png"],
                             [myScene->_atlas textureNamed:@"fish2.png"],
                             [myScene->_atlas textureNamed:@"fish3.png"],
                             [myScene->_atlas textureNamed:@"fish4.png"],
                             nil];
        SKAction *animateTextures = [SKAction animateWithTextures:textures timePerFrame:0.1];
        [self runAction:[SKAction repeatActionForever:animateTextures] withKey:@"player"];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction performSelector:@selector(impulsePlayer) onTarget:self],[SKAction waitForDuration:0.5]]]]];
    }
    return self;
}

- (void)flapFish
{
    self.velocity = CGPointMake(0, kFlapImpulse);
    if  SOUND_IS_ON [self runAction:_soundFlapping];
    
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                  [[NSBundle mainBundle] pathForResource:@"FireParticle"
                                                                  ofType:@"sks"]];
    
    [self addChild:emitterNode];
    emitterNode.position = CGPointMake(-self.size.width/3,-self.size.height/3);
    emitterNode.targetNode = _myScene;
    
    SKAction *rotate = [SKAction rotateByAngle:DegreesToRadians(30) duration:0.5];
    SKAction *rotateDown = [SKAction rotateByAngle:DegreesToRadians(-20) duration:0.1];
    [self runAction:[SKAction sequence:@[rotate, [rotate reversedAction], rotateDown, [rotateDown reversedAction]]]];
}

- (void)impulsePlayer
{
    [self runAction:[SKAction rotateToAngle:0 duration:0.5]];
    if (self.position.x > kStartPosition) {
        self.velocity = CGPointMake(0, self.velocity.y);
        self.physicsBody.velocity = CGVectorMake(0, 0);
        return;
    }
    if (self.position.x < kStartPosition) {
        float impulseX = (kStartPosition - self.position.x)/50;
        CGVector vector = CGVectorMake(impulseX, 0);
        [self.physicsBody applyImpulse:vector];
    }
}

- (void)dead
{
    SKAction *moveUp = [SKAction moveByX:0 y:10 duration:1];
    SKAction *moveDown = [SKAction moveTo:CGPointMake(self.position.x, self.size.height/2) duration:3];
    SKAction *moveUpDown = [SKAction sequence:@[moveUp, moveDown]];
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.categoryBitMask = 0;
    NSArray *textures = [NSArray arrayWithObjects:
                         [_myScene->_atlas textureNamed:@"dead1.png"],
                         [_myScene->_atlas textureNamed:@"dead2.png"],
                         [_myScene->_atlas textureNamed:@"dead3.png"],
                         [_myScene->_atlas textureNamed:@"dead4.png"],
                         nil];
    SKAction *animateTextures = [SKAction animateWithTextures:textures timePerFrame:0.5];
    SKAction *moveFoward = [SKAction moveBy:CGVectorMake(self.size.width*3, 0) duration:1];
    [self runAction:[SKAction group:@[moveFoward,moveUpDown, animateTextures]]];
}

- (void)fishGravity
{
    CGPoint gravity = CGPointMake(0, kPlayerGravity);
    CGPoint gravityStep = CGPointMultiplyScalar(gravity, _myScene->_dt);
    self.velocity = CGPointAdd(self.velocity, gravityStep);
    CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, _myScene->_dt);
    self.position = CGPointAdd(self.position, velocityStep);
    if (self.position.y < self.size.height/2) {
        self.position = CGPointMake(self.position.x, self.size.height/2);
    }
    int maxY = _myScene.size.height - self.size.height/2;
    if (self.position.y > maxY) {
        self.position = CGPointMake(self.position.x, maxY);
    }
}

@end
