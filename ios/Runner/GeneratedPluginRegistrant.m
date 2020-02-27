//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <audioplayers/AudioplayersPlugin.h>
#import <barcode_scan/BarcodeScanPlugin.h>
#import <cloud_firestore/CloudFirestorePlugin.h>
#import <cloud_functions/CloudFunctionsPlugin.h>
#import <firebase_auth/FirebaseAuthPlugin.h>
#import <firebase_core/FirebaseCorePlugin.h>
#import <firebase_storage/FirebaseStoragePlugin.h>
#import <image_picker/ImagePickerPlugin.h>
#import <image_picker_saver/ImagePickerSaverPlugin.h>
#import <nested_navigators/NestedNavigatorsPlugin.h>
#import <open_file/OpenFilePlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <sqflite/SqflitePlugin.h>
#import <wc_flutter_share/WcFlutterSharePlugin.h>
#import <webview_flutter/WebViewFlutterPlugin.h>
#import <youtube_api/YoutubeApiPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AudioplayersPlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioplayersPlugin"]];
  [BarcodeScanPlugin registerWithRegistrar:[registry registrarForPlugin:@"BarcodeScanPlugin"]];
  [FLTCloudFirestorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTCloudFirestorePlugin"]];
  [CloudFunctionsPlugin registerWithRegistrar:[registry registrarForPlugin:@"CloudFunctionsPlugin"]];
  [FLTFirebaseAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAuthPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FLTFirebaseStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseStoragePlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [FLTImagePickerSaverPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerSaverPlugin"]];
  [NestedNavigatorsPlugin registerWithRegistrar:[registry registrarForPlugin:@"NestedNavigatorsPlugin"]];
  [OpenFilePlugin registerWithRegistrar:[registry registrarForPlugin:@"OpenFilePlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [WcFlutterSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"WcFlutterSharePlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
  [YoutubeApiPlugin registerWithRegistrar:[registry registrarForPlugin:@"YoutubeApiPlugin"]];
}

@end
