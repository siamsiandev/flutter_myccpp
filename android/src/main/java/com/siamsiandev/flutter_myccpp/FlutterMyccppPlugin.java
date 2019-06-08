package com.siamsiandev.flutter_myccpp;

import android.app.Activity;
import android.content.Intent;
import android.support.annotation.Nullable;
import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.ccpp.my2c2psdk.cores.*;

import java.util.HashMap;

import static android.app.Activity.RESULT_CANCELED;
import static android.app.Activity.RESULT_OK;

/**
 * FlutterMyccppPlugin
 */
public class FlutterMyccppPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
    /**
     * Plugin registration.
     */
    private My2c2pSDK sdk;
    private final Activity activity;
    private static final int REQUEST_SDK = 1;
    private Result result;

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
        this.result = result;
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("initialize")) {
            String privateKey = call.argument("privateKey");
            boolean productionMode = call.argument("productionMode");
            setup(privateKey, productionMode);
        } else if (call.method.equals("requestPayment")) {
            requestPayment(call.arguments());
        } else if (call.method.equals("requestAlternativePayment")) {
            requestAlternativePayment(call.arguments());
        } else {
            result.notImplemented();
        }
    }

    public void setup(String privateKey, boolean productionMode) {
        sdk = new My2c2pSDK(privateKey);
        sdk.version = "9.1";
        sdk.productionMode = productionMode;
    }

    private void requestPayment(Object params) {
        try {
            setMandatoryFields(params);
            setCardInfoFields(params);
            sendRequest();
        } catch (Exception e) {
            Log.e("Error", e.getMessage());
        }
    }

    private void requestAlternativePayment(Object params) {
        try {
            setMandatoryFields(params);
            setAlternativePaymentFields(params);
            sendRequest();
        } catch (Exception e) {

        }
    }

    private void setMandatoryFields(Object params) {
        HashMap<String, Object> paramsHash = (HashMap<String, Object>) params;
        Log.d("params", paramsHash.toString());
        sdk.merchantID = paramsHash.get("merchantID") == null ? "" : paramsHash.get("merchantID").toString();
        sdk.uniqueTransactionCode = paramsHash.get("uniqueTransactionCode") == null ? "" : paramsHash.get("uniqueTransactionCode").toString();
        sdk.desc = paramsHash.get("desc") == null ? "" : paramsHash.get("desc").toString();
        sdk.amount = paramsHash.get("amount") == null ? 0.0 : (double) paramsHash.get("amount");
        sdk.currencyCode = paramsHash.get("currencyCode") == null ? "" : paramsHash.get("currencyCode").toString();
        sdk.secretKey = paramsHash.get("secretKey") == null ? "" : paramsHash.get("secretKey").toString();
        sdk.paymentUI = paramsHash.get("paymentUI") == null ? false : (boolean) paramsHash.get("paymentUI");
        Log.d("params", sdk.toString());
    }

    private void setCardInfoFields(Object params) {
        HashMap<String, Object> paramsHash = (HashMap<String, Object>) params;
        boolean paymentUI = paramsHash.get("paymentUI") == null ? false : (boolean) paramsHash.get("paymentUI");
        if (!paymentUI) {
            sdk.pan = paramsHash.get("pan") == null ? "" : paramsHash.get("pan").toString();
            sdk.cardHolderName = paramsHash.get("cardHolderName") == null ? "" : paramsHash.get("cardHolderName").toString();
            sdk.cardHolderEmail = paramsHash.get("cardHolderEmail") == null ? "" : paramsHash.get("cardHolderEmail").toString();
            sdk.panBank = paramsHash.get("panBank") == null ? "" : paramsHash.get("panBank").toString();
            sdk.panCountry = paramsHash.get("panCountry") == null ? "" : paramsHash.get("panCountry").toString();
            sdk.securityCode = paramsHash.get("securityCode") == null ? "" : paramsHash.get("securityCode").toString();
            sdk.cardExpireMonth = String.format("%02d", (int) paramsHash.get("cardExpireMonth"));
            sdk.cardExpireYear = String.format("%04d", (int) paramsHash.get("cardExpireYear"));
        }
        sdk.storeCard = paramsHash.get("storeCard") == null ? false : (boolean) paramsHash.get("storeCard");
        sdk.storedCardUniqueID = paramsHash.get("storedCardUniqueID") == null ? "" : paramsHash.get("storedCardUniqueID").toString();
        sdk.request3DS = paramsHash.get("request3DS") == null ? "Y" : paramsHash.get("request3DS").toString();
    }

    private void setAlternativePaymentFields(Object params) {
        HashMap<String, Object> paramsHash = (HashMap<String, Object>) params;
        My2c2pSDK.PaymentChannel paymentChannel = My2c2pSDK.PaymentChannel.valueOf(
                paramsHash.get("paymentChannel") == null ?
                        "ONE_TWO_THREE" :
                        paramsHash.get("paymentChannel").toString());

        sdk.paymentChannel = paymentChannel;
        sdk.cardHolderName = paramsHash.get("cardHolderName") == null ? "" : paramsHash.get("cardHolderName").toString();
        sdk.cardHolderEmail = paramsHash.get("cardHolderEmail") == null ? "" : paramsHash.get("cardHolderEmail").toString();
        sdk.agentCode = paramsHash.get("agentCode") == null ? "" : paramsHash.get("agentCode").toString();
        sdk.channelCode = paramsHash.get("channelCode") == null ? "" : paramsHash.get("channelCode").toString();
        sdk.paymentExpiry = paramsHash.get("paymentExpiry") == null ? "" : paramsHash.get("paymentExpiry").toString();
        sdk.mobileNo = paramsHash.get("mobileNo") == null ? "" : paramsHash.get("mobileNo").toString();
    }

    private void sendRequest() {
        Intent intent = new Intent(activity, com.ccpp.my2c2psdk.cores.My3DSActivity.class);
        intent.putExtra(My2c2pSDK.PARAMS, sdk);
        activity.startActivityForResult(intent, REQUEST_SDK);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == REQUEST_SDK) {
            if(resultCode == RESULT_CANCELED){
                // response fail
            } else if(resultCode == RESULT_OK) {
                if (data != null) {
                    My2c2pResponse response = data.getExtras().getParcelable(My2c2pResponse.RESPONSE);
                    if (response != null) {
                        if (response.getRespCode().equals("301")) {
                            // response fail
                            System.out.println(" transaction canceled" + resultCode);
                        }
                        // response success
                        Log.d("response", response.toString());

                    } else {
                        // response fail

                    }
                } else {
                    // response fail

                }
            }

        }
        return false;
    }
}
