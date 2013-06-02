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
    [self addView:self.generalPreferenceView label:NSLocalizedString(@"GENERAL_TOOLBAR_TITLE", "General view title") image:[NSImage imageNamed:@"General.png"]];
    [self addView:self.updatesPreferenceView label:NSLocalizedString(@"UPDATE_TOOLBAR_TITLE", "Updates view title") image:[NSImage imageNamed:@"Updates.tiff"]];
    
    // Optional configuration settings.
    [self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
    [self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}

+ (NSString *)nibName
{
    return @"PreferenesWindow";
}

@end
