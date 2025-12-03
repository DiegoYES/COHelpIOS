

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <WebKit/WebKit.h>
#import "T_Registros+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryChartViewController : UIViewController <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *chartData;
@property (strong, nonatomic) NSArray<NSString *> *chartLabels;

- (IBAction)closeButtonTapped:(id)sender;

@end

NS_ASSUME_NONNULL_END
