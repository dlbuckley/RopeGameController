//
//  SPPlayersViewController.m
//  RopeGameController
//
//  Created by Valerio Mazzeo on 19/09/13.
//  Copyright (c) 2013 NSSpain. All rights reserved.
//

#import "SPPlayersViewController.h"
#import "SPPlayerCell.h"

@interface SPPlayersViewController ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *players;
@property (nonatomic, strong, readwrite) NSMutableArray *playersOrder;

@end

@implementation SPPlayersViewController

- (NSDictionary *)players
{
    if (!_players) {
        _players = [NSMutableDictionary new];
    }
    return _players;
}

- (NSMutableArray *)playersOrder
{
    if (!_playersOrder) {
        _playersOrder = [NSMutableArray new];
    }
    return _playersOrder;
}

- (BOOL)addPlayer:(SPPlayer *)player
{
    if (![self.players objectForKey:player.identifier]) {
        [self.players setValue:player forKey:player.identifier];
        [self.playersOrder addObject:player];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.playersOrder.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
        
        return TRUE;
    } else {
        return FALSE;
    }
}

- (SPPlayer*)playerForID:(NSString*)identifier
{
    return [self.players objectForKey:identifier];
}

- (BOOL)removePlayer:(SPPlayer *)player
{
    if (player) {
    
        if ([self.players objectForKey:player.identifier]) {
            
            NSInteger index = [self.playersOrder indexOfObject:player];
            
            [self.players removeObjectForKey:player.identifier];
            [self.playersOrder removeObject:player];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            });
            
            return TRUE;
            
        } else {
            return FALSE;
        }
    } else {
        return FALSE;
    }
}

- (BOOL)removePlayerWithID:(NSString *)identifier
{
    return [self removePlayer:[self.players objectForKey:identifier]];
}

- (BOOL)doesTeamContainPlayerWithPeerID:(MCPeerID*)peerID
{
    for (SPPlayer *player in self.players) {
        if (player.peerID == peerID) {
            return TRUE;
        }
    }
    
    return FALSE;
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

    [self.tableView registerClass:[SPPlayerCell class] forCellReuseIdentifier:@"PlayerCell"];
    self.tableView.allowsSelection = FALSE;
    
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayerCell";
    SPPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SPPlayerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell configureWithPlayer:self.playersOrder[indexPath.row]];
    
    return cell;
}

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
