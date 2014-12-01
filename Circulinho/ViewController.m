//
//  ViewController.m
//  Circulinho
//
//  Created by Kekanto on 11/24/14.
//  Copyright (c) 2014 Kekanto. All rights reserved.
//

#import "ViewController.h"

#import "CirculinhoView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, CirculinhoDelegate>

@property (strong, nonatomic) CirculinhoView *viewLoading;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableData = @[@"Bananas", @"Melancias", @"Goiabas", @"Maracujás", @"Limões", @"Mangas",
                       @"Cajus", @"Laranjas", @"Graviolas", @"Melões", @"Abacates", @"Pêras",
                       @"Jaboticabas", @"Uvas", @"Kiwis", @"Pitombas", @"Mamões"];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:self.tableView];
    
    NSDictionary *viewsDict = @{@"tableView": self.tableView};
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
                                             options:0
                                             metrics:nil
                                               views:viewsDict]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
                                             options:0
                                             metrics:nil
                                               views:viewsDict]];
    
    self.viewLoading = [[CirculinhoView alloc] initWithFrame:CGRectMake(140.0f, 74.0f, 40.0f, 40.0f)];
    self.viewLoading.delegate = self;
    
    [self.view addSubview:self.viewLoading];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewLoading startAnimatingWithScrollView:self.tableView];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.viewLoading stopAnimatingWithScrollView:self.tableView];
    });
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CirculinhoDelegate

- (void)circulinhoDidTriggerReload:(CirculinhoView *)circulinho {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableData = [[self.tableData reverseObjectEnumerator] allObjects];
        [self.tableView reloadData];
        [self.viewLoading stopAnimatingWithScrollView:self.tableView];
    });
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.tableData[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.viewLoading scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self.viewLoading scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
