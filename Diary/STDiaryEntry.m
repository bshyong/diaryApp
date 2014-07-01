//
//  STDiaryEntry.m
//  Diary
//
//  Created by Benjamin Shyong on 6/30/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STDiaryEntry.h"


@implementation STDiaryEntry

@dynamic date;
@dynamic body;
@dynamic imageData;
@dynamic mood;
@dynamic location;

-(NSString *)sectionName{
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MMM YYYY"];

  return [dateFormatter stringFromDate:date];
}

@end
