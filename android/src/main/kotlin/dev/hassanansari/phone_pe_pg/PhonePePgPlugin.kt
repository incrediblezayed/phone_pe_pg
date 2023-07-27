package dev.hassanansari.phone_pe_pg

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.ByteArrayOutputStream

/** PhonePePgPlugin */
class PhonePePgPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var registrar: FlutterPlugin.FlutterPluginBinding
  private val channelName = "phone_pe_pg"
  private val getUpiApps = "getUpiApps"
  private val startTransaction = "startTransaction"
  private val paymentReqCode = 777
  private var upiActivity: UpiActivity? = null
  private var activityPluginBinding: ActivityPluginBinding? = null
  private var result: MethodChannel.Result? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    registrar = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    this.result = result
    if(upiActivity == null) {
      createUpiActivity();
    }
    when(call.method) {
        getUpiApps -> {
          try {
            val upiApps = getUPIApps()
            result.success(upiApps)
          }catch (e: Exception){
            result.error("Error", e.message, null)
          }
        }
        startTransaction -> {
          try {
            val url = call.argument<String>("upi_uri")
            val packageName = call.argument<String>("package")
            upiActivity!!.startTransaction(upiUri = url!!, packageName = packageName!!, result = result);
          }catch (e: Exception) {
            result.error("Error", e.message, e)
          }
        }
        else -> {
          result.notImplemented()
        }
    }
  }



  private fun getUPIApps(): List<Map<String, Any?>> {
    val packageManager = registrar.applicationContext.packageManager
    val intent = Intent()
    val uri = Uri.parse(String.format("%s://%s", "upi", "pay"))
    intent.data = uri
    val resolveInfoList = packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY)
    val upiAppInfoList = mutableListOf<Map<String, Any?>>()
    for (resolveInfo in resolveInfoList) {
      val packageName = resolveInfo.activityInfo.packageName
      val appName = resolveInfo.loadLabel(packageManager).toString()
      val appIcon = resolveInfo.loadIcon(packageManager)

      val byteArray = drawableToByteArray(appIcon)
      val appInfoMap = mapOf(
        "appName" to appName,
        "packageName" to packageName,
        "appIcon" to byteArray
      )
      upiAppInfoList.add(appInfoMap)
    }

    return upiAppInfoList
  }

  private fun drawableToByteArray(drawable: Drawable): ByteArray {
    val bitmap = when (drawable) {
      is BitmapDrawable -> drawable.bitmap
      else -> {
        val width = drawable.intrinsicWidth.takeIf { it > 0 } ?: 1
        val height = drawable.intrinsicHeight.takeIf { it > 0 } ?: 1

        Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
          .apply {
            val canvas = Canvas(this)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
          }
      }
    }
    val outputStream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
    return outputStream.toByteArray()
  }



  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    removeActivityResultListener();
    channel.setMethodCallHandler(null)

  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activityPluginBinding = binding;
    createUpiActivity();
  }

  override fun onDetachedFromActivityForConfigChanges() {
    result!!.error("Error", "Cancelled by user", null)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activityPluginBinding = binding;
    createUpiActivity();
  }

  override fun onDetachedFromActivity() {
    result!!.error("Error", "Cancelled by user", null)
    removeActivityResultListener();

  }

  private fun removeActivityResultListener() {
    if(activityPluginBinding!=null) {
      activityPluginBinding!!.removeActivityResultListener(upiActivity!!)
      upiActivity = null;
    }
  }

  private fun createUpiActivity(): UpiActivity {
    this.upiActivity = UpiActivity(activityPluginBinding!!.activity!!)
    activityPluginBinding!!.addActivityResultListener(upiActivity!!)
    return upiActivity!!
  }
}
