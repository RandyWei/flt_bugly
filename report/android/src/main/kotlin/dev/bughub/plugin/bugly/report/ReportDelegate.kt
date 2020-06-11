package dev.bughub.plugin.bugly.report

import android.app.Activity
import android.content.Context
import com.tencent.bugly.Bugly
import com.tencent.bugly.crashreport.CrashReport

class ReportDelegate(var activity: Activity?) {

    fun initBugly(context: Context, appId: String, debug: Boolean = false) {
        Bugly.init(context, appId, debug)
    }

    fun postException(message: String, detail: String, map: Map<String, String>) {
        CrashReport.postException(8, "Flutter Exception", message, detail, map)
    }
}