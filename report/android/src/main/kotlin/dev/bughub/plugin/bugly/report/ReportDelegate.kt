package dev.bughub.plugin.bugly.report

import android.app.Activity
import android.content.Context
import com.tencent.bugly.Bugly

class ReportDelegate (var activity: Activity?){

    fun initBugly(context:Context,appId:String,debug:Boolean=false) {
        Bugly.init(context,appId,debug)
    }
}