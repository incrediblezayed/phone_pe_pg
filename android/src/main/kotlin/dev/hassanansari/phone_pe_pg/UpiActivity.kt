package dev.hassanansari.phone_pe_pg

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject

class UpiActivity(private val activity: Activity) : PluginRegistry.ActivityResultListener {
    private var result: MethodChannel.Result? = null
    private val paymentReqCode = 777
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if(data?.extras == null) {
            result?.error("Error", "Cancelled by user", null)
            return false
        }
        val data = data!!.extras;

        val status = data?.getString("Status")
        val isExternalMerchant = data?.getBoolean("isExternalMerchant", true)
        val txnRef = data?.getString("txnRef")
        val responseCode = data?.getString("responseCode")
        val hashMap = HashMap<String, Any?>()
        hashMap["Status"] = status
        hashMap["isExternalMerchant"] = isExternalMerchant
        hashMap["txnRef"] = txnRef
        hashMap["responseCode"] = responseCode
        hashMap["response"] = data?.getString("response")
        hashMap["bleTxId"] = data?.getString("bleTxId")
        hashMap["txId"] = data?.getString("txId")
        val json = JSONObject(hashMap as Map<*, *>?);
        result?.success(json.toString());
        return true
    }

     fun startTransaction(upiUri: String, packageName: String, result: MethodChannel.Result) {
        this.result = result
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(upiUri)
        intent.setPackage(packageName)
        activity.startActivityForResult(intent, paymentReqCode)
    }


}