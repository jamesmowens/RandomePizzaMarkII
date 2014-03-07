//
//  RandomPizzaGeneratorToppingViewController.m
//  RandomePizzaMarkII
//
//  Created by James Owens on 1/30/14.
//  Copyright (c) 2014 James Owens. All rights reserved.
//

#import "RandomPizzaGeneratorToppingViewController.h"

@interface RandomPizzaGeneratorToppingViewController ()

@property (nonatomic, strong) NSMutableDictionary *currentlySelectedToppings; //the toppings that are checked in the table view
@property (nonatomic, strong) NSMutableDictionary *indexPathOfTopping; //holds the index path based on the topping name which is the key.
@property (nonatomic, strong) NSMutableArray *disabledVegitarian;
@property (nonatomic, strong) NSMutableArray *disabledVegan;
@end

@implementation RandomPizzaGeneratorToppingViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self disableSpeicalCells];
    
}
- (IBAction)testButtonPressed:(id)sender
{
    for (RandomPizzaGeneratorCell *cell in self.disabledVegan) {
        cell.userInteractionEnabled = YES;
        cell.textLabel.enabled = YES;
    }
    for (RandomPizzaGeneratorCell *cell in self.disabledVegitarian) {
        cell.userInteractionEnabled = YES;
        cell.textLabel.enabled = YES;
    }
}

-(NSMutableArray *)disabledVegan
{
    if (!_disabledVegan)
    {
        _disabledVegan = [[NSMutableArray alloc]init];
    }
    return _disabledVegan;
}

-(NSMutableArray *)disabledVegitarian
{
    if (!_disabledVegitarian)
    {
        _disabledVegitarian = [[NSMutableArray alloc]init];
        
    }
    return _disabledVegitarian;
}

-(NSMutableDictionary *)currentlySelectedToppings
{
    if(!_currentlySelectedToppings)
    {
        _currentlySelectedToppings = [[NSMutableDictionary alloc]init];
        
    }
    return _currentlySelectedToppings;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.allowsSelection = YES;
    [self makeIntoDicionary];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableDictionary *)indexPathOfTopping
{
    if (!_indexPathOfTopping) {
        _indexPathOfTopping = [[NSMutableDictionary alloc]init];
    }
    return _indexPathOfTopping;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.brain.toppings count];
}

- (RandomPizzaGeneratorCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    RandomPizzaGeneratorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Topping *toppingAtIndex = self.brain.toppings[indexPath.row];
   
    
    if ([self.currentlySelectedToppings objectForKey:toppingAtIndex.name])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    cell.textLabel.text = toppingAtIndex.name;
    cell.cellsTopping = toppingAtIndex;
    if (![self.indexPathOfTopping objectForKey:toppingAtIndex.name])
    {
        [self.indexPathOfTopping setObject:cell forKey:toppingAtIndex.name];
        
    }
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.brain saveState];
    
    RandomPizzaGeneratorViewController *destination = [segue destinationViewController];
    
    destination.brain = self.brain;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[tableView cellForRowAtIndexPath:indexPath ] accessoryType] == UITableViewCellAccessoryCheckmark)
    {
        
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        RandomPizzaGeneratorCell *toppingCell = (RandomPizzaGeneratorCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self.currentlySelectedToppings removeObjectForKey:toppingCell.cellsTopping.name];
        
         
        
    }
    else
    {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];//add a check mark
        
        //add the toppping in the cell to the dictionary of currently selected toppings
        RandomPizzaGeneratorCell *toppingCell = (RandomPizzaGeneratorCell *)[tableView cellForRowAtIndexPath:indexPath];//
        [self.currentlySelectedToppings setObject:toppingCell.cellsTopping forKey:toppingCell.cellsTopping.name];
        
    }
    [self prepareCurrentToppingsForSegue]; 
    
}

//disables the cells that don't comply if the user is vegitarian or vegan
-(void)disableSpeicalCells
{
    if (self.brain.userVegan)
    {
        for (Topping *topping in self.brain.toppings)
        {
            if (!topping.vegan)
            {
                RandomPizzaGeneratorCell *cell = [self.indexPathOfTopping objectForKey:topping.name];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = NO;
                [self.disabledVegan addObject:cell];
            }
        }
        
    }
    else if (self.brain.userVegitarian)
    {
        NSLog(@"User is just veg");
        for (Topping *topping in self.brain.toppings)
        {
            if (!topping.vegitarian)
            {
                RandomPizzaGeneratorCell *cell = [self.indexPathOfTopping objectForKey:topping.name];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                cell.userInteractionEnabled = NO;
                cell.textLabel.enabled = NO;
                [self.disabledVegan addObject:cell];
            }
        }
        
    }
}

-(void)prepareCurrentToppingsForSegue

{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (NSString *key in self.currentlySelectedToppings) {
        
        [temp addObject:[self.currentlySelectedToppings objectForKey:key]];
    }
    self.brain.toppingsPool = [temp copy];
    [self.brain saveState];
    
    
}
-(void)makeIntoDicionary
{
    for (Topping *topping in self.brain.toppingsPool) {
        [self.currentlySelectedToppings setObject:topping forKey:topping.name];
    }
}

#pragma mark commented out
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
