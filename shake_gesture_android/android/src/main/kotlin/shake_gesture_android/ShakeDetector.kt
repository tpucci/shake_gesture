package shake_gesture_android

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import kotlin.math.sqrt

class ShakeDetector(context: Context, private val listener: OnShakeListener) : SensorEventListener {

    // Minimum shake force to register as a shake event
    private val MIN_SHAKE_FORCE = 5.0f

    // Time threshold between two shake events (in milliseconds)
    private val SHAKE_TIME_THRESHOLD = 500

    private var lastShakeTime: Long = 0

    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null

    init {
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    }

    interface OnShakeListener {
        fun onShake()
    }

    fun start() {
        sensorManager?.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL)
    }

    fun stop() {
        sensorManager?.unregisterListener(this)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not used
    }

    override fun onSensorChanged(event: SensorEvent) {
        val now = System.currentTimeMillis()

        if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {
            val x = event.values[0]
            val y = event.values[1]
            val z = event.values[2]

            val acceleration = sqrt((x * x + y * y + z * z).toDouble()).toFloat()

            if (acceleration > MIN_SHAKE_FORCE) {
                if (now - lastShakeTime >= SHAKE_TIME_THRESHOLD) {
                    lastShakeTime = now
                    listener.onShake()
                }
            }
        }
    }
}