//
//  TableViewCell.h
//  tableViewCoreData
//
//  Created by Mircea Popescu on 8/9/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoEntity+CoreDataClass.h"


@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

-(void) setTitle:(ToDoEntity *) incoming;

@end
