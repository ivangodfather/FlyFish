//
//  Bug.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 14/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Bug.h"

@implementation Bug
{
    MyScene *_MyScene;
}

- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"bug"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        _MyScene = myScene;
        self.name = @"bug";
        self.scale = 0.2;
        float min = self.size.height*2;
        float max = myScene.size.height - self.size.height*2.5;
        self.position = CGPointMake(myScene.size.width + self.size.width/2, RandomFloatRange(min,max));
        [self attachPhysicsBodyToSpriteWithMarginWidth:kBugMarginWidth marginHeight:kBugMarginHeight];
        NSArray *textures = [NSArray arrayWithObjects:
                             [myScene->_atlas textureNamed:@"bug1"],
                             [myScene->_atlas textureNamed:@"bug2"],
                             nil];
        [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.2]]];
    }
    return self;
}

- (void)moveWithScene:(MyScene *)myScene;
{
    SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration:1];
    SKAction *moveLeft = [SKAction moveToX:-self.size.width/2 duration:kBugMoveDuration];
    SKAction *group = [SKAction group:@[oneRevolution, moveLeft]];
    [self runAction:[SKAction sequence:@[group, [SKAction removeFromParent]]]  withKey:@"move"];
    //TODO!
    //[SKAction followPath:<#(CGPathRef)#> asOffset:<#(BOOL)#> orientToPath:<#(BOOL)#> duration:<#(NSTimeInterval)#>]
}

- (int)force
{
    return kBugForce;
}

@end
