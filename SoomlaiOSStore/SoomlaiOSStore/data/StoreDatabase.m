/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "StoreDatabase.h"

#define DATABASE_NAME @"store.db"

#define ALL_COLUMN_ITEM_ID  @"item_id"

// Virtual Currency Table
#define VIRTUAL_CURRENCY_TABLE_NAME      @"virtual_currency"
#define VIRTUAL_CURRENCY_COLUMN_BALANCE  @"balance"

// Virtual Goods Table
#define VIRTUAL_GOODS_TABLE_NAME         @"virtual_goods"
#define VIRTUAL_GOODS_COLUMN_BALANCE     @"balance"
#define VIRTUAL_GOODS_COLUMN_EQUIPPED    @"equipped"

// Store Meta-Data Table
#define METADATA_TABLE_NAME              @"metadata"
#define METADATA_COLUMN_STOREINFO        @"store_info"
#define METADATA_COLUMN_STOREFRONTINFO   @"storefront_info" 


@implementation StoreDatabase

- (void)updateCurrencyBalance:(NSString*)balance forItemId:(NSString*)itemId{
    NSLog(@"Updating currency with itemId %@ and balance %@", itemId, balance);
    [self saveData:balance forAttr:VIRTUAL_CURRENCY_COLUMN_BALANCE toEntiry:VIRTUAL_CURRENCY_TABLE_NAME withItemId:itemId];
}

- (void)updateGoodBalance:(NSString*)balance forItemId:(NSString*)itemId{
    NSLog(@"Updating good with itemId %@ and balance %@", itemId, balance);
    [self saveData:balance forAttr:VIRTUAL_GOODS_COLUMN_BALANCE toEntiry:VIRTUAL_GOODS_TABLE_NAME withItemId:itemId];
}

- (void)updateGoodEquipped:(NSString*)equip forItemId:(NSString*)itemId{
    NSLog(@"Updating good with itemId %@ and equipped status %@", itemId, equip);
    [self saveData:equip forAttr:VIRTUAL_GOODS_COLUMN_EQUIPPED toEntiry:VIRTUAL_GOODS_TABLE_NAME withItemId:itemId];
}

- (NSDictionary*)getCurrencyWithItemId:(NSString*)itemId{
    NSArray* table = [self getEntity:VIRTUAL_CURRENCY_TABLE_NAME withItemId:itemId];
    
    if (table.count > 0){
        NSLog(@"found currency with itemId: %@", itemId);
        NSDictionary* rowDict = [table objectAtIndex:0];
        return [NSDictionary dictionaryWithObjectsAndKeys:
                itemId, DICT_KEY_ITEM_ID,
                [rowDict valueForKey:VIRTUAL_CURRENCY_COLUMN_BALANCE], DICT_KEY_BALANCE,
                nil];
    }
    
    NSLog(@"couldn't find currency for itemId %@. returning a NULL dictionary.", itemId);
    return NULL;
}

- (NSDictionary*)getGoodWithItemId:(NSString*)itemId{
    NSArray* table = [self getEntity:VIRTUAL_GOODS_TABLE_NAME withItemId:itemId];
    
    if (table.count > 0){
        NSLog(@"found good with itemId: %@", itemId);
        NSDictionary* rowDict = [table objectAtIndex:0];
        return [NSDictionary dictionaryWithObjectsAndKeys:
                itemId, DICT_KEY_ITEM_ID,
                [rowDict valueForKey:VIRTUAL_GOODS_COLUMN_BALANCE], DICT_KEY_BALANCE,
                [rowDict valueForKey:VIRTUAL_GOODS_COLUMN_EQUIPPED], DICT_KEY_EQUIP,
                nil];
    }
    
    NSLog(@"couldn't find good for itemId %@. returning a NULL dictionary.", itemId);
    return NULL;
}

- (void)setStoreInfo:(NSString*)storeInfoData{
    NSLog(@"Updating store info to %@", storeInfoData);
    [self saveData:storeInfoData forAttr:METADATA_COLUMN_STOREINFO toEntiry:METADATA_TABLE_NAME withItemId:@"INFO"];
}

- (void)setStorefrontInfo:(NSString*)storefrontInfoData{
    NSLog(@"Updating storefront info to %@", storefrontInfoData);
    [self saveData:storefrontInfoData forAttr:METADATA_COLUMN_STOREFRONTINFO toEntiry:METADATA_TABLE_NAME withItemId:@"INFO"];
}

- (NSString*)getStoreInfo{
    NSArray* table = [self getEntity:METADATA_TABLE_NAME withItemId:@"INFO"];
    
    if (table.count > 0){
        NSLog(@"found storeInfo");
        NSDictionary* rowDict = [table objectAtIndex:0];
        return [rowDict valueForKey:METADATA_COLUMN_STOREINFO];
    }
    
    NSLog(@"can't find the storeInfo. returning an empty string.");
    return @"";
}

