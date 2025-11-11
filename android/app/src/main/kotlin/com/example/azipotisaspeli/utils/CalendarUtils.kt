package com.example.azipotisaspeli.utils

import android.content.Context
import org.json.JSONObject
import java.io.IOException
import java.util.*

object CalendarUtils {

    fun isHolidayToday(context: Context): Boolean {
        val calendar = Calendar.getInstance()
        val dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK)

        // Duminica
        if (dayOfWeek == Calendar.SUNDAY) return true

        // Citim din JSON doar dacă vrei și alte sărbători
        try {
            val jsonString = context.assets.open("ORTHODOX_CALENDAR_2025.json")
                .bufferedReader().use { it.readText() }
            val data = JSONObject(jsonString)
            val month = (calendar.get(Calendar.MONTH) + 1).toString()
            val day = calendar.get(Calendar.DAY_OF_MONTH).toString()

            if (data.has(month)) {
                val arr = data.getJSONArray(month)
                for (i in 0 until arr.length()) {
                    val obj = arr.getJSONObject(i)
                    if (obj.getString("date") == day && obj.optBoolean("isHoliday", false)) {
                        return true
                    }
                }
            }
        } catch (_: IOException) { }

        return false
    }
}
