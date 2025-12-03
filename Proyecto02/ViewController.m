
#import "ViewController.h"
#import "AppDelegate.h"
#import "CarbonCalculator.h"
#import "RegisterHabitViewController.h"
#import "HistoryChartViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "T_Registros+CoreDataProperties.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.persistentContainer.viewContext;
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;

    [self loadWeeklyChallenge];
    [self scheduleNotificationTest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Forzamos a recargar los datos
    [self loadDashboardData];
}


- (void)loadDashboardData {
    // Usamos un hilo secundario para no trabar la app
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double daily = [self fetchCarbonDataForPeriod:@"daily"];
        double weekly = [self fetchCarbonDataForPeriod:@"weekly"];
        double total = [self fetchCarbonDataForPeriod:@"total"];
        
        [self fetchAllHistory];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dailyProgressLabel.text = [NSString stringWithFormat:@"%.2f kg", daily];
            self.weeklyProgressLabel.text = [NSString stringWithFormat:@"%.2f kg", weekly];
            self.totalProgressLabel.text = [NSString stringWithFormat:@"%.2f kg CO2", total];

            
            self.dailyProgressLabel.textColor = (daily <= 0) ? [UIColor systemGreenColor] : [UIColor systemRedColor];
            self.weeklyProgressLabel.textColor = (weekly <= 0) ? [UIColor systemGreenColor] : [UIColor systemRedColor];
            self.totalProgressLabel.textColor = (total <= 0) ? [UIColor systemGreenColor] : [UIColor systemRedColor];
            [self.historyTableView reloadData];
        });
    });
}


- (double)fetchCarbonDataForPeriod:(NSString *)period {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"T_Registros"];
    NSPredicate *predicate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];

    if ([period isEqualToString:@"daily"]) {
        NSDate *startDate = [calendar startOfDayForDate:now];
        predicate = [NSPredicate predicateWithFormat:@"date >= %@", startDate];
    } else if ([period isEqualToString:@"weekly"]) {
        NSDateComponents *components = [calendar components:NSCalendarUnitYearForWeekOfYear | NSCalendarUnitWeekOfYear fromDate:now];
        NSDate *startDate = [calendar dateFromComponents:components];
        predicate = [NSPredicate predicateWithFormat:@"date >= %@", startDate];
    }
    if (predicate) {
        [request setPredicate:predicate];
    }
    NSError *error = nil;
    NSArray<T_Registros *> *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) return 0.0;
    return [CarbonCalculator calculateCarbonSavings:results];
}

- (void)fetchAllHistory {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"T_Registros"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:@[sort]];
    NSError *error = nil;
    self.historyLogs = [self.managedObjectContext executeFetchRequest:request error:&error];
}
- (void)loadWeeklyChallenge {
    NSArray *challenges = @[
        @"Evita el uso de plásticos por 3 días",
        @"Separa tus residuos orgánicos e inorgánicos",
        @"Desconecta aparatos electrónicos que no uses"
    ];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
    NSInteger weekOfYear = components.weekOfYear;

    self.challengeLabel.text = challenges[weekOfYear % challenges.count];
}


- (IBAction)registerHabitTapped:(id)sender {
    
    RegisterHabitViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    vc.managedObjectContext = self.managedObjectContext;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)showHistoryChartTapped:(id)sender {
    
    HistoryChartViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChartVC"];
    vc.managedObjectContext = self.managedObjectContext;
    
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)refreshButtonTapped:(id)sender {
    NSLog(@"Botón Actualizar presionado. Recargando datos...");
        [self loadDashboardData];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Actualizado"
                                                                       message:@"Los datos se han refrescado."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }

- (void)scheduleNotificationTest {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Recordatorio Sostenible";
    content.body = @"¡No olvides registrar tus hábitos ecológicos de hoy!";
    content.sound = [UNNotificationSound defaultSound];
    
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"test" content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    T_Registros *log = self.historyLogs[indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%.1f)", log.habitLog, log.amount];
    cell.detailTextLabel.text = [formatter stringFromDate:log.date];
    
    return cell;
}

@end
