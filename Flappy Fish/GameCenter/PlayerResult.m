//
//  User.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 03/04/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "PlayerResult.h"
@import GameKit;

@implementation PlayerResult

+ (PlayerResult *)playerResultWith:(GKPlayer *)player score:(GKScore *)score andPhoto:(UIImage *)photo
{
    PlayerResult *playerResult = [PlayerResult new];
    playerResult.player = player;
    playerResult.score = score;
    playerResult.photo = photo;
    return playerResult;
}

- (BOOL)isEqual:(id)object
{
    return (([object isKindOfClass:[self class]]) && ([_player.playerID  isEqualToString:((PlayerResult *)object).player.playerID]));
}

- (NSUInteger)hash { return [self.player.playerID hash]; }


@end
