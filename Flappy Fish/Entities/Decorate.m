//
//  Decorate.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 17/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "Decorate.h"
#import "Tree.h"
#import "Rock.h"
#import "GrassLarge.h"
#import "GrassSmall.h"
#import "CloudLarge.h"
#import "Bushes.h"
#import "CloudSmall.h"

@implementation Decorate

- (instancetype)initWithTexture:(SKTexture *)texture scene:(MyScene *)myScene
{
    if (self = [super initWithTexture:texture scene:myScene]) {
        self.zPosition = LayerDecorate;
        self.position = CGPointMake(myScene.size.width + self.size.width/2, self.size.height/2);
    }
    return self;
}

+ (Decorate *)spawnWithScene:(MyScene *)myScene
{
    Decorate *decorate;
    if (RandomFloat() < kDecorateProbability) {
        DecorateType randomDecorate = (DecorateType) (arc4random() % (int) DecorateTypeMax);
        switch (randomDecorate) {
            case DecorateTypeTree:
                decorate = [[Tree alloc] initWithScene:myScene];
                break;
            case DecorateTypeRock:
                decorate = [[Rock alloc] initWithScene:myScene];
                break;
            case DecorateTypeGrassLarge:
                decorate = [[GrassLarge alloc] initWithScene:myScene];
                break;
            case DecorateTypeGrassSmall:
                decorate = [[GrassSmall alloc] initWithScene:myScene];
                break;
            case DecorateTypeCloudLarge:
                decorate = [[CloudLarge alloc] initWithScene:myScene];
                break;
            case DecorateTypeCloudSmall:
                decorate = [[CloudSmall alloc] initWithScene:myScene];
                break;
            case DecorateTypeBushes:
                decorate = [[Bushes alloc] initWithScene:myScene];
            default:
                break;
        }
    }
    return decorate;
}

@end
