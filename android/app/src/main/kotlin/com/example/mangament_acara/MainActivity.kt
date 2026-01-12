package com.example.mangament_acara

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Setup method channel for camera permissions if needed
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mangament_acara/camera").setMethodCallHandler { call, result ->
            when (call.method) {
                "checkPermission" -> {
                    // Handle permission check if needed
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
