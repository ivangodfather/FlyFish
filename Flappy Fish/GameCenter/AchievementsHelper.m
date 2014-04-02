//
//  AchievementsHelper.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 25/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "AchievementsHelper.h"

static NSString* const kCollision10Enemy = @"colisionar_10_enemigos";
static NSString* const kCollision20Enemy = @"colisionar_20_enemigos";
static NSString* const kCollision30Enemy = @"colisionar_30_enemigos";



@implementation AchievementsHelper
//TODO  y quizá 10 in a row? o hacer leaderboard de veces jugado? creo que 10 in a row 20 in a row etc.
+ (GKAchievement *)achievementWithCollisions:(int)collisions
{
    GKAchievement *collisionAchievement;
    switch (collisions) {
        case 10:
            collisionAchievement = [[GKAchievement alloc] initWithIdentifier:kCollision10Enemy];
            break;
        case 20:
            collisionAchievement = [[GKAchievement alloc] initWithIdentifier:kCollision20Enemy];
            break;
        case 30:
            collisionAchievement = [[GKAchievement alloc] initWithIdentifier:kCollision30Enemy];
            break;
        default:
            break;
    }
    if (collisionAchievement) {
        collisionAchievement.percentComplete = 100;
        collisionAchievement.showsCompletionBanner = YES;
        return collisionAchievement;
    }
    return nil;
}

@end
