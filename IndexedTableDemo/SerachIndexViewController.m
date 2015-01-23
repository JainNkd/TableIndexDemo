//
//  SerachIndexViewController.m
//  IndexedTableDemo
//
//  Created by Naveen Kumar Dungarwal on 1/7/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "SerachIndexViewController.h"
#import "Animal.h"

@interface SerachIndexViewController ()

@end

@implementation SerachIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableviewInitialisation];
    [self initializeData];
    [self createSearchBar];
}

-(void)initializeData
{
    NSArray *animals = @[@"Bear", @"Black Swan", @"Buffalo", @"Cambel", @"Cockatoo", @"Dog", @"Donkey", @"Emu", @"Giraffe", @"Greater Rhea", @"Hippopotamus", @"Horse", @"Koala", @"Lion", @"Llama", @"Manatus", @"Meerkat", @"Panda", @"Peacock", @"Pig", @"Platypus", @"Polar Bear", @"Rhinoceros", @"Seagull", @"Tasmania Devil", @"Whale", @"Whale Shark", @"Wombat"];
    
    [tableListData removeAllObjects];
    tableListData = nil;
    tableListData = [[NSMutableArray alloc]init];
    for(NSString *name in animals)
    {
        Animal *animalObj = [[Animal alloc]init];
        animalObj.name = name;
        [tableListData addObject:animalObj];
    }
    
    [self updateTableData:@""];
}

//- (void)layoutSubviews {
//    UITextField *searchField;
//    NSUInteger numViews = [self.view.subviews count];
//    for(int i = 0; i < numViews; i++) {
//        if([[self.view.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
//            searchField = [self.view.subviews objectAtIndex:i];
//        }
//    }
//    if(!(searchField == nil)) {
//        searchField.textColor = [UIColor whiteColor];
//        [searchField setBackground: [UIImage imageNamed:@"video-send-search-bg@2x.png"] ];
//        [searchField setBorderStyle:UITextBorderStyleNone];
//    }
//    
//    [super.view layoutSubviews];
//}

-(void)updateTableData:(NSString*)searchString
{
    filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (Animal *animalObj in tableListData)
    {
        bool isMatch = false;
        if(searchString.length == 0)
        {
            // If our search string is empty, everything is a match
            isMatch = true;
        }
        else
        {
            // If we have a search string, check to see if it matches the food's name or description
            NSRange nameRange = [animalObj.name rangeOfString:searchString options:(NSAnchoredSearch|NSCaseInsensitiveSearch)];
            NSLog(@"This is it: %@",animalObj.name);
            
            if(nameRange.location != NSNotFound)
                isMatch = true;
        }
        
        
        // If we have a match...
        if(isMatch)
        {
            // Find the first letter of the food's name. This will be its gropu
            NSString* firstLetter = [animalObj.name substringToIndex:1];
            
            NSLog(@"This is it: %@",firstLetter);
            
            // Check to see if we already have an array for this group
            NSMutableArray* arrayForLetter = (NSMutableArray*)[filteredTableData objectForKey:firstLetter];
            if(arrayForLetter == nil)
            {
                // If we don't, create one, and add it to our dictionary
                arrayForLetter = [[NSMutableArray alloc] init];
                [filteredTableData setValue:arrayForLetter forKey:firstLetter];
                NSLog(@"This is it: %@",filteredTableData);
            }
            
            // Finally, add the food to this group's array
            [arrayForLetter addObject:animalObj];
        }
    }
    
    // Make a copy of our dictionary's keys, and sort them
    tableSectionTitles = [[filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Finally, refresh the table
    [self.tableView reloadData];
}


//Show index bar at right side
-(void)tableviewInitialisation
{
    indexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    //To change index bar color
    self.tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.separatorColor=[UIColor clearColor];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
}



//Uitableview delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tableSectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* letter = [tableSectionTitles objectAtIndex:section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    NSLog(@"%@",letter);
    return arrayForLetter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObj cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableViewObj dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString* letter = [tableSectionTitles objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    Animal *animalObj = (Animal*)[arrayForLetter objectAtIndex:indexPath.row];
    cell.textLabel.text = animalObj.name;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    
    NSString* letter = [tableSectionTitles objectAtIndex:indexPath.section];
    NSArray* arrayForLetter = (NSArray*)[filteredTableData objectForKey:letter];
    Animal *animalObj = (Animal*)[arrayForLetter objectAtIndex:indexPath.row];
    
    [[[UIAlertView alloc]initWithTitle:@"LUK" message:[NSString stringWithFormat:@"Selected Animal is %@",animalObj.name] delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil] show];
}


//For showing side index bar
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [tableSectionTitles indexOfObject:title];
}

//Show headders
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
//Setting Header background color in TableView
- (UIView *)tableView:(UITableView *)tableViewobj viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 24)];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,2,200, 20)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font=[UIFont boldSystemFontOfSize:14.0f];
    label.text=[tableSectionTitles objectAtIndex:section];
    [headerView addSubview:label];
    return headerView;
}

//Setting Title Index for searchDisplayController
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [tableSectionTitles objectAtIndex:section];
}


//Search Bar delgate methods

//add search bar
-(void)createSearchBar
{
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"video-send-search-bg@2x.png"]forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"video-send-search-bg@2x.png"] forSearchBarIcon:(UISearchBarIconSearch) state:UIControlStateNormal];

//    [[UISearchBar appearance] setPositionAdjustment:UIOffsetMake(-10, 0) forSearchBarIcon:UISearchBarIconSearch];
    
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftViewMode:UITextFieldViewModeNever];
    
    self.searchBar.showsCancelButton = YES;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    searchDisplayController.searchBar.delegate =self;
    searchDisplayController.searchResultsDataSource =self;
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    searchDisplayController.searchResultsTableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchResultsTableView.bounces=NO;
    self.searchDisplayController.searchResultsTableView.separatorColor=[UIColor lightGrayColor];
    [self.searchDisplayController.searchResultsTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

}

//Search Delegate methods
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //When the user taps the search bar, this means that the controller will begin searching.
    isFiltered = YES;
    self.navigationController.navigationBarHidden = YES;
    //    [searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)bsearchBar {
    //    [searchBar resignFirstResponder];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    //When the user taps the Cancel Button, or anywhere aside from the view.
    isFiltered = NO;
//    self.searchBar.hidden=YES;
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self updateTableData:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)asearchBar
{
    [self.tableView resignFirstResponder];
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.navigationController.navigationBarHidden = NO;
    [self.searchBar resignFirstResponder];
    [self updateTableData:@""];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
