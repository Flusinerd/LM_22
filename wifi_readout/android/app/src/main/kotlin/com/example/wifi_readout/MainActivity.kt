package com.example.wifi_readout

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.TransportInfo
import android.net.wifi.WifiInfo
import android.os.Build
import androidx.annotation.RequiresApi
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class MainActivity: FlutterActivity() {
    private val CHANNEL = "de.hs-bochum/wifi"

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getWifiStrength") {
                val cap = networkCapabilities() as WifiInfo;
                result.success(hashMapOf(
                    "signalStrength" to cap.rssi,
                    "ssid" to cap.ssid,
                    "frequency" to cap.frequency
                ));
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun networkCapabilities(): TransportInfo {
        val connectivityManager =
            this.applicationContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val activeNetwork = connectivityManager.activeNetwork ?: throw Error("No wifi connected")
        return connectivityManager.getNetworkCapabilities(activeNetwork)?.transportInfo
            ?: throw  Error("Could not get info")
    }

}
