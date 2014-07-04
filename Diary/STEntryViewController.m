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
@property (nonatomic, assign) enum STDiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;

@property (strong, nonatomic) IBOutlet UIView *accessoryView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

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
  
  NSDate *date;
  
  if (self.entry != nil) {
    self.textField.text = self.entry.body;
    self.pickedMood = self.entry.mood;
    date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
  } else {
    self.pickedMood = STDiaryEntryMoodAverage;
    date = [NSDate date];
  }
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
  self.dateLabel.text = [dateFormatter stringFromDate:date];
  
  // makes mood buttons appear on top of the keyboard as an input accessory view
  self.textField.inputAccessoryView = self.accessoryView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissSelf{
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)setPickedMood:(enum STDiaryEntryMood)pickedMood{
  _pickedMood = pickedMood;
  
  self.badButton.alpha = 0.5f;
  self.goodButton.alpha = 0.5f;
  self.averageButton.alpha = 0.5f;
  
  switch (pickedMood) {
    case STDiaryEntryMoodGood:
      self.goodButton.alpha = 1.0f;
      break;
    case STDiaryEntryMoodAverage:
      self.averageButton.alpha = 1.0f;
      break;
    case STDiaryEntryMoodBad:
      self.badButton.alpha = 1.0f;
      break;
  }
  
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

- (IBAction)badWasPressed:(id)sender {
  self.pickedMood = STDiaryEntryMoodBad;
}

- (IBAction)averageWasPressed:(id)sender {
  self.pickedMood = STDiaryEntryMoodAverage;
}

- (IBAction)goodWasPressed:(id)sender {
  self.pickedMood = STDiaryEntryMoodGood;
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
