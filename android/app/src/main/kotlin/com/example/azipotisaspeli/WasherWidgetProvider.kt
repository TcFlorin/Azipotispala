package com.example.azipotisaspeli

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.widget.RemoteViews

class WasherWidgetProvider : AppWidgetProvider() {

    private val frameList = listOf(
        R.drawable.anim0,
        R.drawable.anim1,
        R.drawable.anim2,
        R.drawable.anim3,
        R.drawable.anim4
    )

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (id in appWidgetIds) {
            val layoutId = getLayoutForSize(context, appWidgetManager, id)
            val views = RemoteViews(context.packageName, layoutId)

            views.setImageViewResource(R.id.widget_icon, R.drawable.iconw)

            // click pe widget
            val intent = Intent(context, WasherWidgetProvider::class.java).apply {
                action = "WIDGET_CLICK"
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_icon, pendingIntent)
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "WIDGET_CLICK") {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val ids = appWidgetManager.getAppWidgetIds(
                ComponentName(context, WasherWidgetProvider::class.java)
            )

            // Start animation
            animateFrames(context, appWidgetManager, ids, 0)
        }
    }
    
    // 🔹 Resize handler 
    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: android.os.Bundle
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)

        // Reset icon and click action on resize
        val layoutId = getLayoutForSize(context, appWidgetManager, appWidgetId)
        val views = RemoteViews(context.packageName, layoutId)
        views.setImageViewResource(R.id.widget_icon, R.drawable.iconw)

        val intent = Intent(context, WasherWidgetProvider::class.java).apply {
            action = "WIDGET_CLICK"
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            appWidgetId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_icon, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun animateFrames(
        context: Context,
        manager: AppWidgetManager,
        ids: IntArray,
        frameIndex: Int
    ) {
        if (frameIndex >= frameList.size) {
            // După animație afișează rezultatul final
            val resultRes = if (checkIfHoliday()) R.drawable.washred else R.drawable.washgreen
            for (id in ids) {
                val layoutId = getLayoutForSize(context, manager, id)
                val views = RemoteViews(context.packageName, layoutId)
                views.setImageViewResource(R.id.widget_icon, resultRes)
                manager.updateAppWidget(id, views)
            }
            return
        }

        // Afișează frame-ul curent
        for (id in ids) {
            val layoutId = getLayoutForSize(context, manager, id)
            val views = RemoteViews(context.packageName, layoutId)
            views.setImageViewResource(R.id.widget_icon, frameList[frameIndex])
            manager.updateAppWidget(id, views)
        }

        // Frame următor după 300ms
        Handler(Looper.getMainLooper()).postDelayed({
            animateFrames(context, manager, ids, frameIndex + 1)
        }, 300)
    }

    private fun getLayoutForSize(context: Context, manager: AppWidgetManager, widgetId: Int): Int {
    val options = manager.getAppWidgetOptions(widgetId)
    val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
    val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)

    return when {
        minWidth < 50 && minHeight < 50 -> R.layout.widget_small // 1x1
        minWidth < 110 || minHeight < 110 -> R.layout.widget_medium // 1x2 sau 2x1
        else -> R.layout.widget_large // 2x2+
    }


    }


    // Funcție simplă de verificat sărbătoare (exemplu)
    private fun checkIfHoliday(): Boolean {
        val calendar = java.util.Calendar.getInstance()
        val weekday = calendar.get(java.util.Calendar.DAY_OF_WEEK) // 1=Sunday
        return weekday == java.util.Calendar.SUNDAY // duminica = sărbătoare
    }
}
