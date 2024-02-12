package dev.fluttercommunity.shake_gesture_android

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import java.util.concurrent.TimeUnit

class ShakeDetector(context: Context, private val listener: OnShakeListener) : SensorEventListener {

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

    // Collect sensor data in this interval (nanoseconds)
    private val MIN_TIME_BETWEEN_SAMPLES_NS =
        TimeUnit.NANOSECONDS.convert(15, TimeUnit.MILLISECONDS)

    // Number of nanoseconds to listen for and count shakes (nanoseconds)
    private val SHAKING_WINDOW_NS = TimeUnit.NANOSECONDS.convert(200, TimeUnit.MILLISECONDS)

    // Required force to constitute a shake.
    private val SHAKE_FORCE = context.packageManager.getApplicationInfo(context.packageName, PackageManager.GET_META_DATA).metaData.getFloat("dev.fluttercommunity.shake_gesture_android.SHAKE_FORCE",  6f)
    private val REQUIRED_FORCE_SQUARED = SensorManager.GRAVITY_EARTH * SensorManager.GRAVITY_EARTH + SHAKE_FORCE * SHAKE_FORCE

    private var mAccelerationX = 0f
    private  var mAccelerationY = 0f
    private  var mAccelerationZ = 0f

    private var mLastTimestamp: Long = 0
    private var mNumShakes = 0
    private var mLastShakeTimestamp: Long = 0

    // number of shakes required to trigger onShake()
    private val mMinNumShakes = context.packageManager.getApplicationInfo(context.packageName, PackageManager.GET_META_DATA).metaData.getInt("dev.fluttercommunity.shake_gesture_android.MIN_NUM_SHAKES", 6)

    /** Reset all variables used to keep track of number of shakes recorded.  */
    private fun reset() {
        mNumShakes = 0
        mAccelerationX = 0f
        mAccelerationY = 0f
        mAccelerationZ = 0f
    }

    /**
     * Determine if acceleration applied to sensor is large enough to count as a rage shake.
     *
     * @param a acceleration squared
     * @return true if the magnitude of the force exceeds the minimum required amount of force. false
     * otherwise.
     */
    private fun atLeastRequiredForce(a: Float): Boolean {
        return a > REQUIRED_FORCE_SQUARED
    }

    /**
     * Save data about last shake
     *
     * @param timestamp (ns) of last sensor event
     */
    private fun recordShake(timestamp: Long) {
        mLastShakeTimestamp = timestamp
        mNumShakes++
    }

    override fun onSensorChanged(sensorEvent: SensorEvent) {
        if (sensorEvent.timestamp - mLastTimestamp < MIN_TIME_BETWEEN_SAMPLES_NS) {
            return
        }
        val ax = sensorEvent.values[0]
        val ay = sensorEvent.values[1]
        val az = sensorEvent.values[2]

        mLastTimestamp = sensorEvent.timestamp
        processAccelerationData(ax, ay, az)
    }

    fun processAccelerationData(ax: Float, ay: Float, az: Float) {
        val acceleration = ax * ax + ay * ay + az * az
        if (atLeastRequiredForce(acceleration) && ax * mAccelerationX <= 0) {
            recordShake(mLastTimestamp)
            mAccelerationX = ax
        } else if (atLeastRequiredForce(acceleration) && ay * mAccelerationY <= 0) {
            recordShake(mLastTimestamp)
            mAccelerationY = ay
        } else if (atLeastRequiredForce(acceleration) && az * mAccelerationZ <= 0) {
            recordShake(mLastTimestamp)
            mAccelerationZ = az
        }
        maybeDispatchShake(mLastTimestamp)
    }

    private fun maybeDispatchShake(currentTimestamp: Long) {
        if (mNumShakes >= mMinNumShakes) {
            reset()
            listener.onShake()
        }
        if (currentTimestamp - mLastShakeTimestamp > SHAKING_WINDOW_NS) {
            reset()
        }
    }
}
