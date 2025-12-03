//
//  ViewController.m
//  Proyecto02
//
//  Created by MacBook Pro on 29/11/25.
//

#import "ViewController.h"
#import "AppDelegate.h" // Para acceder a la BD
#import "CarbonCalculator.h" // Para los cálculos
#import "RegisterHabitViewController.h" // Para abrir la pantalla de registro
#import "HistoryChartViewController.h" // Para abrir la pantalla de gráfica
#import <UserNotifications/UserNotifications.h> // Para la notificación
// Importamos las propiedades para que reconozca .habitLog
#import "T_Registros+CoreDataProperties.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. Obtener el contexto de la Base de Datos
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.persistentContainer.viewContext;
    
    // 2. Configurar la tabla para que este archivo la controle
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    
    // 3. Cargar desafío y programar notificación
    [self loadWeeklyChallenge];
    [self scheduleNotificationTest];
}

// ESTA ES LA FUNCIÓN CLAVE PARA QUE LA TABLA SE ACTUALICE SOLA
// Se ejecuta cada vez que la pantalla "vuelve a aparecer" (cuando cierras el registro)
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Forzamos a recargar los datos
    [self loadDashboardData];
}

// --- CÁLCULOS Y DATOS ---

- (void)loadDashboardData {
    // Usamos un hilo secundario para no trabar la app
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Calculamos los 3 valores
        double daily = [self fetchCarbonDataForPeriod:@"daily"];
        double weekly = [self fetchCarbonDataForPeriod:@"weekly"];
        double total = [self fetchCarbonDataForPeriod:@"total"];
        
        // Cargamos la lista del historial
        [self fetchAllHistory];
        
        // Volvemos al hilo principal para pintar en pantalla
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dailyProgressLabel.text = [NSString stringWithFormat:@"%.2f kg", daily];
            self.weeklyProgressLabel.text = [NSString stringWithFormat:@"%.2f kg", weekly];
            self.totalProgressLabel.text = [NSString stringWithFormat:@"%.2f kg CO2", total];

            // Colores: Verde si es <= 0, Rojo si es > 0
            self.dailyProgressLabel.textColor = (daily <= 0) ? [UIColor systemGreenColor] : [UIColor systemRedColor];
            self.weeklyProgressLabel.textColor = (weekly <= 0) ? [UIColor systemGreenColor] : [UIColor systemRedColor];
            self.totalProgressLabel.textColor = (total <= 0) ? [UIColor systemGreenColor] : [UIColor systemRedColor];
            
            // Recargar la tabla con los nuevos datos
            [self.historyTableView reloadData];
        });
    });
}

// Función auxiliar para consultar la BD con filtros
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
    
    // Usamos nuestra calculadora
    return [CarbonCalculator calculateCarbonSavings:results];
}

- (void)fetchAllHistory {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"T_Registros"];
    // Ordenar del más nuevo al más viejo
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
    
    // Usar .count en lugar de .length
    self.challengeLabel.text = challenges[weekOfYear % challenges.count];
}

// --- ACCIONES DE BOTONES (CORREGIDAS PARA PASAR LA LLAVE) ---

- (IBAction)registerHabitTapped:(id)sender {
    // 1. Abrir pantalla de registro
    RegisterHabitViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
    
    // 2. ¡AQUÍ ESTÁ LA SOLUCIÓN DEL ERROR! Le pasamos la base de datos
    vc.managedObjectContext = self.managedObjectContext;
    
    // 3. Abrir
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)showHistoryChartTapped:(id)sender {
    // 1. Abrir pantalla de gráfica
    HistoryChartViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChartVC"];
    
    // 2. Le pasamos la base de datos
    vc.managedObjectContext = self.managedObjectContext;
    
    // 3. Abrir
    [self presentViewController:vc animated:YES completion:nil];
}

// --- NOTIFICACIONES ---

- (IBAction)refreshButtonTapped:(id)sender {
    NSLog(@"Botón Actualizar presionado. Recargando datos...");
        
        // Llamamos a la misma función que carga todo
        [self loadDashboardData];
        
        // (Opcional) Mostramos una alerta rápida para confirmar
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
    
    // Alerta en 60 segundos
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"test" content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

// --- CONFIGURACIÓN DE LA TABLA (DataSource) ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Usamos la celda "HistoryCell" que configuraste en el Storyboard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    T_Registros *log = self.historyLogs[indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // Usamos .habitLog (el nombre correcto en tu BD)
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%.1f)", log.habitLog, log.amount];
    cell.detailTextLabel.text = [formatter stringFromDate:log.date];
    
    return cell;
}

@end
