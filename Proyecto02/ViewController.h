//
//  ViewController.h
//  Proyecto02
//
//  Created by MacBook Pro on 29/11/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "T_Registros+CoreDataClass.h" // Importamos tu modelo de base de datos

// Implementamos los protocolos de la lista (UITableView)
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// --- ETIQUETAS DE DATOS (Outlets) ---
@property (weak, nonatomic) IBOutlet UILabel *totalProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *weeklyProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailyProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengeLabel;

// --- LA LISTA (TABLA) ---
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

// --- VARIABLES DE DATOS (Internas) ---
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray<T_Registros *> *historyLogs;

// --- DECLARACIÓN DE MÉTODOS INTERNOS (¡AGREGADO!) ---
- (void)loadDashboardData;
- (double)fetchCarbonDataForPeriod:(NSString *)period;
- (void)fetchAllHistory;
- (void)loadWeeklyChallenge;
- (void)scheduleNotificationTest;

- (IBAction)refreshButtonTapped:(id)sender;

// --- ACCIONES DE LOS BOTONES DEL MENÚ ---
- (IBAction)registerHabitTapped:(id)sender;
- (IBAction)showHistoryChartTapped:(id)sender;

@end
