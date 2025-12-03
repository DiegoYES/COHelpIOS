//
//  CarbonCalculator.h
//  Lógica para calcular la huella de carbono
//

#import <Foundation/Foundation.h>
#import "T_Registros+CoreDataClass.h" // Importamos tu modelo de datos

NS_ASSUME_NONNULL_BEGIN

@interface CarbonCalculator : NSObject

// Este método recibe una lista de registros y devuelve la suma total de CO2
+ (double)calculateCarbonSavings:(NSArray<T_Registros *> *)logs;

@end

NS_ASSUME_NONNULL_END
