//
//  User.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 03/04/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

@import GameKit;

@interface PlayerResult : NSObject

@property (nonatomic, strong) GKPlayer *player;
@property (nonatomic, strong) GKScore *score;
@property (nonatomic, strong) UIImage *photo;

+ (PlayerResult *)playerResultWith:(GKPlayer *)player score:(GKScore *)score andPhoto:(UIImage *)photo;

@end
