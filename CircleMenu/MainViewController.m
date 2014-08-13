//
//  MainViewController.m
//  CircleMenu
//
//  Created by shinsoft on 2013/12/27.
//  Copyright (c) 2013年 shinsoft. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:YES];
	// Do any additional setup after loading the view, typically from a nib.
//    CircleItem *test_item = [[CircleItem alloc] init];
    
    NSArray *icons = [[NSArray alloc] initWithObjects:@"17.png", @"10.png", @"13.png", @"8.png", @"7.png", @"12.png", nil];
    
    
    CircleMenu *phony_menu = [[CircleMenu alloc] initMenu];
    [phony_menu set_icons:icons];
    phony_menu.delegate = self;
    [self.view addSubview:phony_menu];
//    CircleItem *phony_item = [[CircleItem alloc] initWithLable:@"TESTing" and_number:1];
//    [self.view addSubview:phony_item];
}
-(void)item_chosen:(NSInteger)chosen_number
{
    NSLog(@"%ld", (long)chosen_number);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
