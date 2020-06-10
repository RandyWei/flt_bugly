package dev.bughub.plugin.bugly.report_example

import dev.bughub.plugin.bugly.report.ReportPlugin
import io.flutter.app.FlutterApplication

class App:FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        ReportPlugin.initBugly(this,"c27bef3514",true)
    }
}