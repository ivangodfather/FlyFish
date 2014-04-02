//
//  Vitamin.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 28/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Vitamin.h"
#import "VitaminRed.h"
#import "VitaminGreen.h"

@implementation Vitamin
{
    MyScene *_MyScene;
}

- (instancetype)initWithTexture:(SKTexture *)texture scene:(MyScene *)myScene
{
    _MyScene = myScene;
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.zPosition = LayerVitamin;
        self.position = CGPointMake(myScene.size.width + self.size.width/2, RandomFloatRange(self.size.height, myScene.size.height-self.size.height));
        [self attachPhysicsBodyToSpriteWithMarginWidth:1 marginHeight:1];
        self.physicsBody.categoryBitMask = PhysicsCategoryVitamin;
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.dynamic = NO;
    }
    return self;
}

- (void)applyActionsToPlayer { /* Abstract method */ }


+ (Vitamin *)spawnWithScene:(MyScene *)myScene
{
    Vitamin *vitamin;
    if(RandomFloat() < kVitaminProbability) {
        VitaminType randomVitamin = (VitaminType) (arc4random() % (int) VitaminTypeMax);
        switch (randomVitamin) {
            case VitaminTypeRed:
                vitamin = [[VitaminRed alloc] initWithScene:myScene];
                break;
            case VitaminTypeGreen:
                vitamin = [[VitaminGreen alloc] initWithScene:myScene];
            default:
                break;
        }
    }
    return vitamin;
}
@end
