
#import "CarbonCalculator.h"
#import "T_Registros+CoreDataProperties.h"
#define FACTOR_CAMINAR      -0.21
#define FACTOR_RECICLAR     -0.05
#define FACTOR_ELECTRICIDAD -0.4
#define FACTOR_AUTO          0.07

@implementation CarbonCalculator

+ (double)calculateCarbonSavings:(NSArray<T_Registros *> *)logs {
    double totalSavings = 0.0;
    
    for (T_Registros *log in logs) {

        if ([log.habitLog isEqualToString:@"caminar"]) {
            totalSavings += log.amount * FACTOR_CAMINAR;
        }
        else if ([log.habitLog isEqualToString:@"reciclar"]) {
            totalSavings += log.amount * FACTOR_RECICLAR;
        }
        else if ([log.habitLog isEqualToString:@"electricidad"]) {
            totalSavings += log.amount * FACTOR_ELECTRICIDAD;
        }
        else if ([log.habitLog isEqualToString:@"auto"]) {
            totalSavings += log.amount * FACTOR_AUTO;
        }
    }
    
    return totalSavings;
}

@end
