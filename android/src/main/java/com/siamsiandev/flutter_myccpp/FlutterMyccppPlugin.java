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
  private final String PRIVATE_KEY = "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";
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
//    sdk.merchantID = "764764000001966";
//    sdk.secretKey = "24ABCC819638916E7DD47D09F2DEA4588FAE70636B085B8DE47A9592C4FD034F";
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
