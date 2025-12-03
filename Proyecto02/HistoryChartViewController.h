//
//  HistoryChartViewController.h
//  Proyecto02
//
//  Created by MacBook Pro on 28/11/25.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h> // Para la base de datos
#import <WebKit/WebKit.h>     // ¡IMPORTANTE! Para que funcione la gráfica web
#import "T_Registros+CoreDataClass.h" // Tu modelo de datos

NS_ASSUME_NONNULL_BEGIN

// Agregamos <WKNavigationDelegate> para controlar la carga de la página
@interface HistoryChartViewController : UIViewController <WKNavigationDelegate>

// --- CONEXIÓN VISUAL ---
// Esta es la variable que tienes que conectar con el cuadro blanco en el Storyboard
@property (weak, nonatomic) IBOutlet WKWebView *webView;

// --- DATOS ---
// El manejador de la base de datos (se lo pasa la pantalla anterior)
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// Variables para guardar los datos antes de dibujarlos
@property (strong, nonatomic) NSArray *chartData;
@property (strong, nonatomic) NSArray<NSString *> *chartLabels;

// --- ACCIONES ---
- (IBAction)closeButtonTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
