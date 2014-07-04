//
//  STTableViewCell.m
//  Diary
//
//  Created by Benjamin Shyong on 7/4/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STTableViewCell.h"
#import "STDiaryEntry.h"

@interface STTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation STTableViewCell

+ (CGFloat)heightForEntry:(STDiaryEntry *)entry{
  const CGFloat topMargin = 35.0f;
  const CGFloat bottomMargin = 80.0f;
  const CGFloat minHeight = 85.0f;
  
  UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
  
  CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(202, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
  
  return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
  
}

-(void)configureCellForEntry:(STDiaryEntry *)entry{
  self.bodyLabel.text = entry.body;
  self.locationLabel.text = entry.location;
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
  self.dateLabel.text = [dateFormatter stringFromDate:date];
  
  if (entry.imageData) {
    self.mainImageView.image = [UIImage imageWithData:entry.imageData];
  } else {
    self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
  }
  
  if (entry.mood == STDiaryEntryMoodGood) {
      self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
  } else if (entry.mood == STDiaryEntryMoodAverage) {
      self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
  } else if (entry.mood == STDiaryEntryMoodBad) {
      self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
  }
  
}

@end
