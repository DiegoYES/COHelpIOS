
// RegisterHabitViewController.h

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

// Delegados para que funcionen la rueda (Picker) y el teclado (TextField)
@interface RegisterHabitViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

// --- VARIABLES DE DATOS ---
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext; // Para guardar en la BD
@property (strong, nonatomic) NSArray *habitOptions; // Lista de hábitos (Caminar, Reciclar...)

// --- CONEXIONES VISUALES (Outlets) ---
// (Estos son los que tienes que conectar con el Storyboard)
@property (weak, nonatomic) IBOutlet UIPickerView *habitPicker;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

// --- ACCIONES DE BOTONES ---
// (Estos son los que conectas con los botones "Guardar" y "Cancelar")
- (IBAction)saveButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END

