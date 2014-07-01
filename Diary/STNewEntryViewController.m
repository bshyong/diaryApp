//
//  STNewEntryViewController.m
//  Diary
//
//  Created by Benjamin Shyong on 6/30/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STNewEntryViewController.h"

@interface STNewEntryViewController ()

@end

@implementation STNewEntryViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissSelf{
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneWasPressed:(id)sender {
  [self dismissSelf];
}

- (IBAction)cancelWasPressed:(id)sender {
  [self dismissSelf];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