- (NSString*)getStorefrontInfo{
    NSArray* table = [self getEntity:METADATA_TABLE_NAME withItemId:@"INFO"];
    
    if (table.count > 0){
        NSLog(@"found storefrontInfo");
        NSDictionary* rowDict = [table objectAtIndex:0];
        return [rowDict valueForKey:METADATA_COLUMN_STOREFRONTINFO];
    }
    
    NSLog(@"can't find the storefrontInfo. returning an empty string.");
    return @"";
}

- (id)init{
    if (self = [super init]) {
        NSString* databasebPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:DATABASE_NAME];
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: databasebPath] == NO)
        {
            const char *dbpath = [databasebPath UTF8String];
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                char *errMsg;
                
                NSString* createStmt = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT)", VIRTUAL_CURRENCY_TABLE_NAME, ALL_COLUMN_ITEM_ID, VIRTUAL_CURRENCY_COLUMN_BALANCE];
                if (sqlite3_exec(database, [createStmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create virtual currency table");
                }
                
                createStmt = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT)", VIRTUAL_GOODS_TABLE_NAME, ALL_COLUMN_ITEM_ID, VIRTUAL_GOODS_COLUMN_BALANCE, VIRTUAL_GOODS_COLUMN_EQUIPPED];
                if (sqlite3_exec(database, [createStmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create virtual good table");
                }
                
                createStmt = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT)", METADATA_TABLE_NAME, ALL_COLUMN_ITEM_ID, METADATA_COLUMN_STOREINFO, METADATA_COLUMN_STOREFRONTINFO];
                if (sqlite3_exec(database, [createStmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create metadata table");
                }
                
                sqlite3_close(database);
                
            } else {
                NSLog(@"Failed to open/create database");
            }
        }
    }
    return self;
}

- (NSArray*)getEntity:(NSString *)entityName withItemId:(NSString *)itemId{
    NSString* databasebPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:DATABASE_NAME];
    if (sqlite3_open([databasebPath UTF8String], &database) == SQLITE_OK)
    {
        NSMutableArray *result = [NSMutableArray array];
        sqlite3_stmt *statement = nil;
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", entityName, ALL_COLUMN_ITEM_ID, itemId] UTF8String];
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Error while fetching %@ : %s", itemId, sqlite3_errmsg(database));
        } else {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *row = [NSMutableDictionary dictionary];
                for (int i=0; i<sqlite3_column_count(statement); i++) {
                    int colType = sqlite3_column_type(statement, i);
                    id value;
                    if (colType == SQLITE_TEXT) {
                        const unsigned char *col = sqlite3_column_text(statement, i);
                        value = [NSString stringWithFormat:@"%s", col];
                    } else if (colType == SQLITE_INTEGER) {
                        int col = sqlite3_column_int(statement, i);
                        value = [NSNumber numberWithInt:col];
                    } else if (colType == SQLITE_FLOAT) {
                        double col = sqlite3_column_double(statement, i);
                        value = [NSNumber numberWithDouble:col];
                    } else if (colType == SQLITE_NULL) {
                        value = [NSNull null];
                    } else {
                        NSLog(@"ERROR: UNKNOWN COLUMN DATATYPE");
                    }
                    
                    NSString* colName = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    [row setObject:value forKey:colName];
                }
                [result addObject:row];
            }
            
            // Finalize
            sqlite3_finalize(statement);
        }
        
        // Close database
        sqlite3_close(database);
        return result;
    }
    else{
        NSLog(@"Failed to open/create database");
    }
    return nil;
}


- (void)saveData:(NSString *)data forAttr:(NSString *)attrName toEntiry:(NSString *)entityName withItemId:(NSString *)itemId{
    NSString* databasebPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:DATABASE_NAME];
    if (sqlite3_open([databasebPath UTF8String], &database) == SQLITE_OK)
    {
        
        NSString* updateStmt = [NSString stringWithFormat:@"UPDATE %@ SET %@=? WHERE %@=?",
                                entityName, attrName, ALL_COLUMN_ITEM_ID];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [updateStmt UTF8String], -1, &statement, NULL) != SQLITE_OK){
            NSLog(@"Updating itemId %@ failed: %s.", itemId, sqlite3_errmsg(database));
        }
        else{
            sqlite3_bind_text(statement, 1, [data UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [itemId UTF8String], -1, SQLITE_TRANSIENT);
            
            if(SQLITE_DONE != sqlite3_step(statement)){
                NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
                sqlite3_reset(statement);
            }
            else {
                int rowsaffected = sqlite3_changes(database);
                
                if (rowsaffected == 0){
                    NSLog(@"Can't update item b/c it doesn't exist. Trying to add a new one.");
                    NSString* addStmt = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@) VALUES('%@', '%@')",
                                         entityName, ALL_COLUMN_ITEM_ID, attrName, itemId, data];
                    if (sqlite3_prepare_v2(database, [addStmt UTF8String], -1, &statement, NULL) != SQLITE_OK){
                        NSLog(@"Adding new item failed: %s. George is upset!", sqlite3_errmsg(database));
                    }
                    
                    if(SQLITE_DONE != sqlite3_step(statement)){
                        NSAssert1(0, @"Error while adding item. '%s'", sqlite3_errmsg(database));
                        sqlite3_reset(statement);
                    }
                }
            }
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    else{
        NSLog(@"Failed to open/create database");
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end
