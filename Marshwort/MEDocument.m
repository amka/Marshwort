//
//  MEDocument.m
//  Marshwort
//
//  Created by Andrey M. on 23.03.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import "MEDocument.h"
#import "MELanguage.h"
#import "AFJSONRequestOperation.h"


NSString *const kAPIKey = @"trnsl.1.1.20130706T161814Z.815aff234691d9d7.58b3aa2b66ba86bbe1130f5194fa77de72c3bf10";
NSString *const kAPITranslate = @"https://translate.yandex.net/api/v1.5/tr.json/translate";

@implementation MEDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        MELanguage *english = [[MELanguage alloc] init];
        english.code = @"en";
        english.name = NSLocalizedString(@"ENGLISH_TITLE", "English title");
        english.flag = [NSImage imageNamed:@"en.icns"];
        
        MELanguage *russian = [[MELanguage alloc] init];
        russian.code = @"ru";
        russian.name = NSLocalizedString(@"RUSSIAN_TITLE", "Russian title");
        russian.flag = [NSImage imageNamed:@"ru.icns"];
        
        MELanguage *italian = [[MELanguage alloc] init];
        italian.code = @"it";
        italian.name = NSLocalizedString(@"ITALIAN_TITLE", "Italian title");
        italian.flag = [NSImage imageNamed:@"it.png"];
        
        MELanguage *ukranian = [[MELanguage alloc] init];
        ukranian.code = @"uk";
        ukranian.name = NSLocalizedString(@"UKRAINIAN_TITLE", "Ukrainian title");
        ukranian.flag = [NSImage imageNamed:@"uk"];
        
        MELanguage *turkey = [[MELanguage alloc] init];
        turkey.code = @"tr";
        turkey.name = NSLocalizedString(@"TURKEY_TITLE", "Turkey title");
        turkey.flag = [NSImage imageNamed:@"tr.png"];
        
        MELanguage *german = [[MELanguage alloc] init];
        german.code = @"de";
        german.name = NSLocalizedString(@"GERMAN_TITLE", "German title");
        german.flag = [NSImage imageNamed:@"de.png"];
        
        MELanguage *polish = [[MELanguage alloc] init];
        polish.code = @"pl";
        polish.name = NSLocalizedString(@"POLISH_TITLE", "Polish title");
        polish.flag = [NSImage imageNamed:@"pl.png"];
        
        languagesFrom = [NSMutableArray arrayWithObjects:english, italian, german, polish, russian, turkey, ukranian, nil];
        languagesTo = [NSMutableArray arrayWithObjects:english, italian, german, polish, russian, turkey, ukranian, nil];
        
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MEDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (void)awakeFromNib {
    [_langsToArrayController setSelectionIndex:[userDefaults integerForKey:@"defaultTargetLanguage"]];
    [_langsFromArrayController setSelectionIndex:[userDefaults integerForKey:@"defaultSourceLanguage"]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
    NSMutableDictionary *attrs = [NSDictionary dictionaryWithObject:NSPlainTextDocumentType
                                                            forKey:NSDocumentTypeDocumentAttribute];
    NSData *data = [[_sourceTextView textStorage] dataFromRange:NSMakeRange(0, sourceText.length)
                              documentAttributes:attrs
                                           error:nil];
    if (!data && outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain
                                        code:NSFileWriteUnknownError userInfo:nil];
    }
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    sourceText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    [self beginTranslateTimer];
    return YES;
}

- (IBAction)reverseLanguages:(id)sender {
    NSUInteger indexFrom = [_langsFromArrayController selectionIndex];
    NSUInteger indexTo = [_langsToArrayController selectionIndex];
    [_langsFromArrayController setSelectionIndex:indexTo];
    [_langsToArrayController setSelectionIndex:indexFrom];
    [self beginTranslateTimer];
}

- (IBAction)changeLanguage:(id)sender {
    [self beginTranslateTimer];
}

- (void)translate:(NSString *)text fromLanguage:(NSString *)from toLanguage:(NSString *)to withFormat:(NSString *)format
{
    NSURL *url = [NSURL URLWithString:kAPITranslate];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"key=%@&lang=%@-%@&text=%@", kAPIKey, from, to, text];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[JSON objectForKey:@"text"] objectAtIndex:0]) {
            [_translatedTextView setString:[[JSON objectForKey:@"text"] objectAtIndex:0]];
        }
        
    } failure:nil];
    
    [operation start];
}

- (void)beginTranslateTimer
{
    if ([[_sourceTextView string] length] == 0)
        return;
    
    if (!translateTimer)
        translateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                          target:self
                                                        selector:@selector(beginTranslate:)
                                                        userInfo:nil
                                                         repeats:NO];
    [_inworkIndicator startAnimation:self];
}


- (IBAction)beginTranslate:(id)sender
{
    [_inworkIndicator stopAnimation:self];
    translateTimer = nil;
    MELanguage *langFrom = [languagesFrom objectAtIndex:[_langsFromArrayController selectionIndex]];
    MELanguage *langTo = [languagesTo objectAtIndex:[_langsToArrayController selectionIndex]];
    [self translate:[_sourceTextView string]
       fromLanguage:langFrom.code
         toLanguage:langTo.code
         withFormat:@"plain"];
}

- (void)textDidChange:(NSNotification *)notification
{
    [self beginTranslateTimer];
}

-(NSPrintOperation *)printOperationWithSettings:(NSDictionary *)printSettings error:(NSError *__autoreleasing *)outError
{
    NSPrintInfo *printInfo = [self printInfo];
    NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:_translatedTextView
                                                               printInfo:printInfo];
    return printOp;
}

@end
