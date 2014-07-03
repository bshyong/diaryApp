//
//  STNewEntryViewController.m
//  Diary
//
//  Created by Benjamin Shyong on 6/30/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STEntryViewController.h"
#import "STDiaryEntry.h"
#import "STCoreDataStack.h"

@interface STEntryViewController ()

@end

@implementation STEntryViewController

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
  if (self.entry != nil) {
    self.textField.text = self.entry.body;
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissSelf{
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)insertDiaryEntry{
  STCoreDataStack *coreDataStack = [STCoreDataStack defaultStack];
  STDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"STDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
  entry.body = self.textField.text;
  // need to calculate seconds since 1970 because
  // we are storing as scalar entries
  entry.date = [[NSDate date] timeIntervalSince1970];
  [coreDataStack saveContext];
  
}

-(void)updateDiaryEntry{
  self.entry.body = self.textField.text;
  STCoreDataStack *coreDataStack = [STCoreDataStack defaultStack];
  [coreDataStack saveContext];
}


- (IBAction)doneWasPressed:(id)sender {
  if (self.entry != nil) {
    [self updateDiaryEntry];
  } else {
     [self insertDiaryEntry];
  }
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
