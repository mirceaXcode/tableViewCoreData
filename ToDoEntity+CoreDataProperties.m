//
//  ToDoEntity+CoreDataProperties.m
//  tableViewCoreData
//
//  Created by Mircea Popescu on 8/9/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//
//

#import "ToDoEntity+CoreDataProperties.h"

@implementation ToDoEntity (CoreDataProperties)

+ (NSFetchRequest<ToDoEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ToDoEntity"];
}

@dynamic title;

@end
