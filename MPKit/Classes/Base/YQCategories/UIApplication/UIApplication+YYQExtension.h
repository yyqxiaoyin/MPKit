//
//  UIApplication+YYQExtension.h
//
//  Created by 尹永奇 on 16/6/15.
//  Copyright © 2016年 尹永奇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIApplication (YYQExtension)

/**
 *  沙盒中documents文件夹的路径NSURL
 */
@property (nonatomic, readonly) NSURL *documentURL;

/**
 *  沙盒中documents文件夹的路径NSString
 */
@property (nonatomic, readonly) NSString *documentsPath;

/**
 *  沙盒中caches文件夹的路径NSURL
 */
@property (nonatomic, readonly) NSURL *cachesURL;

/**
 *  沙盒中caches文件夹的路径NSString
 */
@property (nonatomic, readonly) NSString *cachesPath;

/**
 *  沙盒中library文件夹的路径NSURL
 */
@property (nonatomic, readonly) NSURL *libraryURL;

/**
 *  沙盒中library文件夹的路径NSString
 */
@property (nonatomic, readonly) NSString *libraryPath;

/**
 *  app的bundleName
 */
@property (nullable, nonatomic, readonly) NSString *appBundleName;

/**
 *  app的bundleID
 */
@property (nullable, nonatomic, readonly) NSString *appBundleID;

/**
 *  版本号appVersion
 */
@property (nullable, nonatomic, readonly) NSString *appVersion;

/**
 *  获取构建版本号
 */
@property (nullable, nonatomic, readonly) NSString *appBuildVersion;

@end

NS_ASSUME_NONNULL_END
