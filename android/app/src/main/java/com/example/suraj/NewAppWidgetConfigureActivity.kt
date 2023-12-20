package com.example.suraj
import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText
import com.example.suraj.databinding.NewAppWidgetConfigureBinding
import android.widget.Spinner
import android.widget.ArrayAdapter
import android.util.Log
import android.widget.*
import android.widget.RemoteViews
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken



class NewAppWidgetConfigureActivity : Activity() {
    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID
    // private lateinit var appWidgetText: EditText
    private lateinit var spinner: Spinner
    private var onClickListener = View.OnClickListener {
        val context = this@NewAppWidgetConfigureActivity
        // When the button is clicked, store the string locally
        spinner = findViewById(R.id.spinner_options)
        // Get the selected item from the spinner
        val selectedOption = spinner.selectedItem.toString()
        saveTitlePref(context, appWidgetId, selectedOption)
        // Log.d("NewAppWidgetConfigureActivity", selectedOption)

        // It is the responsibility of the configuration activity to update the app widget
        val appWidgetManager = AppWidgetManager.getInstance(context)
        updateAppWidget(context, appWidgetManager, appWidgetId)

        // Make sure we pass back the original appWidgetId
        val resultValue = Intent()
        // Log.d("NewAppWidgetConfigureActivity", resultValue.toString())
        resultValue.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        setResult(RESULT_OK, resultValue)
        finish()
    }

    private lateinit var binding: NewAppWidgetConfigureBinding

    public override fun onCreate(icicle: Bundle?) {
        super.onCreate(icicle)
        setResult(RESULT_CANCELED)
        val context = this@NewAppWidgetConfigureActivity
        binding = NewAppWidgetConfigureBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val intent = intent
        val extras = intent.extras
        if (extras != null) {
            appWidgetId = extras.getInt(
                    AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID)
        }

        // If this activity was started with an intent without an app widget ID, finish with an error.
        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }
        // appWidgetText = binding.appwidgetText as EditText
        binding.addButton.setOnClickListener(onClickListener)
        spinner = findViewById(R.id.spinner_options)
        //val sharedPreference = getvalue(context,"myStringList")
        //var optionsArray = sharedPreference.split("|").toTypedArray()
        val sharedPreference = getvalue(context,"mapKey")
        
        val mapString = sharedPreference.split("|")[0] 
        val mapType = object : TypeToken<Map<String, Any>>() {}.type
        val gson = Gson()
        val map: Map<String, Any> = gson.fromJson(mapString, mapType)

        val optionsArray = map.keys.toList()
        
        val arrayAdapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, optionsArray)
        arrayAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spinner.adapter = arrayAdapter
    }
}

private const val PREFS_NAME = "HomeWidgetPreferences"
private const val PREF_PREFIX_KEY = "appwidget_"

// Write the prefix to the SharedPreferences object for this widget
internal fun saveTitlePref(context: Context, appWidgetId: Int, text: String) {

    val prefs = context.getSharedPreferences(PREFS_NAME, 0).edit()
    prefs.putString(PREF_PREFIX_KEY + appWidgetId, text)
    prefs.apply()
}

// Read the prefix from the SharedPreferences object for this widget.
// If there is no preference saved, get the default from a resource
internal fun loadTitlePref(context: Context, appWidgetId: Int): String {
    val prefs = context.getSharedPreferences(PREFS_NAME, 0)
    val titleValue = prefs.getString(PREF_PREFIX_KEY+appWidgetId, null)
    // Log.d("NewAppWidgetConfigureActivity", "from load title pref $titleValue")
    return titleValue ?: context.getString(R.string.appwidget_text)
}

internal fun getvalue(context: Context, value: String): String {
    val prefs = context.getSharedPreferences(PREFS_NAME, 0)
    val titleValue = prefs.getString(value, null)
    // Log.d("NewAppWidgetConfigureActivity", "from get value $titleValue.toString()")
    return titleValue.toString()
}

internal fun deleteTitlePref(context: Context, appWidgetId: Int) {
    val prefs = context.getSharedPreferences(PREFS_NAME, 0).edit()
    prefs.remove(PREF_PREFIX_KEY + appWidgetId)
    prefs.apply()
}