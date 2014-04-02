//
//  User.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 03/04/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "PlayerResult.h"

@implementation PlayerResult

+ (PlayerResult *)playerResultWith:(GKPlayer *)player score:(GKScore *)score andPhoto:(UIImage *)photo
{
    PlayerResult *playerResult = [PlayerResult new];
    playerResult.player = player;
    playerResult.score = score;
    playerResult.photo = photo;
    return playerResult;
}

@end
