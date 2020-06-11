package dev.bughub.plugin.bugly.report

import android.app.Activity
import android.app.Application
import android.content.Context
import android.text.TextUtils
import androidx.annotation.NonNull;
import com.tencent.bugly.Bugly

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** ReportPlugin */
public class ReportPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var activity: Activity? = null
    private var delegate: ReportDelegate? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var flutterBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var application: Application? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = flutterPluginBinding
        setup(flutterBinding?.binaryMessenger!!, flutterBinding?.applicationContext as Application, null, null, null)
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {

        private const val CHANNEL = "plugin.bughub.dev/report"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL)
            channel.setMethodCallHandler(ReportPlugin())

            if (registrar.activity() == null) {
                return
            }
            val activity = registrar.activity()
            var application: Application? = null
            if (registrar.context() != null) {
                application = registrar.context().applicationContext as Application
            }
            val plugin = ReportPlugin()
            plugin.setup(registrar.messenger(), application!!, activity, registrar, null)
        }

        @JvmStatic
        fun initBugly(context: Context, appId: String, debug: Boolean) {
            Bugly.init(context, appId, debug)
        }
    }

    private fun setup(
            messenger: BinaryMessenger,
            application: Application,
            activity: Activity?,
            registrar: Registrar?,
            activityBinding: ActivityPluginBinding?) {

        this.activity = activity
        this.application = application
        delegate = ReportDelegate(activity)
        channel = MethodChannel(messenger, CHANNEL)
        channel.setMethodCallHandler(this)
//        observer = LifeCycleObserver(activity)
        if (registrar != null) { // V1 embedding setup for activity listeners.
//            application.registerActivityLifecycleCallbacks(observer)
//      registrar.addActivityResultListener(delegate)
//      registrar.addRequestPermissionsResultListener(delegate)
        } else { // V2 embedding setup for activity listeners.
//      activityBinding?.addActivityResultListener(delegate!!)
//      activityBinding?.addRequestPermissionsResultListener(delegate!!)
//            lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(activityBinding)
//            lifecycle.addObserver(observer)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> {
                if (this.application == null) {
                    result.error("404", "application is null", null)
                } else {
                    val appId = call.argument<String>("appId")
                    val debug = call.argument<Boolean>("debug") ?: false
                    if (TextUtils.isEmpty(appId)) {
                        result.error("404", "appId is null", null)
                    } else {
                        delegate?.initBugly(this.application!!, "", debug)
                        result.success(null)
                    }
                }
            }
            "postException" -> {
                val message = call.argument<String>("message") ?: ""
                val detail = call.argument<String>("detail") ?: ""
                val map = call.argument<Map<String, String>>("data") ?: HashMap()
                delegate?.postException(message, detail, map)
                result.success(null)
            }
            "setUserId" -> {
                val userId = call.argument<String>("userId")
                if (userId != null) {
                    delegate?.setUserId(userId)
                }
                result.success(null)
            }
            "putUserData" -> {
                val userDataList = call.argument<List<Map<String, String>>>("userData")
                if (userDataList != null) {
                    for (userData in userDataList) {
                        val key = userData["key"]
                        val value = userData["value"]
                        if (this.application != null && !TextUtils.isEmpty(key) && !TextUtils.isEmpty(value)) {
                            delegate?.putUserData(this.application!!, key!!, value!!)
                        }
                    }
                }
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = null
    }

}
