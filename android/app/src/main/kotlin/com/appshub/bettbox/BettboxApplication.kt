package com.appshub.bettbox

import android.app.Application
import android.content.Context
import android.os.Build

import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngineGroup

class BettboxApplication : Application() {
    companion object {
        private lateinit var instance: BettboxApplication
        fun getAppContext(): Context = instance.applicationContext
        private const val PREF_KEY_LAST_VERSION_CODE = "last_app_version_code"
    }

    lateinit var engineGroup: FlutterEngineGroup

    override fun onCreate() {
        super.onCreate()
        instance = this
        cleanEngineCacheOnVersionChange()
        FlutterInjector.instance().flutterLoader().startInitialization(this)
        engineGroup = FlutterEngineGroup(this)
    }

    private fun cleanEngineCacheOnVersionChange() {
        try {
            val prefs = getSharedPreferences("engine_cache_version", MODE_PRIVATE)
            val currentVersionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                packageManager.getPackageInfo(packageName, 0).longVersionCode
            } else {
                @Suppress("DEPRECATION")
                packageManager.getPackageInfo(packageName, 0).versionCode.toLong()
            }
            val lastVersionCode = prefs.getLong(PREF_KEY_LAST_VERSION_CODE, 0L)
            if (lastVersionCode != 0L && lastVersionCode != currentVersionCode) {
                android.util.Log.i(
                    "BettboxApplication",
                    "Version changed: $lastVersionCode -> $currentVersionCode, clearing engine cache"
                )
                cacheDir.listFiles()?.forEach { file ->
                    if (file.name.contains("flutter") || file.name.contains("sk")) {
                        file.deleteRecursively()
                    }
                }
                codeCacheDir.listFiles()?.forEach { file ->
                    if (file.name.contains("flutter")) {
                        file.deleteRecursively()
                    }
                }
            }
            prefs.edit().putLong(PREF_KEY_LAST_VERSION_CODE, currentVersionCode).apply()
        } catch (e: Exception) {
            android.util.Log.w("BettboxApplication", "Failed to clean engine cache", e)
        }
    }
}
