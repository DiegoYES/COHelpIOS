
#import "RegisterHabitViewController.h"
#import "T_Registros+CoreDataClass.h"

@interface RegisterHabitViewController ()
@end

@implementation RegisterHabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.habitOptions = @[@"caminar", @"reciclar", @"electricidad", @"auto"];
    
    self.habitPicker.delegate = self;
    self.habitPicker.dataSource = self;
    self.amountTextField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
 
    if (self.amountTextField == nil) NSLog(@"❌ ERROR FATAL: El TextField no está conectado en el Storyboard.");
    if (self.habitPicker == nil) NSLog(@"❌ ERROR FATAL: El Picker no está conectado en el Storyboard.");
    if (self.managedObjectContext == nil) NSLog(@"❌ ERROR FATAL: El Contexto de Base de Datos llegó vacío.");
}

- (void)dismissKeyboard {
    [self.amountTextField resignFirstResponder];
}

- (IBAction)saveButtonTapped:(id)sender {
    NSLog(@"👇 Se presionó Guardar");

    if (!self.habitPicker || !self.amountTextField) {
        [self mostrarAlertaError:@"Error Visual" mensaje:@"Los elementos de la pantalla no están conectados al código."];
        return;
    }

    NSInteger selectedRow = [self.habitPicker selectedRowInComponent:0];
    NSString *habitType = self.habitOptions[selectedRow];
    NSString *textAmount = self.amountTextField.text;
    double amount = [textAmount doubleValue];
    
    NSLog(@"📝 Intentando guardar: Hábito=%@, CantidadTexto='%@', Valor=%.2f", habitType, textAmount, amount);

    if (textAmount.length == 0 || amount <= 0) {
        [self mostrarAlertaError:@"Cantidad Inválida" mensaje:@"Por favor escribe una cantidad mayor a 0."];
        return;
    }

    if (!self.managedObjectContext) {
        [self mostrarAlertaError:@"Error BD" mensaje:@"No hay conexión con la base de datos."];
        return;
    }

    T_Registros *newLog = [NSEntityDescription insertNewObjectForEntityForName:@"T_Registros"
                                                        inManagedObjectContext:self.managedObjectContext];
    newLog.habitLog = habitType;
    newLog.amount = amount;
    newLog.date = [NSDate date];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"❌ Error Core Data: %@", error.localizedDescription);
        [self mostrarAlertaError:@"Error al Guardar" mensaje:error.localizedDescription];
    } else {
        NSLog(@"✅ ¡Guardado Exitoso!");
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)mostrarAlertaError:(NSString *)titulo mensaje:(NSString *)mensaje {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titulo message:mensaje preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { return self.habitOptions.count; }

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { return self.habitOptions[row]; }

- (BOOL)textFieldShouldReturn:(UITextField *)textField { [textField resignFirstResponder]; return YES; }

@end
