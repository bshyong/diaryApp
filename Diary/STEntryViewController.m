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

@interface STEntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) UIImage *pickedImage;
@property (nonatomic, assign) enum STDiaryEntryMood pickedMood;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;

@property (strong, nonatomic) IBOutlet UIView *accessoryView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

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
    self.textView.text = self.entry.body;
    self.pickedMood = self.entry.mood;
    date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
    self.pickedImage = [UIImage imageWithData:self.entry.imageData];
  } else {
    self.pickedImage = nil;
    self.pickedMood = STDiaryEntryMoodAverage;
    date = [NSDate date];
  }
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"EEEE, MMMM d, yyyy"];
  self.dateLabel.text = [dateFormatter stringFromDate:date];
  
  // set the corner radius on the image button
  self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2.0f;
  
  // makes mood buttons appear on top of the keyboard as an input accessory view
  self.textView.inputAccessoryView = self.accessoryView;

}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissSelf{
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Override default setters

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

-(void)setPickedImage:(UIImage *)pickedImage{
  _pickedImage = pickedImage;
  if (pickedImage == nil) {
    [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
  } else {
    [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
  }
}

-(void)insertDiaryEntry{
  STCoreDataStack *coreDataStack = [STCoreDataStack defaultStack];
  STDiaryEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"STDiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
  entry.body = self.textView.text;
  // need to calculate seconds since 1970 because
  // we are storing as scalar entries
  entry.date = [[NSDate date] timeIntervalSince1970];
  entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
  entry.mood = self.pickedMood;
  [coreDataStack saveContext];
  
}

-(void)updateDiaryEntry{
  self.entry.body = self.textView.text;
  self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
  self.entry.mood = self.pickedMood;
  STCoreDataStack *coreDataStack = [STCoreDataStack defaultStack];
  [coreDataStack saveContext];
}

#pragma mark - Image Picker prompts

-(void)promptForSource{
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
  [actionSheet showInView:self.view];
}

-(void)promptForPhotoRoll{
  UIImagePickerController *controller = [[UIImagePickerController alloc] init];
  controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  controller.delegate = self;
  [self presentViewController:controller animated:YES completion:nil];
}

-(void)promptForCamera{
  UIImagePickerController *controller = [[UIImagePickerController alloc] init];
  controller.sourceType = UIImagePickerControllerSourceTypeCamera;
  controller.delegate = self;
  [self presentViewController:controller animated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  if (buttonIndex != actionSheet.cancelButtonIndex) {
    if (buttonIndex != actionSheet.firstOtherButtonIndex) {
      [self promptForCamera];
    } else {
      [self promptForPhotoRoll];
    }
  }
}

#pragma mark - Image Picker delegate actions

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
  UIImage *image = info[UIImagePickerControllerOriginalImage];
  self.pickedImage = image;
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

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

- (IBAction)imageButtonWasPressed:(id)sender {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    [self promptForSource];
  } else {
    [self promptForPhotoRoll];
  }
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
