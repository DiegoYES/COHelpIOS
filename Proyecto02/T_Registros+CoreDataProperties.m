//
//  T_Registros+CoreDataProperties.m
//  Proyecto02
//
//  Created by MacBook Pro on 17/11/25.
//
//

#import "T_Registros+CoreDataProperties.h"

@implementation T_Registros (CoreDataProperties)

+ (NSFetchRequest<T_Registros *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"T_Registros"];
}

@dynamic habitLog;
@dynamic amount;
@dynamic date;

@end
