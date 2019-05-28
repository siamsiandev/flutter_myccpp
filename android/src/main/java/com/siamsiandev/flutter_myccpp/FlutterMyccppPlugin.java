package com.siamsiandev.flutter_myccpp;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import com.ccpp.my2c2psdk.cores.*;

import java.util.HashMap;

/** FlutterMyccppPlugin */
public class FlutterMyccppPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
  /** Plugin registration. */
  private My2c2pSDK sdk;
  private final Activity activity;
  private static final int REQUEST_SDK = 1;
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_myccpp");
    FlutterMyccppPlugin plugin = new FlutterMyccppPlugin(registrar.activity());
    registrar.addActivityResultListener(plugin);
    channel.setMethodCallHandler(plugin);
  }

  private FlutterMyccppPlugin(Activity activity) {
    this.activity = activity;
  }
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("initialize")) {
      String privateKey = call.argument("privateKey");
      boolean productionMode = call.argument("productionMode");
      setup(privateKey, productionMode);
    } else if(call.method.equals("requestPayment")) {
      setMandatoryFields(call.arguments());
      requestPayment();
    }else {
      result.notImplemented();
    }
  }
  public void setup(String privateKey, boolean productionMode) {
    sdk = new My2c2pSDK(privateKey);
    sdk.version = "9.1";
    sdk.productionMode = productionMode;
//    Intent intent = new Intent(activity, com.ccpp.my2c2psdk.cores.My3DSActivity.class);
//    intent.putExtra(My2c2pSDK.PARAMS, sdk);
//    activity.startActivityForResult(intent, 1);
  }

  private void setMandatoryFields(Object params) {
    HashMap<String, Object> paramsHash = (HashMap<String, Object>) params;
    Log.d("params", paramsHash.toString());
    sdk.merchantID = paramsHash.get("merchantID") == null ? "" : paramsHash.get("merchantID").toString();
    sdk.uniqueTransactionCode = paramsHash.get("uniqueTransactionCode") == null ? "" : paramsHash.get("uniqueTransactionCode").toString();
    sdk.desc = paramsHash.get("desc") == null ? "" : paramsHash.get("desc").toString();
    sdk.amount = paramsHash.get("amount") == null ? 0.0 : (double)paramsHash.get("amount");
    sdk.currencyCode = paramsHash.get("currencyCode") == null ? "" : paramsHash.get("currencyCode").toString();
    sdk.secretKey = paramsHash.get("secretKey") == null ? "" : paramsHash.get("secretKey").toString();
    sdk.paymentUI = paramsHash.get("paymentUI") == null ? false : (boolean)paramsHash.get("paymentUI");
    Log.d("params", sdk.toString());
  }

  private void requestPayment() {

//    Intent intent = new Intent(activity, com.ccpp.my2c2psdk.cores.My3DSActivity.class);
//    intent.putExtra(My2c2pSDK.PARAMS, sdk);
//    activity.startActivityForResult(intent, REQUEST_SDK);
  }

  @Override
  public boolean onActivityResult(int i, int i1, Intent intent) {
    return false;
  }
}
