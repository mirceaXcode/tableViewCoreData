//
//  ViewController.m
//  tableViewCoreData
//
//  Created by Mircea Popescu on 8/9/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "ViewController.h"
#import "ToDoEntity+CoreDataClass.h"
#import "TableViewCell.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong,nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NSFetchedResultsController delegate
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"ToDoEntity" inManagedObjectContext:_myContext];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]];
    
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_myContext sectionNameKeyPath:nil cacheName:nil];
    _resultsController.delegate = self;
    
    NSError *err;
    
    BOOL fetchSucceeded = [_resultsController performFetch:&err];
    
    if(!fetchSucceeded){
         @throw [NSException exceptionWithName:NSGenericException reason:@"Could't fetch!" userInfo:@{NSUnderlyingErrorKey:err}];
    }
    
}

- (IBAction)todoTapped:(id)sender {
    // Get the text
    NSString *text = _textField.text;
    NSManagedObjectContext *ctx = _myContext;
    
    // Store the text in a CoreData object
    ToDoEntity *item = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoEntity" inManagedObjectContext:ctx];
    item.title = text;
    
    // Save the CoreData object
    NSError *err;
    BOOL saveSuccess = [ctx save:&err];
    if (!saveSuccess){
        @throw [NSException exceptionWithName:NSGenericException reason:@"Could't save!" userInfo:@{NSUnderlyingErrorKey:err}];
    }
    else{
        _textField.text = nil;
    }
}

#pragma mark - TableView Delegates

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultsController.sections[section].numberOfObjects;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ToDoEntity *item = _resultsController.sections[indexPath.section].objects[indexPath.row];
    
    TableViewCell *cell = (TableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    [cell setTitle:item];
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [_tableView beginUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:{
            TableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            ToDoEntity *item = [controller objectAtIndexPath:indexPath];
            [cell setTitle:item];
            break;
        }
        case NSFetchedResultsChangeMove:
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
     [_tableView endUpdates];
}

@end
