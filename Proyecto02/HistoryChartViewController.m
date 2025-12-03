

#import "HistoryChartViewController.h"
#import "CarbonCalculator.h"
#import "T_Registros+CoreDataClass.h"
#import "T_Registros+CoreDataProperties.h"
#import <CoreData/CoreData.h>

@interface HistoryChartViewController ()
@end

@implementation HistoryChartViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.webView.frame.size.width == 0 || self.webView.frame.size.height == 0) {
        NSLog(@"⚠️ ADVERTENCIA CRÍTICA: El WebView tiene tamaño 0. ¡Faltan Constraints en el Storyboard!");
    } else {
        NSLog(@"📏 WebView tamaño correcto: %.0f x %.0f", self.webView.frame.size.width, self.webView.frame.size.height);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadChartData];
    
    self.webView.navigationDelegate = self;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    
    [self loadChartHTML];
}

- (void)loadChartData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"T_Registros"];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    
    NSError *error = nil;
    NSArray<T_Registros *> *allLogs = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (allLogs.count == 0) {
        NSLog(@"⚠️ No hay datos en la BD para graficar. La gráfica saldrá vacía.");
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableDictionary<NSString *, NSNumber *> *dailySavings = [[NSMutableDictionary alloc] init];
    
    for (T_Registros *log in allLogs) {
        NSString *day = [formatter stringFromDate:log.date];
        double savings = [CarbonCalculator calculateCarbonSavings:@[log]];
        double currentSavings = [dailySavings[day] doubleValue];
        dailySavings[day] = @(currentSavings + savings);
    }
    
    NSArray *sortedDays = [dailySavings.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    
    for (NSString *day in sortedDays) {
        [data addObject:dailySavings[day]];
        [labels addObject:[day substringFromIndex:5]];
    }
    
    self.chartData = data;
    self.chartLabels = labels;
}

- (void)loadChartHTML {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"chart" withExtension:@"html"];
    if (!fileURL) {
        NSLog(@"❌ ERROR: No se encuentra chart.html");
        return;
    }
    
    // Permisos corregidos
    NSURL *readAccessURL = [fileURL URLByDeletingLastPathComponent];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:readAccessURL];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"🌐 HTML Cargado. Inyectando datos...");
    
    NSData *labelsJSON = [NSJSONSerialization dataWithJSONObject:self.chartLabels options:0 error:nil];
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:self.chartData options:0 error:nil];
    
    NSString *labelsStr = [[NSString alloc] initWithData:labelsJSON encoding:NSUTF8StringEncoding];
    NSString *dataStr = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    NSString *jsCall = [NSString stringWithFormat:@"drawChart(%@, %@);", labelsStr, dataStr];
    
    [self.webView evaluateJavaScript:jsCall completionHandler:^(id result, NSError *error) {
        if (error) NSLog(@"❌ Error JS: %@", error);
        else NSLog(@"✅ Gráfica dibujada.");
    }];
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
