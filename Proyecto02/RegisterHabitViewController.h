

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterHabitViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *habitOptions; 

@property (weak, nonatomic) IBOutlet UIPickerView *habitPicker;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

- (IBAction)saveButtonTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END

