//
//  STDiaryEntry.h
//  Diary
//
//  Created by Benjamin Shyong on 6/30/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ENUM(int16_t, STDiaryEntryMood){
  STDiaryEntryMoodGood = 0,
  STDiaryEntryMoodAverage = 1,
  STDiaryEntryMoodBad = 2
};

@interface STDiaryEntry : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic) int16_t mood;
@property (nonatomic, retain) NSString * location;

@end
