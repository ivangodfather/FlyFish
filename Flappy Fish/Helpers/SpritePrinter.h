//
//  Spawn.h
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 13/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

@interface SpritePrinter : NSObject

+ (void)printBoard:(MyScene *)myScene;

+ (void)setupScene:(MyScene *)myScene;

+ (void)setupTutorial:(MyScene *)myScene;
+ (void)setupScoreLabel:(MyScene *)myScene;
+ (void)setupSounds:(MyScene *)myScene;
@end
