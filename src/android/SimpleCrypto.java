package com.disusered.simplecrypto;

import org.cryptonode.jncryptor.*;
import android.util.Base64;
import android.util.Log;
import java.util.List;
import java.util.Arrays;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Usage:
 * @author see: https://code.google.com/p/jncryptor/
 */
public class SimpleCrypto extends CordovaPlugin {

    private final String TAG = "SimpleCrypto Plugin";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
     boolean result = true;
     Log.d(TAG, "execute() called. Action: " + action);

     List<String> actions = Arrays.asList("encrypt", "decrypt");
     if (!actions.contains(action)) {
         Log.e(TAG, "Invalid action: " + action);
         result = false;
     } else {
         try {
             JNCryptor cryptor = new AES256JNCryptor();
             String KEY  = args.getString(0);
             String DATA = args.getString(1);
             if (action.equals("encrypt")) {
                try {
                    byte[] ciphertext = cryptor.encryptData(DATA.getBytes(), KEY.toCharArray());
                    callbackContext.success(Base64.encodeToString(ciphertext, 0));
                 } catch (CryptorException e) {
                   e.printStackTrace();
                   result = false;
                 }
             } else {
                 if (DATA.length() == 0) {
                     callbackContext.error("source data cannot be empty string");
                     result = false;
                 } else {
                     byte[] raw = cryptor.decryptData(Base64.decode(DATA,0), KEY.toCharArray());
                     callbackContext.success(new String(raw));
                 }
             }
         } catch (JSONException e) {
             Log.e(TAG, "Got JSON Exception " + e.getMessage());
             callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION, e.getMessage()));
             result = false;
         } catch(Exception e) {
             Log.e(TAG, "Got Unhandled Exception " + e.getMessage());
             callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, e.getMessage()));
             result = false;
         }
     }
     return result;
    }
}
