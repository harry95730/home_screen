package com.example.suraj

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.os.SystemClock
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.content.SharedPreferences
import com.google.gson.Gson
import android.widget.Toast
import com.google.gson.reflect.TypeToken
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider

import android.net.Uri

class ExampleWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsService.RemoteViewsFactory {
        return ExampleWidgetItemFactory(applicationContext, intent)
    }
}

class ExampleWidgetItemFactory(private val context: Context, intent: Intent) :
    RemoteViewsService.RemoteViewsFactory {

    private val appWidgetId: Int = intent.getIntExtra(
        AppWidgetManager.EXTRA_APPWIDGET_ID,
        AppWidgetManager.INVALID_APPWIDGET_ID
    )
    
    

    private var listofmap: List<String> = retrieveDataFromPreferences()

    private fun retrieveDataFromPreferences(): List<String> {
        val widgetText = loadTitlePref(context, appWidgetId)
        val widgetData = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val texa = getvalue(context, "mapKey")

        val mapstr = texa.split("|")[0]

        val mapType = object : TypeToken<Map<String, Any>>() {}.type

        val gson = Gson()

        val map: Map<String, Any> = gson.fromJson(mapstr, mapType)

        return map[widgetText] as? List<String> ?: listOf(widgetText)
    }

    override fun onCreate() {
        listofmap=retrieveDataFromPreferences();
    }

    override fun onDataSetChanged() {
        listofmap=retrieveDataFromPreferences();
    }

    override fun onDestroy() {
        // Close data source
    }

    override fun getCount(): Int {
        return listofmap.size
    }
    

    override fun getViewAt(position: Int): RemoteViews {
        val widgetText =listofmap[position]
        val widgetData= context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        var value=widgetData.getInt(listofmap[position], 0)
        var stepvalue=widgetData.getInt("${listofmap[position]}stepsize",1)

        val views = RemoteViews(context.packageName, R.layout.example_widget_item)
        views.setTextViewText(R.id.appwidget_text, listofmap[position])
        views.setTextViewText(R.id.text_counter, value.toString())
        views.setTextViewText(R.id.text_stepcounter, stepvalue.toString())
        views.setTextViewText(R.id.tv_counter, "Stepsize")
       
        
        val defillIntent = Intent().apply {
            putExtra(EXTRA_ITEM_POSITION, position)
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("value", 0)
            putExtra("widgettext", widgetText)
        }
        
        val refillIntent = Intent().apply {
            putExtra(EXTRA_ITEM_POSITION, position)
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("widgettext", widgetText)
            putExtra("value", 1)
        }

        val infillIntent = Intent().apply {
            putExtra(EXTRA_ITEM_POSITION, position)
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("value", 2)
            putExtra("widgettext", widgetText)
        }

        

        val sdfillIntent = Intent().apply {
            putExtra(EXTRA_ITEM_POSITION, position)
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("widgettext", widgetText)
            putExtra("value", 3)
        }

        val sifillIntent = Intent().apply {
            putExtra(EXTRA_ITEM_POSITION, position)
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("widgettext", widgetText)
            putExtra("value", 4)
        }

        
        views.setOnClickFillInIntent(R.id.button_decrement, defillIntent)
        views.setOnClickFillInIntent(R.id.button_increment, infillIntent)
        views.setOnClickFillInIntent(R.id.button_clear, refillIntent)
        views.setOnClickFillInIntent(R.id.button_stepdecrement, sdfillIntent)
        views.setOnClickFillInIntent(R.id.button_stepincrement, sifillIntent)

        
        return views
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }
}
