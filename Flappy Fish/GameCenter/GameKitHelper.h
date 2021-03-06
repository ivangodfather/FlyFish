//
//  GameKitHelper.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 20/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

static const float kNumberOfPlayers = 10;
static const float kNumberOfFriends = 10;

@import GameKit;
extern NSString *const PresentAuthenticationViewController;
extern NSString *const PlayerAuthenticated;
@interface GameKitHelper : NSObject

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;
@property (nonatomic, readonly) NSMutableSet *topScores;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)reportAchievements:(NSArray *)achievements;
- (void)showGKGameCenterViewController:(UIViewController *)viewController;
- (void)reportScore:(int64_t)score
   forLeaderboardID:(NSString*)leaderboardID;
- (void)getTopScoresWithNumOfScores:(int)numOfScores
                     playerScope:(GKLeaderboardPlayerScope)playerScope
                       timeScope:(GKLeaderboardTimeScope)timeScope
                forLeaderboardID:(NSString *)leaderboardID
           withCompletionHandler:(void(^)(NSArray *scoresArray))completionHandler;
@end
