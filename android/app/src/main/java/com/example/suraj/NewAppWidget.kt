package com.example.suraj

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import androidx.recyclerview.widget.LinearLayoutManager
import es.antonborri.home_widget.HomeWidgetProvider
import android.util.Log
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import androidx.recyclerview.widget.RecyclerView
import android.app.PendingIntent

class NewAppWidget : AppWidgetProvider() {    
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { appWidgetId ->updateAppWidget(context, appWidgetManager, appWidgetId)
            
        }
    }
}


internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    val widgetText = loadTitlePref(context, appWidgetId)
    val widgetData= context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

    val texa = getvalue(context,"mapKey")
        
    val mapstr = texa.split("|")[0] 
    val mapType = object : TypeToken<Map<String, Any>>() {}.type
    val gson = Gson()
    val map: Map<String, Any> = gson.fromJson(mapstr, mapType)

    val listofmap: List<String> = map[widgetText] as? List<String> ?: arrayListOf(widgetText)
    
    var value=widgetData.getInt(listofmap[0], 0)
    var stepvalue=widgetData.getInt("${listofmap[0]}stepsize",1)
    val views = RemoteViews(context.packageName, R.layout.new_app_widget)

    views.setTextViewText(R.id.appwidget_text, listofmap[0])
    views.setTextViewText(R.id.text_counter, value.toString())
    views.setTextViewText(R.id.text_stepcounter, stepvalue.toString())
    views.setTextViewText(R.id.tv_counter, "Stepsize")


    // Create unique URIs for each widget
    val incrementUri = Uri.parse("homeWidgetCounter://increment_${listofmap[0]}")
    val stepincrementUri = Uri.parse("homeWidgetCounter://stepincrement_${listofmap[0]}")
    val decrementUri = Uri.parse("homeWidgetCounter://decrement_${listofmap[0]}")
    val stepdecrementUri = Uri.parse("homeWidgetCounter://stepdecrement_${listofmap[0]}")
    val clearUri = Uri.parse("homeWidgetCounter://clear_${listofmap[0]}")

    // Create unique PendingIntents for each widget
    val incrementIntent = HomeWidgetBackgroundIntent.getBroadcast(context, incrementUri)
    val stepincrementIntent = HomeWidgetBackgroundIntent.getBroadcast(context, stepincrementUri)
    val decrementIntent = HomeWidgetBackgroundIntent.getBroadcast(context, decrementUri)
    val stepdecrementIntent =HomeWidgetBackgroundIntent.getBroadcast(context, stepdecrementUri)            
    val clearIntent = HomeWidgetBackgroundIntent.getBroadcast(context, clearUri)

    // Set onClickPendingIntents
    views.setOnClickPendingIntent(R.id.button_increment, incrementIntent)
    views.setOnClickPendingIntent(R.id.button_stepincrement, stepincrementIntent)
    views.setOnClickPendingIntent(R.id.button_decrement, decrementIntent)
    views.setOnClickPendingIntent(R.id.button_stepdecrement, stepdecrementIntent)
    views.setOnClickPendingIntent(R.id.button_clear, clearIntent)
    appWidgetManager.updateAppWidget(appWidgetId, views)
} 

 


