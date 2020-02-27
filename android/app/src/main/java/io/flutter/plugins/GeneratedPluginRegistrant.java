package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import xyz.luan.audioplayers.AudioplayersPlugin;
import de.mintware.barcode_scan.BarcodeScanPlugin;
import io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin;
import io.flutter.plugins.firebase.cloudfunctions.CloudFunctionsPlugin;
import io.flutter.plugins.firebaseauth.FirebaseAuthPlugin;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;
import io.flutter.plugins.firebase.storage.FirebaseStoragePlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import io.flutter.plugins.imagepickersaver.ImagePickerSaverPlugin;
import com.vb.nested_navigators.NestedNavigatorsPlugin;
import com.crazecoder.openfile.OpenFilePlugin;
import io.flutter.plugins.packageinfo.PackageInfoPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import com.wisecrab.wc_flutter_share.WcFlutterSharePlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;
import io.github.nitishk72.youtubeapi.youtubeapi.YoutubeApiPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AudioplayersPlugin.registerWith(registry.registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
    BarcodeScanPlugin.registerWith(registry.registrarFor("de.mintware.barcode_scan.BarcodeScanPlugin"));
    CloudFirestorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin"));
    CloudFunctionsPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.cloudfunctions.CloudFunctionsPlugin"));
    FirebaseAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
    FirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
    FirebaseStoragePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.storage.FirebaseStoragePlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    ImagePickerSaverPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepickersaver.ImagePickerSaverPlugin"));
    NestedNavigatorsPlugin.registerWith(registry.registrarFor("com.vb.nested_navigators.NestedNavigatorsPlugin"));
    OpenFilePlugin.registerWith(registry.registrarFor("com.crazecoder.openfile.OpenFilePlugin"));
    PackageInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.packageinfo.PackageInfoPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    WcFlutterSharePlugin.registerWith(registry.registrarFor("com.wisecrab.wc_flutter_share.WcFlutterSharePlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
    YoutubeApiPlugin.registerWith(registry.registrarFor("io.github.nitishk72.youtubeapi.youtubeapi.YoutubeApiPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
