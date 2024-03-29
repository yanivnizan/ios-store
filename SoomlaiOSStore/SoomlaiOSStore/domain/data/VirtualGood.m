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

#import "VirtualGood.h"
#import "JSONConsts.h"
#import "PriceModel.h"
#import "VirtualCategory.h"
#import "StoreInfo.h"
#import "VirtualItemNotFoundException.h"

@implementation VirtualGood

@synthesize priceModel, category, equipped;

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
    andImgFilePath:(NSString*)oImgFilePath andItemId:(NSString*)oItemId andPriceModel:(PriceModel*)oPriceModel
       andCategory:(VirtualCategory*)oCategory andEquipStatus:(BOOL)oEquipped{
    
    self = [super initWithName:oName andDescription:oDescription andImgFilePath:oImgFilePath andItemId:oItemId];
    if (self){
        self.priceModel = oPriceModel;
        self.category = oCategory;
        self.equipped = oEquipped;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super initWithDictionary:dict];
    if (self) {
        self.priceModel = [PriceModel priceModelWithNSDictionary:[dict objectForKey:JSON_GOOD_PRICE_MODEL]];
        self.equipped = [[dict objectForKey:JSON_GOOD_EQUIPPED] boolValue];
        int categoryId = [[dict objectForKey:JSON_CURRENCYPACK_CATEGORY_ID] intValue];
        @try {
            if (categoryId > -1){
                self.category = [[StoreInfo getInstance] categoryWithId:categoryId];
            }
        }
        @catch (VirtualItemNotFoundException *exception) {
            NSLog(@"Can't find category with id: %d", categoryId);
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    NSDictionary* parentDict = [super toDictionary];
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:[self.priceModel toDictionary] forKey:JSON_GOOD_PRICE_MODEL];
    [toReturn setValue:[NSNumber numberWithInt:self.category.Id] forKey:JSON_CURRENCYPACK_CATEGORY_ID];
    [toReturn setValue:[NSNumber numberWithBool:self.equipped] forKey:JSON_GOOD_EQUIPPED];
    
    return toReturn;
}

- (NSDictionary*)currencyValues{
    return [priceModel getCurrentPriceForVirtualGood:self];
}

@end
