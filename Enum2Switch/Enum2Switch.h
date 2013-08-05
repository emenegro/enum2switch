//
//  Enum2Switch.h
//  Enum2Switch
//
//  Created by Mario Negro on 02/08/13.
//  Copyright (c) 2013 Mario Negro. All rights reserved.
//

#import <Automator/AMBundleAction.h>

@interface Enum2Switch : AMBundleAction

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
