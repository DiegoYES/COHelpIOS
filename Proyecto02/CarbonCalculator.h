

#import <Foundation/Foundation.h>
#import "T_Registros+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarbonCalculator : NSObject
+ (double)calculateCarbonSavings:(NSArray<T_Registros *> *)logs;

@end

NS_ASSUME_NONNULL_END
