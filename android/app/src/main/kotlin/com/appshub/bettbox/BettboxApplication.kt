package com.appshub.bettbox

import android.app.Application
import android.content.Context

class BettboxApplication : Application() {
    companion object {
        private lateinit var instance: BettboxApplication
        fun getAppContext(): Context = instance.applicationContext
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
    }
}
