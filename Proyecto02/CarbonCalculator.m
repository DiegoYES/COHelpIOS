//
//  CarbonCalculator.m
//

#import "CarbonCalculator.h"
// 1. Importamos las "Properties" para que Xcode vea habitLog, amount, etc.
#import "T_Registros+CoreDataProperties.h"

// --- FACTORES DE EMISIÓN ---
// Negativo = Ahorro (Verde)
// Positivo = Gasto (Rojo)
#define FACTOR_CAMINAR      -0.21
#define FACTOR_RECICLAR     -0.05
#define FACTOR_ELECTRICIDAD -0.4
#define FACTOR_AUTO          0.07

@implementation CarbonCalculator

+ (double)calculateCarbonSavings:(NSArray<T_Registros *> *)logs {
    double totalSavings = 0.0;
    
    // Recorremos cada registro de la lista
    for (T_Registros *log in logs) {
        
        // CORRECCIÓN: Usamos 'habitLog' en lugar de 'habitType'
        // porque así se llama en tu archivo T_Registros+CoreDataProperties.h
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
