//
//  STTableViewCell.h
//  Diary
//
//  Created by Benjamin Shyong on 7/4/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STDiaryEntry;

@interface STTableViewCell : UITableViewCell

+ (CGFloat)heightForEntry:(STDiaryEntry *)entry;
- (void)configureCellForEntry:(STDiaryEntry *)entry;

@end
