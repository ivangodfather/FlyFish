//
//  ViewController.m
//  FlyFish
//
//  Created by Ivan Ruiz Monjo on 11/03/14.
//  Copyright (c) 2014 Ivan Ruiz Monjo. All rights reserved.
//

#import "ViewController.h"
#import "GameKitHelper.h"


@interface ViewController () <MySceneDelegate>

@end

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene *scene = [[MyScene alloc] initWithSize:skView.bounds.size gameState:GameStateTutorial delegate:self];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
        [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    }
}

-(void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [self presentViewController:gameKitHelper.authenticationViewController animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden { return YES; }


- (UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,NO,1.0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)shareString:(NSString *)string image:(UIImage *)image
{
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[string, image] applicationActivities:nil];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
