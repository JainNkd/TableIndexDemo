//
//  SerachIndexViewController.h
//  IndexedTableDemo
//
//  Created by Naveen Kumar Dungarwal on 1/7/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SerachIndexViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    
    BOOL isFiltered;
    
    NSArray *indexTitles,*tableSectionTitles;
    
    NSMutableArray *searchData;
    NSMutableArray *tableListData;
    
    NSMutableDictionary* filteredTableData;
    UISearchDisplayController *searchDisplayController;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
