//
// SQLite3Connection.c
// CoreSQLite3 Framework
//
// Created by Mirek Rusin on 07/02/2011.
// Copyright 2011 Inteliv Ltd. All rights reserved.
//

#import "SQLite3Connection.h"


#pragma Lifecycle

inline SQLite3ConnectionRef _SQLite3ConnectionCreate(CFAllocatorRef allocator, CFStringRef path, int flags, const char *zVfs) {
  SQLite3ConnectionRef connection = CFAllocatorAllocate(allocator, sizeof(SQLite3ConnectionRef), 0);
  connection->allocator = allocator ? CFRetain(allocator) : NULL;
  connection->retainCount = 1;
  int sqlite3_open_v2_result = sqlite3_open_v2([(NSString *)path UTF8String], &connection->db, flags, zVfs);
  if (sqlite3_open_v2_result != SQLITE_OK) {
    if (!connection->db) // If the sqlite3 connection has not been allocated, we deallocate connection and return NULL
      SQLite3ConnectionRelease(connection);
  }
  return connection;
}

inline SQLite3ConnectionRef SQLite3ConnectionCreate(CFStringRef path, int flags, const char *zVfs) {
  return _SQLite3ConnectionCreate(NULL, path, flags, zVfs);
}

// TODO: Open in read-only mode
// Pass bundle = NULL to use the main bundle
void SQLite3OpenResource(CFBundleRef bundle, CFStringRef resourceName, CFStringRef resourceType, CFStringRef subDirName, sqlite3 **db) {
  if (bundle == NULL)
    bundle = CFBundleGetMainBundle();
  CFURLRef url = CFBundleCopyResourceURL(bundle, resourceName, resourceType, subDirName);
  if (url) {
    CFShow(url);
    if (sqlite3_open_v2(CFStringGetCStringPtr(CFURLGetString(url), kCFStringEncodingUTF8), db, SQLITE_OPEN_READONLY, NULL)) {
      printf("ERROR %s\n", (const unsigned char *)sqlite3_errmsg(*db));
    }
    CFRelease(url);
  }
}

inline int SQLite3ConnectionClose(SQLite3ConnectionRef connection) {
  return connection ? sqlite3_close(connection->db) : SQLITE_OK;
}

inline SQLite3ConnectionRef SQLite3ConnectionRelease(SQLite3ConnectionRef connection) {
  if (--connection->retainCount <= 0) {
    SQLite3ConnectionClose(connection);
    CFAllocatorRef allocator = connection->allocator;
    CFAllocatorDeallocate(allocator, connection);
    connection = NULL;
    if (allocator)
      CFRelease(allocator);
  }
  return connection;
}

inline NSUInteger SQLite3ConnectionGetRetainCount(SQLite3ConnectionRef connection) {
  return connection->retainCount;
}

inline SQLite3ConnectionRef SQLite3ConnectionRetain(SQLite3ConnectionRef connection) {
  ++connection->retainCount;
  return connection;
}

// If the connection is NULL, return error. Otherwise return NULL if the sqlite3 connection
// doesn't have an error. Otherwise return the error.
CFErrorRef SQLite3ConnectionCreateError(SQLite3ConnectionRef connection) {
  CFErrorRef error = NULL;
  if (SQLite3ConnectionHasError(connection)) {
    const char *errmsg = connection ? sqlite3_errmsg(connection->db) : "Connection has not been allocated";
    int errcode = connection ? sqlite3_errcode(connection->db) : SQLITE_ERROR;
    CFStringRef keys[1] = { kCFErrorLocalizedDescriptionKey };
    CFStringRef values[1] = { CFStringCreateWithCString(NULL, errmsg, kCFStringEncodingUTF8) };
    CFDictionaryRef userInfo = CFDictionaryCreate(NULL, (void *)keys, (void *)values, 1, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    error = CFErrorCreate(NULL, CFSTR("com.github.mirek.CoreSQLite3"), errcode, userInfo);
    CFRelease(userInfo);
    CFRelease(values[1]);
  }
  return error;
}

// If the connection is NULL or sqlite3 connection has an error, return YES. Otherwise return NO.
inline BOOL SQLite3ConnectionHasError(SQLite3ConnectionRef connection) {
  return connection ? sqlite3_errcode(connection->db) != SQLITE_OK : YES;
}

// Return NULL if the connection is not allocated. Otherwise return sqlite3 connection.
inline sqlite3 *SQLite3ConnectionGetConnection(SQLite3ConnectionRef connection) {
  return connection ? connection->db : NULL;
}



