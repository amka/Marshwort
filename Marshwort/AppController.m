//
//  AppController.m
//  Marshwort
//
//  Created by Andrey M. on 25.03.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import "AppController.h"
#import "MEPreferencesController.h"

@implementation AppController

- (IBAction)openPreferences:(id)sender
{
    [[MEPreferencesController sharedPrefsWindowController] showWindow:nil];
}

@end
