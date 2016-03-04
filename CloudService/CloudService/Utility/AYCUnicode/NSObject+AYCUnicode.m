//
//  NSObject+AYCUnicode.m
//  NSArrayAndNSDic
//
//  Created by 安永超 on 15/11/25.
//  Copyright © 2015年 安永超. All rights reserved.
//

#import "NSObject+AYCUnicode.h"

@implementation NSObject (AYCUnicode)
+ (NSString *)stringByReplaceUnicode:(NSString *)string
{
    NSMutableString *convertedString = [string mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    return convertedString;
}
@end
