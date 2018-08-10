//
//  TableViewCell.m
//  tableViewCoreData
//
//  Created by Mircea Popescu on 8/9/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Look into CoreData and get the title and assign it to our Cell Label text title
-(void) setTitle:(ToDoEntity *) incoming{
    _cellLabel.text = incoming.title;
}

@end
