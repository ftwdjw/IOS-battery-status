/*
     File: BatStatViewController.m
 Abstract: Receives battery status change notifications. Queries the battery status and presents it in a UITableView. Enables and disables battery status updates.
  Version: 1.2
 
 
 
 */

#import "BatStatViewController.h"

@interface BatStatViewController ()

- (IBAction)switchAction:(id)sender;

@end

@implementation BatStatViewController

#pragma mark - Battery notifications

- (void)updateBatteryLevel
{
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    if (batteryLevel < 0.0) {
        // -1.0 means battery state is UIDeviceBatteryStateUnknown
        self.levelLabel.text = NSLocalizedString(@"Unknown", @"");
    }
    else {
        static NSNumberFormatter *numberFormatter = nil;
        if (numberFormatter == nil) {
            numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
            [numberFormatter setMaximumFractionDigits:1];
        }
        
        NSNumber *levelObj = [NSNumber numberWithFloat:batteryLevel];
        NSLog(@"batteryLevel=%f",batteryLevel);
        self.levelLabel.text = [numberFormatter stringFromNumber:levelObj];
    }
}

- (void)updateBatteryState
{
    NSArray *batteryStateCells = @[self.unknownCell, self.unpluggedCell, self.chargingCell, self.fullCell];
    
    UIDeviceBatteryState currentState = [UIDevice currentDevice].batteryState;
    
    NSLog(@"currentState=%ld",(long)currentState);
    
    for (int i = 0; i < [batteryStateCells count]; i++) {
        UITableViewCell *cell = (UITableViewCell *) batteryStateCells[i];
        
        if (i + UIDeviceBatteryStateUnknown == currentState) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

- (void)batteryLevelChanged:(NSNotification *)notification
{
    [self updateBatteryLevel];
}

- (void)batteryStateChanged:(NSNotification *)notification
{
    [self updateBatteryLevel];
    [self updateBatteryState];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Register for battery level and state change notifications.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(batteryLevelChanged:)
												 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(batteryStateChanged:)
												 name:UIDeviceBatteryStateDidChangeNotification object:nil];
    
    [self switchAction:self.monitorSwitch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Switch action handler

- (IBAction)switchAction:(id)sender
{
    if ([sender isOn]) {
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
		// The UI will be updated as a result of the first UIDeviceBatteryStateDidChangeNotification notification.
        // Note that enabling monitoring only triggers a UIDeviceBatteryStateDidChangeNotification;
        // a UIDeviceBatteryLevelDidChangeNotification is not sent.
    }
    else {
        [UIDevice currentDevice].batteryMonitoringEnabled = NO;
		
        [self batteryStateChanged:nil];
    }
}


@end
