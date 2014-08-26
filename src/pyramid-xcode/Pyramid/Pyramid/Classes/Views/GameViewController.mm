//
//  GameViewController.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 21/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "GameViewController.h"
#import "AppController.h"
#import "Utils.h"
#import "GameOverDialogDelegate.h"
#import "SuccessDialogDelegate.h"
#import "SharingManager.h"

@interface GameViewController ()

@end

@implementation GameViewController {
    GameOverDialogDelegate * gameOverDialogDelegate;
    SuccessDialogDelegate * successDialogDelegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        gameOverDialogDelegate = [[GameOverDialogDelegate alloc] init];
        successDialogDelegate = [[SuccessDialogDelegate alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    self.timeLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:15];
    [super viewDidLoad];

    [self.progress configureFlatProgressViewWithTrackColor:[UIColor silverColor]
                                             progressColor:[UIColor alizarinColor]];
    
    _pauseButton.buttonColor = [UIColor colorFromHexCode:@"23547c"];
    _pauseButton.shadowColor = [UIColor colorFromHexCode:@"153d5e"];
    _pauseButton.shadowHeight = 3.0f;
    _pauseButton.cornerRadius = 6.0f;
    [_pauseButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [_pauseButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;
    
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	//float contentScaleFactor = [director contentScaleFactor];

	glView.frame = rect;
}

- (IBAction)pauseGame:(id)sender {
    FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Sisyphus paused"
                                                          message:nil
                                                         delegate:self cancelButtonTitle:@"Back to game"
                                                otherButtonTitles:@"Go to Main Menu", @"Select another level", nil];
    alert.titleLabel.textColor = [UIColor cloudsColor];
    alert.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:20];
    alert.messageLabel.textColor = [UIColor cloudsColor];
    alert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alert.defaultButtonColor = [UIColor cloudsColor];
    alert.defaultButtonShadowColor = [UIColor asbestosColor];
    alert.defaultButtonTitleColor = [UIColor asbestosColor];
    
    AppController * app = [AppController instance];
    [app pauseGame];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    AppController * app = [AppController instance];
    if (buttonIndex == 0) {
        [app resumeGame];
    } else if (buttonIndex == 1){
        [app stopGame];
    } else {
        [app stopGame];
        [app showLevelSelectionView];
    }
    
}

- (void) showBallSuccess {
    self.ballSuccessLabel.alpha = 1.0;
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ self.ballSuccessLabel.alpha = 0.0;}
                     completion:nil];
}

- (void) showSuccessDialog:(int)resultSeconds {
    FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Congratulations! You're winner!"
                                                      message:[NSString stringWithFormat:@"The new record: %@", [Utils getTimeIntervalString:resultSeconds]]
                                                     delegate:successDialogDelegate cancelButtonTitle:@"Share a record"
                                            otherButtonTitles:@"Start the next level", @"Go to Main Menu", nil];
    alert.titleLabel.textColor = [UIColor cloudsColor];
    alert.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:20];
    alert.messageLabel.textColor = [UIColor cloudsColor];
    alert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alert.defaultButtonColor = [UIColor cloudsColor];
    alert.defaultButtonShadowColor = [UIColor asbestosColor];
    alert.defaultButtonTitleColor = [UIColor asbestosColor];
    
    [alert show];
}

- (void) showGameOverDialog {
    AppController * app = [AppController instance];
    [app pauseGame];
    FUIAlertView *alert = [[FUIAlertView alloc] initWithTitle:@"Ohh, Game Over!"
                                                      message: @"The record's not been beaten."
                                                     delegate:gameOverDialogDelegate cancelButtonTitle:@"Try Again"
                                            otherButtonTitles:@"Go to Main Menu", nil];
    alert.titleLabel.textColor = [UIColor cloudsColor];
    alert.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:20];
    alert.messageLabel.textColor = [UIColor cloudsColor];
    alert.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alert.defaultButtonColor = [UIColor cloudsColor];
    alert.defaultButtonShadowColor = [UIColor asbestosColor];
    alert.defaultButtonTitleColor = [UIColor asbestosColor];
    
    [alert show];
}

@end
