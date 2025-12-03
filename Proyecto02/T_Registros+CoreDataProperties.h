//
//  T_Registros+CoreDataProperties.h
//  Proyecto02
//
//  Created by MacBook Pro on 17/11/25.
//
//

#import "T_Registros+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface T_Registros (CoreDataProperties)

+ (NSFetchRequest<T_Registros *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *habitLog;
@property (nonatomic) double amount;
@property (nullable, nonatomic, copy) NSDate *date;

@end

NS_ASSUME_NONNULL_END
