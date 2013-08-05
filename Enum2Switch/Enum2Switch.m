//
//  Enum2Switch.m
//  Enum2Switch
//
//  Created by Mario Negro on 02/08/13.
//  Copyright (c) 2013 Mario Negro. All rights reserved.
//

#import "Enum2Switch.h"

@interface Enum2Switch()

- (NSString *)extractFromString:(NSString *)string
                        between:(NSString *)beginningString
                            and:(NSString *)endingString;

@end

@implementation Enum2Switch

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
    
    if (![input isKindOfClass:[NSArray class]] ||
        [input count] != 1 ||
        ![[input lastObject] isKindOfClass:[NSString class]] ||
        [(NSString *)[input lastObject] length] == 0) {
        
        return nil;
        
    } else {
        
        NSString *selection = [[(NSArray *)input lastObject] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // Get the name of the enumeration between some posibilities.
        
        NSString *enumName = [self extractFromString:selection between:@"enum" and:@":"]; // enum Name : Type {};
        
        if (!enumName) {
            
            enumName = [self extractFromString:selection between:@"enum" and:@"{"]; // enum Name {};
        }
        
        if (!enumName) {
            
            NSRange macroRange = [selection rangeOfString:@"NS_ENUM"]; // NS_ENUM(Type, Name) {};
            if (macroRange.location != NSNotFound) {
                
                enumName = [self extractFromString:selection between:@"," and:@")"];
            }
        }
        
        if (!enumName) { // enum {} Name;
            
            enumName = [self extractFromString:selection between:@"}" and:@";"];
        }
        
        // Get the values between the curly braces. Note: each value has to be in one line to be extracted.
        
        NSMutableArray *cleanedLines = [NSMutableArray array];
        NSArray *values = [[self extractFromString:selection
                                           between:@"{"
                                               and:@"}"] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        for (NSString *string in values) {
            
            NSString *cleaned = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSRange range = [cleaned rangeOfString:@"="]; // Get the string until = symbol, if present.
            if (range.location != NSNotFound) {
                
                cleaned = [cleaned substringToIndex:range.location];
            }
            
            range = [cleaned rangeOfString:@","]; // If no =, then get the string until , character.
            if (range.location != NSNotFound) {
                
                cleaned = [cleaned substringToIndex:range.location];
            }
            
            range = [cleaned rangeOfString:@"/"]; // If no = and no , because is the final value, then remove the possible comments after /
            if (range.location != NSNotFound) {
                
                cleaned = [cleaned substringToIndex:range.location];
            }
            
            if ([cleaned length] > 0) {
                
                [cleanedLines addObject:cleaned];
            }
        }
        
        // Structure construction.
        
        NSString *varString = nil;
        NSString *switchString = nil;
        if (enumName) {
            
            varString = [NSString stringWithFormat:@"%@ expression = <#value#>;\n", enumName];
            switchString = @"switch (expression) {\n\n";
            
        } else {
            
            varString = @"";
            switchString = @"switch (<#value#>) {\n\n";
        }
        
        NSMutableString *casesString = [NSMutableString stringWithString:@""];
        for (NSString *line in cleanedLines) {
            
            [casesString appendFormat:@"\tcase %@:\n\t\tbreak;\n\n", line];
        }
        
        NSString *defaultString = @"\tdefault:\n\t\tbreak;\n}";
        
        NSMutableString *final = [NSMutableString stringWithString:@""];
        [final appendString:varString];
        [final appendString:switchString];
        [final appendString:casesString];
        [final appendString:defaultString];
        
        return final;
    }
}

- (NSString *)extractFromString:(NSString *)string
                        between:(NSString *)beginningString
                            and:(NSString *)endingString {
    
    NSString *result = nil;
    
    if ([string length] > 0 &&
        [beginningString length] > 0 &&
        [endingString length] > 0) {
        
        NSRange beginningRange = [string rangeOfString:beginningString];
        NSRange endingRange = [string rangeOfString:endingString];
        
        if (beginningRange.location != NSNotFound &&
            endingRange.location != NSNotFound) {
            
            NSInteger location = beginningRange.location + beginningRange.length;
            NSInteger length = endingRange.location - location;
            
            if (length > 0) {
                
                result = [[string substringWithRange:NSMakeRange(location, length)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
        }
    }
    
    return ([result length] > 0 ? result : nil);
}

@end
