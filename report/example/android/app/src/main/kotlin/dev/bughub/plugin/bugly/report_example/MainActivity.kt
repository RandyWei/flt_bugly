package dev.bughub.plugin.bugly.report_example

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import java.lang.NullPointerException

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.i("1111","1111")
        throw NullPointerException()
        Log.i("2222","2222")
    }
}
