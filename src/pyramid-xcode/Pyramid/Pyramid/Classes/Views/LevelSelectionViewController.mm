//
//  LevelSelectionViewController.m
//  Pyramid
//
//  Created by Nickolay Grebenshikov on 13/05/14.
//  Copyright (c) 2014 Nickolay Grebenshikov. All rights reserved.
//

#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

#import "LevelButton.h"
#import "AppController.h"
#import "LevelSelectionViewController.h"

@interface LevelSelectionViewController ()

@property (weak, nonatomic) IBOutlet LevelButton *button1;
@property (weak, nonatomic) IBOutlet LevelButton *button2;
@property (weak, nonatomic) IBOutlet LevelButton *button3;
@property (weak, nonatomic) IBOutlet LevelButton *button4;
@property (weak, nonatomic) IBOutlet LevelButton *button5;
@property (weak, nonatomic) IBOutlet LevelButton *button6;
@property (weak, nonatomic) IBOutlet LevelButton *button7;
@property (weak, nonatomic) IBOutlet LevelButton *button8;
@property (weak, nonatomic) IBOutlet LevelButton *button9;

@property (nonatomic, readonly) NSArray * buttons;

@end

@implementation LevelSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    self.titleLabel.font = [UIFont fontWithName:@"PTSans-Regular" size:(IS_IPAD) ? 50 : 35];
    [self updateButtons];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startGame:(id)sender {
    LevelButton *lb = sender;
    [((AppController *)[AppController instance]) startGame:lb.level];
}

- (NSArray *) buttons {
    return @[self.button1, self.button2, self.button3, self.button4, self.button5, self.button6, self.button7, self.button8, self.button9];
}

- (void) updateButtons {
    AppController * app = [AppController instance];
    
    for (LevelButton *b in self.buttons) {
        
        Level * l = [app.levels objectAtIndex:b.level-1];
        
        b.buttonColor = (l.resultSeconds <= 0) ? [UIColor turquoiseColor] : [UIColor colorFromHexCode:@"e78739"];
        b.shadowColor = (l.resultSeconds <= 0) ? [UIColor greenSeaColor] : [UIColor colorFromHexCode:@"be5e2a"];
        b.shadowHeight = 3.0f;
        b.cornerRadius = 6.0f;
        [b setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    }
}

@end
