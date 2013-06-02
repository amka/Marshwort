//
//  MEPreferencesController.m
//  Marshwort
//
//  Created by Andrey M. on 25.03.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import "MEPreferencesController.h"

@interface MEPreferencesController ()

@end

@implementation MEPreferencesController

- (void)setupToolbar
{
    [self addView:self.generalPreferenceView label:@"General"];
    [self addView:self.updatesPreferenceView label:@"Updates"];
    
    // Optional configuration settings.
    [self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
    [self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}

+ (NSString *)nibName
{
    return @"Preferences";
}

@end
