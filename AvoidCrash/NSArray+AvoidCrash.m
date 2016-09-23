//
//  NSArray+AvoidCrash.m
//  AvoidCrash
//
//  Created by mac on 16/9/21.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "NSArray+AvoidCrash.h"

#import "AvoidCrash.h"

@implementation NSArray (AvoidCrash)

+ (void)load {
    
    
#ifdef AVOIDCRASH
    
    if (YES == AVOIDCRASH) {
        
        //instance array method exchange
        Method arrayWithObjects = class_getClassMethod(self, @selector(arrayWithObjects:count:));
        Method avoidCrashArrayWithObjects = class_getClassMethod(self, @selector(AvoidCrashArrayWithObjects:count:));
        method_exchangeImplementations(arrayWithObjects, avoidCrashArrayWithObjects);
        
        Class arrayIClass = NSClassFromString(@"__NSArrayI");
        
        //get object from array method exchange
        Method objectAtIndex = class_getInstanceMethod(arrayIClass, @selector(objectAtIndex:));
        Method avoidCrashObjectAtIndex = class_getInstanceMethod(arrayIClass, @selector(avoidCrashObjectAtIndex:));
        method_exchangeImplementations(objectAtIndex, avoidCrashObjectAtIndex);
    }
    
#endif
}


//=================================================================
//                        instance array
//=================================================================
#pragma mark - instance array


+ (instancetype)AvoidCrashArrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        instance = [self AvoidCrashArrayWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        
        NSString *defaultToDo = @"This framework default is to remove nil object and instance a array.";
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
        
        //以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self AvoidCrashArrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}



//=================================================================
//                   get object from array
//=================================================================
#pragma mark - get object from array

- (id)avoidCrashObjectAtIndex:(NSUInteger)index {
    
    id object = nil;
    
    @try {
        object = [self avoidCrashObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        
        NSString *defaultToDo = @"This framework default is to return nil.";
        [AvoidCrash noteErrorWithException:exception defaultToDo:defaultToDo];
    }
    @finally {
        return object;
    }
}



@end
