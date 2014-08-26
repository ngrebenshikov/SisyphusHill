//
//  MainMenuViewController.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 05/06/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppController.h"
#import "SharingManager.h"
#import "Utils.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:@"PTSans-Caption" size:(IS_IPAD) ? 50 : 30];
    self.descriptionLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:(IS_IPAD) ? 20 : 13];

    self.startButton.buttonColor = [UIColor turquoiseColor];
    self.startButton.shadowColor = [UIColor greenSeaColor];
    self.startButton.shadowHeight = 3.0f;
    self.startButton.cornerRadius = 6.0f;
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.startButton.font = [UIFont fontWithName:@"PTSans-Regular" size:20];

    self.shareButton.buttonColor = [UIColor colorFromHexCode:@"23547c"];
    self.shareButton.shadowColor = [UIColor colorFromHexCode:@"153d5e"];
    self.shareButton.shadowHeight = 3.0f;
    self.shareButton.cornerRadius = 6.0f;
    [self.shareButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.shareButton.font = [UIFont fontWithName:@"PTSans-Regular" size:20];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGame:(id)sender {
    AppController * app = [AppController instance];
    [app showLevelSelectionView];
}

- (IBAction)share:(id)sender {
    [[SharingManager instance] shareApplication:self];
}

@end
