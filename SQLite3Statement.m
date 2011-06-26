//
//  SQLite3Statement.m
//  SQLite3
//
//  Created by Mirek Rusin on 25/06/2011.
//  Copyright 2011 Inteliv Ltd. All rights reserved.
//

#import "SQLite3Statement.h"

@implementation SQLite3Statement

@synthesize connection;
@synthesize statement;

#pragma mark Lifecycle

- (id) initWithConnection: (SQLite3Connection *) anConnection query: (NSString *) sql {
  if ((self = [super init])) {
    connection = [anConnection retain];
    statement = SQLite3StatementCreate(connection.connection, (CFStringRef)sql);
  }
  return self;
}

- (id) initWithConnection: (SQLite3Connection *) anConnection query: (NSString *) sql arrayBindings: (NSArray *) arrayBindings {
  if ((self = [super init])) {
    connection = [anConnection retain];
    statement = SQLite3StatementCreateWithArrayBindings(connection.connection, (CFStringRef)sql, (CFArrayRef)arrayBindings);
  }
  return self;
}

- (id) initWithConnection: (SQLite3Connection *) anConnection query: (NSString *) sql dictionaryBindings: (NSDictionary *) dictionaryBindings {
  if ((self = [super init])) {
    connection = [anConnection retain];
    statement = SQLite3StatementCreateWithDictionaryBindings(connection.connection, (CFStringRef)sql, (CFDictionaryRef)dictionaryBindings);
  }
  return self;
}

+ (id) statementWithConnection: (SQLite3Connection *) connection query: (NSString *) sql {
  return [[[self alloc] initWithConnection: connection query: sql] autorelease];
}

+ (id) statementWithConnection: (SQLite3Connection *) connection query: (NSString *) sql arrayBindings: (NSArray *) arrayBindings {
  return [[[self alloc] initWithConnection: connection query: sql arrayBindings: arrayBindings] autorelease];
}

+ (id) statementWithConnection: (SQLite3Connection *) connection query: (NSString *) sql dictionaryBindings: (NSDictionary *) dictionaryBindings {
  return [[[self alloc] initWithConnection: connection query: sql dictionaryBindings: dictionaryBindings] autorelease];
}

- (void) dealloc {
  SQLite3StatementRelease(statement);
  [connection release];
  [super dealloc];
}

#pragma mark Column info

- (NSInteger) columnCount {
  return SQLite3StatementGetColumnCount(statement);
}

- (SQLite3ColumnType) columnTypeWithIndex: (NSInteger) index {
  return SQLite3StatementGetColumnType(statement, index);
}

- (SQLite3ColumnType) columnTypeWithName: (NSString *) name {
  return SQLite3StatementGetColumnTypeWithName(statement, (CFStringRef)name);
}

#pragma mark Bindings

- (NSInteger) bindParameterIndexWithName: (NSString *) nameWithSpecialCharacter {
  return SQLite3StatementGetBindParameterIndexWithName(statement, (CFStringRef)nameWithSpecialCharacter);
}

- (NSInteger) bindParametersCount {
  return SQLite3StatementGetBindParameterCount(statement);
}

- (NSString *) createBindParameterNameWithIndex: (NSInteger) _1BasedIndex withoutSpecialCharacter: (BOOL) withoutSpecialCharacter {
  return (NSString *)SQLite3StatementCreateBindParameterNameWithIndex(statement, _1BasedIndex, withoutSpecialCharacter);
}

- (NSString *) bindParameterNameWithIndex: (NSInteger) _1BasedIndex withoutSpecialCharacter: (BOOL) withoutSpecialCharacter {
  return [[self createBindParameterNameWithIndex: _1BasedIndex withoutSpecialCharacter: withoutSpecialCharacter] autorelease];
}

- (SQLite3Status) bindArray: (NSArray *) array {
  return SQLite3StatementBindArray(statement, (CFArrayRef)array);
}

- (SQLite3Status) bindDictionary: (NSDictionary *) dictionary {
  return SQLite3StatementBindDictionary(statement, (CFDictionaryRef)dictionary);
}

- (SQLite3Status) bindObject: (id) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindCFType(statement, _1BasedIndex, (CFTypeRef)value);
}

