   
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "T_Registros+CoreDataClass.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//outlets
@property (weak, nonatomic) IBOutlet UILabel *totalProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *weeklyProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengeLabel;

// tabla
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray<T_Registros *> *historyLogs;

// metodos
- (void)loadDashboardData;
- (double)fetchCarbonDataForPeriod:(NSString *)period;
- (void)fetchAllHistory;
- (void)loadWeeklyChallenge;
- (void)scheduleNotificationTest;

- (IBAction)refreshButtonTapped:(id)sender;
//botones
- (IBAction)registerHabitTapped:(id)sender;
- (IBAction)showHistoryChartTapped:(id)sender;

@end
