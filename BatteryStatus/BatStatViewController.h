/*
     File: BatStatViewController.h
 Abstract: Receives battery status change notifications. Queries the battery status and presents it in a UITableView. Enables and disables battery status updates.
  Version: 1.2
 
 
 */

#import <UIKit/UIKit.h>

@interface BatStatViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *monitorSwitch;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *unknownCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *unpluggedCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *chargingCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *fullCell;

@end
