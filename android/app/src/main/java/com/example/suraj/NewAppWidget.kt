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
import android.content.Intent
import android.widget.Toast
import android.app.PendingIntent
import android.os.Build

const val ACTION_TOAST = "actionToast"
const val EXTRA_ITEM_POSITION = "extraItemPosition"
const val ACTION_REFRESH = "actionRefresh"

class NewAppWidget : AppWidgetProvider() {
  
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { appWidgetId ->updateAppWidget(context, appWidgetManager, appWidgetId)
            // Log.d("NewAppWidget", "onCreate");
        }
    }

     override fun onReceive(context: Context, intent: Intent) {
        
            if (ACTION_TOAST == intent.action) {

                val clickedPosition = intent.getIntExtra(EXTRA_ITEM_POSITION, 0)
                val clickedaction = intent.getIntExtra("value", 5)
                val widgetText = intent.getStringExtra("widgettext")

                if (clickedaction == 0) {
                    val decrementUri = Uri.parse("homeWidgetCounter://decrement_$widgetText")
                    val decrementIntent = HomeWidgetBackgroundIntent.getBroadcast(context, decrementUri)
                    decrementIntent.send()
                    val display="decresed"
                    Toast.makeText(context, "$widgetText \n$display", Toast.LENGTH_SHORT).show()
                }
                if (clickedaction == 1){
                    val clearUri = Uri.parse("homeWidgetCounter://clear_$widgetText")
                    val clearIntent = HomeWidgetBackgroundIntent.getBroadcast(context, clearUri)
                    clearIntent.send()
                    val display="reseted"
                    Toast.makeText(context, "$widgetText \n$display", Toast.LENGTH_SHORT).show()
                }
                if (clickedaction == 2) {
                    val incrementUri = Uri.parse("homeWidgetCounter://increment_$widgetText")
                    val incrementIntent = HomeWidgetBackgroundIntent.getBroadcast(context, incrementUri)
                    incrementIntent.send()
                    val display="incresed"
                    Toast.makeText(context, "$widgetText \n$display", Toast.LENGTH_SHORT).show()
                }
                if (clickedaction == 3) {
                    val stepdecrementUri = Uri.parse("homeWidgetCounter://stepdecrement_$widgetText")   
                    val stepdecrementIntent =HomeWidgetBackgroundIntent.getBroadcast(context, stepdecrementUri)  
                    stepdecrementIntent.send()
                    val display="step decresed"
                    Toast.makeText(context, "$widgetText \n$display", Toast.LENGTH_SHORT).show()
                }
                if (clickedaction == 4) {
                    val stepincrementUri = Uri.parse("homeWidgetCounter://stepincrement_$widgetText")
                    val stepincrementIntent = HomeWidgetBackgroundIntent.getBroadcast(context, stepincrementUri)
                    stepincrementIntent.send()
                    val display="step incresed"
                    Toast.makeText(context, "$widgetText \n$display", Toast.LENGTH_SHORT).show()
                }
                if (clickedaction == 5) {
                    val stepincrementUri = Uri.parse("homeWidgetCounter://stepincrement_$widgetText")
                    val stepincrementIntent = HomeWidgetBackgroundIntent.getBroadcast(context, stepincrementUri)
                    stepincrementIntent.send()
                    val display="step incresed"
                    Toast.makeText(context, "$widgetText \n$display", Toast.LENGTH_SHORT).show()
                }
                
                val appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)
                val appWidgetManager = AppWidgetManager.getInstance(context)
                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.example_widget_stack_view)
            }
        super.onReceive(context, intent)
    }
}


internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    val widgetText = loadTitlePref(context, appWidgetId)
    val widgetData= context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
    
    
    val views = RemoteViews(context.packageName, R.layout.new_app_widget)

    val serviceIntent = Intent(context, ExampleWidgetService::class.java).apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
        }

        val clickIntent = Intent(context, NewAppWidget::class.java).apply {
            action = ACTION_TOAST
        }
        val flags = if (Build.VERSION.SDK_INT >= 23) {
            PendingIntent.FLAG_MUTABLE
            } else {
                0
            }
            val clickPendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                clickIntent,
                flags
            )

    val intent = Intent(context, ExampleWidgetService::class.java)
    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
    intent.data = Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME))
    val incrementUri = Uri.parse("homeWidgetCounter://increment_$widgetText")
    val incrementIntent = HomeWidgetBackgroundIntent.getBroadcast(context, incrementUri)
    views.setOnClickPendingIntent(R.id.button_increment, incrementIntent)
    
    views.setRemoteAdapter(R.id.example_widget_stack_view, intent)
    views.setEmptyView(R.id.example_widget_stack_view, R.id.example_widget_empty_view)
    views.setPendingIntentTemplate(R.id.example_widget_stack_view, clickPendingIntent)

    appWidgetManager.updateAppWidget(appWidgetId, views)
    appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.example_widget_stack_view)
}