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
    MyScene *_myScene;
}

- (instancetype)initWithScene:(MyScene *)myScene
{
    SKTexture *texture = [myScene->_atlas textureNamed:@"bug1"];
    if (self = [super initWithTexture:texture scene:myScene]) {
        _myScene = myScene;
        self.name = @"bug";
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
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(myScene.size.width, myScene.size.height/RandomFloatRange(1.5, 2.5))];
    [path addLineToPoint:CGPointMake(myScene.size.width*RandomFloatRange(0.2, 0.5), myScene.size.height/2)];
    [path addArcWithCenter:path.currentPoint radius:myScene.size.height/RandomFloatRange(3, 5) startAngle:0 endAngle:DegreesToRadians(360) clockwise:YES];
    [path addLineToPoint:CGPointMake(0, myScene.size.height/2)];
    [self runAction:[SKAction sequence:@[[SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:kBugMoveDuration],[SKAction removeFromParent]]]];
}

- (int)force
{
    return kBugForce;
}

@end
