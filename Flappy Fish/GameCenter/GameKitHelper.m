//
//  GameKitHelper.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 20/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "GameKitHelper.h"
#import "PlayerResult.h"

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const PlayerAuthenticated = @"player_authenticated";

@interface GameKitHelper () <GKGameCenterControllerDelegate>

@end

@implementation GameKitHelper
{
    BOOL _enableGameCenter;
}

+ (instancetype)sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        [self setLastError:error];
        if (viewController) {
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            _enableGameCenter = YES;
            [self getTopScores];
            [[NSNotificationCenter defaultCenter] postNotificationName:PlayerAuthenticated object:self];
        } else {
            _enableGameCenter = NO;
        }
    };
}

- (void)getTopScores
{
    _topScores = [NSMutableSet set];
    [self getTopScoresWithNumOfScores:kNumberOfPlayers
                          playerScope:GKLeaderboardPlayerScopeFriendsOnly
                            timeScope:GKLeaderboardTimeScopeAllTime
                     forLeaderboardID:kLeaderBoardID
                withCompletionHandler:^(NSArray *scoresFriendsArray) {
                    [_topScores addObjectsFromArray:scoresFriendsArray];
                    [self getTopScoresWithNumOfScores:kNumberOfFriends
                                          playerScope:GKLeaderboardPlayerScopeGlobal
                                            timeScope:GKLeaderboardTimeScopeAllTime
                                     forLeaderboardID:kLeaderBoardID
                                withCompletionHandler:^(NSArray *scoresAllArray) {
                                    [_topScores addObjectsFromArray:scoresAllArray];
                                }];
                }];
    
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter] postNotificationName:PresentAuthenticationViewController object:self];
    }
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
}

- (void)reportAchievements:(NSArray *)achievements
{
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
    [GKAchievement reportAchievements:achievements
                withCompletionHandler:^(NSError *error ){
                    [self setLastError:error];
                }];
}

- (void)showGKGameCenterViewController:(UIViewController *)viewController
{
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
    GKGameCenterViewController *gameCenterViewController = [[GKGameCenterViewController alloc] init];
    gameCenterViewController.gameCenterDelegate = self;
    gameCenterViewController.viewState = GKGameCenterViewControllerStateDefault;
    [viewController presentViewController:gameCenterViewController
                                 animated:YES
                               completion:nil];
}

- (void)gameCenterViewControllerDidFinish:
(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES
                                                 completion:nil];
}

- (void)reportScore:(int64_t)score forLeaderboardID:(NSString *)leaderboardID
{
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboardID];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores
    withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
    }];
}



- (void)getTopScoresWithNumOfScores:(int)numOfScores
                        playerScope:(GKLeaderboardPlayerScope)playerScope
                          timeScope:(GKLeaderboardTimeScope)timeScope
                   forLeaderboardID:(NSString *)leaderboardID
              withCompletionHandler:(void(^)(NSArray *scoresArray))completionHandler
{
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
    //Configure request
    GKLeaderboard *leaderBoard = [[GKLeaderboard alloc] init];
    leaderBoard.identifier = kLeaderBoardID;
    leaderBoard.timeScope = timeScope;
    leaderBoard.playerScope = playerScope;
    leaderBoard.range = NSMakeRange(1, numOfScores);
    
    //Fetch the request
    NSMutableArray *array = [NSMutableArray array];
    [leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if (error) {
            [self setLastError:error];
        }
        __block int finished = 0;
        for (GKScore *score in scores) {
            PlayerResult *playerResult = [PlayerResult new];
            [GKPlayer loadPlayersForIdentifiers:@[score.playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
                finished++;
                GKPlayer *player = [players lastObject];
                playerResult.player = player;
                [player loadPhotoForSize:GKPhotoSizeNormal withCompletionHandler:^(UIImage *photo, NSError *error) {
                    if (photo) playerResult.photo = photo;
                }];
                if (finished  == scores.count) {
                    completionHandler(array);
                }
            }];
            playerResult.score = score;
            [array addObject:playerResult];
        }
        
    }];
    
}



@end
