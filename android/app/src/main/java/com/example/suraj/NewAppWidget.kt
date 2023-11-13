package com.example.suraj

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider
import android.util.Log

class NewAppWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { appWidgetId ->
            updateAppWidget(context, appWidgetManager, appWidgetId)
            // Log.d("NewAppWidget", "onCreate");
        }
    }

 
}


internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    val widgetText = loadTitlePref(context, appWidgetId)
    // Log.d("NewAppWidget2", "$widgetText")
    val widgetData= context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
    var value=widgetData.getInt(widgetText, 0)
    val views = RemoteViews(context.packageName, R.layout.new_app_widget)

    views.setTextViewText(R.id.appwidget_text, widgetText)
    views.setTextViewText(R.id.text_counter, value.toString())

                // Create unique URIs for each widget
             val incrementUri = Uri.parse("homeWidgetCounter://increment_$widgetText")
                val clearUri = Uri.parse("homeWidgetCounter://clear_$widgetText")

                // Create unique PendingIntents for each widget
                val incrementIntent =
                    HomeWidgetBackgroundIntent.getBroadcast(context, incrementUri)
                
                val clearIntent = HomeWidgetBackgroundIntent.getBroadcast(context, clearUri)

                // Set onClickPendingIntents
                views.setOnClickPendingIntent(R.id.button_increment, incrementIntent)
                views.setOnClickPendingIntent(R.id.button_clear, clearIntent)
    
    appWidgetManager.updateAppWidget(appWidgetId, views)
}