- (SQLite3Status) bindString: (NSString *) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindString(statement, _1BasedIndex, (CFStringRef)value);
}

- (SQLite3Status) bindNumber: (NSNumber *) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindNumber(statement, _1BasedIndex, (CFNumberRef)value);
}

- (SQLite3Status) bindDate: (NSDate *) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindDate(statement, _1BasedIndex, (CFDateRef)value);
}

- (SQLite3Status) bindData: (NSData *) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindData(statement, _1BasedIndex, (CFDataRef)value);
}

- (SQLite3Status) bindBOOL: (BOOL) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindBool(statement, _1BasedIndex, value);
}

- (SQLite3Status) bindInt32: (int32_t) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindInt32(statement, _1BasedIndex, value);
}

- (SQLite3Status) bindInt64: (int64_t) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindInt64(statement, _1BasedIndex, value);
}

- (SQLite3Status) bindDouble: (double_t) value withIndex: (NSInteger) _1BasedIndex {
  return SQLite3StatementBindDouble(statement, _1BasedIndex, value);
}

- (SQLite3Status) bindObject: (id) value withName: (NSString *) nameWithSpecialCharacter {
  return SQLite3StatementBindCFTypeWithName(statement, (CFStringRef)nameWithSpecialCharacter, (CFTypeRef)value);
}

- (SQLite3Status) bindString: (NSString *) value withName: (NSString *) nameWithSpecialCharacter {
  return SQLite3StatementBindStringWithName(statement, (CFStringRef)nameWithSpecialCharacter, (CFStringRef)value);
}

- (SQLite3Status) bindNumber: (NSNumber *) value withName: (NSString *) nameWithSpecialCharacter {
  return SQLite3StatementBindNumberWithName(statement, (CFStringRef)nameWithSpecialCharacter, (CFNumberRef)value);
}

- (SQLite3Status) bindDate: (NSDate *) value withName: (NSString *) name {
  return SQLite3StatementBindDateWithName(statement, (CFStringRef)name, (CFDateRef)value);
}

//- (SQLite3Status) bindData: (NSData *) value withName: (NSString *) name;
//
//- (SQLite3Status) bindBOOL: (BOOL) value withName: (NSString *) name;
//- (SQLite3Status) bindInt32: (int32_t) value withName: (NSString *) name;
//- (SQLite3Status) bindInt64: (int64_t) value withName: (NSString *) name;
//- (SQLite3Status) bindDouble: (double_t) value withName: (NSString *) name;

//- (SQLite3Status) bindObject: (id) value withIndex: (NSInteger) index {
//  return SQLite3StatementBindCFType(statement, index, (CFTypeRef)value);
//}
//
//- (SQLite3Status) bindString: (NSString *) value withIndex: (NSInteger) index {
//  return SQLite3StatementBindString(statement, index, (CFStringRef)value);
//}
//
//- (SQLite3Status) bindObject: (id) object withName: (NSString *) name {
//  return SQLite3StatementBindCFTypeWithName(statement, (CFStringRef)name, (CFTypeRef)object);
//}
//
//- (SQLite3Status) bindString: (NSString *) value withName: (NSString *) name {
//  return SQLite3StatementBindStringWithName(statement, (CFStringRef)name, (CFStringRef)value);
//}
//
//- (SQLite3Status) bindNumber:(NSNumber *)value withName:(NSString *)name {
//  
//}

#pragma mark Fast Enumeration

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState *) state objects: (id *) stackbuf count: (NSUInteger) len {
	NSUInteger count = 0;
	if (state->state == 0) {
		state->mutationsPtr = &state->extra[0];
    state->extra[0] = kSQLite3StatusRow;
	}
  if (state->extra[0] == kSQLite3StatusRow) {
    state->itemsPtr = stackbuf;
    while (kSQLite3StatusRow == (state->extra[0] = SQLite3StatementStep(statement)) && (count < len) ) {
      stackbuf[count] = [(id)SQLite3StatementCreateDictionaryWithAllColumns(statement) autorelease];
      state->state++;
      count++;
    }
  }
  if (count == 0) {
    SQLite3StatementReset(statement);
  }
	return count;
}

@end