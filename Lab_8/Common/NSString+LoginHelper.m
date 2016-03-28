#import "NSString+LoginHelper.h"

@implementation NSString (LoginHelper)

+ (BOOL)isValidLogin:(NSString *)login
{
    NSString *loginRegex = @"([a-zA-Z0-9]){1}[a-zA-Z0-9-]{0,63}";
    NSPredicate *loginPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", loginRegex];
    return [loginPredicate evaluateWithObject:login];
}

@end
