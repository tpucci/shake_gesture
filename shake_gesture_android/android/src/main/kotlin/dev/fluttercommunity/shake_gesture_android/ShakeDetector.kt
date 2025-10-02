package dev.fluttercommunity.shake_gesture_android

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import java.util.concurrent.TimeUnit
import android.util.Log

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
    val customShakeForce = context.packageManager.getApplicationInfo(
        context.packageName,
        PackageManager.GET_META_DATA
    ).metaData.get("dev.fluttercommunity.shake_gesture_android.SHAKE_FORCE")

    val SHAKE_FORCE: Float = when (customShakeForce) {
        is Int -> customShakeForce.toFloat()
        is Float -> customShakeForce
        else -> 6f
    }

    private val REQUIRED_FORCE_SQUARED = SensorManager.GRAVITY_EARTH * SensorManager.GRAVITY_EARTH + SHAKE_FORCE * SHAKE_FORCE

    // Current acceleration values
    private var mAccelerationX = 0f
    private var mAccelerationY = 0f
    private var mAccelerationZ = 0f

    // Previous acceleration values for direction change detection
    private var mPrevAccelerationX = 0f
    private var mPrevAccelerationY = 0f
    private var mPrevAccelerationZ = 0f

    // Track the last direction of movement for each axis
    private var mLastDirectionX = 0 // -1, 0, 1 for negative, none, positive
    private var mLastDirectionY = 0
    private var mLastDirectionZ = 0

    private var mLastTimestamp: Long = 0
    private var mNumShakes = 0
    private var mLastShakeTimestamp: Long = 0

    // number of shakes required to trigger onShake()
    private val mMinNumShakes = context.packageManager.getApplicationInfo(context.packageName, PackageManager.GET_META_DATA).metaData.getInt("dev.fluttercommunity.shake_gesture_android.MIN_NUM_SHAKES", 6)

    init {
        Log.v("ShakeDetector", "Required shake force is $SHAKE_FORCE")
        Log.v("ShakeDetector", "Minimum number of shakes is $mMinNumShakes")
    }

    /** Reset all variables used to keep track of number of shakes recorded.  */
    private fun reset() {
        mNumShakes = 0
        mAccelerationX = 0f
        mAccelerationY = 0f
        mAccelerationZ = 0f
        mPrevAccelerationX = 0f
        mPrevAccelerationY = 0f
        mPrevAccelerationZ = 0f
        mLastDirectionX = 0
        mLastDirectionY = 0
        mLastDirectionZ = 0
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

    /**
     * Determine the direction of movement for a given acceleration value
     *
     * @param acceleration current acceleration value
     * @param threshold minimum threshold to consider as movement
     * @return -1 for negative direction, 1 for positive direction, 0 for no significant movement
     */
    private fun getDirection(acceleration: Float, threshold: Float = 1.0f): Int {
        return when {
            acceleration > threshold -> 1
            acceleration < -threshold -> -1
            else -> 0
        }
    }

    /**
     * Check if there's a direction change between previous and current acceleration
     * A direction change occurs when the sign changes and both values have significant magnitude
     *
     * @param current current acceleration value
     * @param previous previous acceleration value
     * @param lastDirection the last recorded direction for this axis
     * @return true if there's a valid direction change
     */
    private fun hasDirectionChange(current: Float, previous: Float, lastDirection: Int): Boolean {
        val currentDirection = getDirection(current)

        // Only count as direction change if:
        // 1. Current direction is non-zero (significant movement)
        // 2. Current direction is opposite to last recorded direction
        // 3. There was a previous direction recorded
        return currentDirection != 0 && lastDirection != 0 && currentDirection == -lastDirection
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

        // Only process if we have enough force
        if (atLeastRequiredForce(acceleration)) {
            var shakeDetected = false

            // Check X-axis for direction change
            if (hasDirectionChange(ax, mPrevAccelerationX, mLastDirectionX)) {
                recordShake(mLastTimestamp)
                shakeDetected = true
            }

            // Check Y-axis for direction change
            if (hasDirectionChange(ay, mPrevAccelerationY, mLastDirectionY)) {
                recordShake(mLastTimestamp)
                shakeDetected = true
            }

            // Check Z-axis for direction change
            if (hasDirectionChange(az, mPrevAccelerationZ, mLastDirectionZ)) {
                recordShake(mLastTimestamp)
                shakeDetected = true
            }

            // Update direction tracking only when we have significant movement
            val currentDirectionX = getDirection(ax)
            val currentDirectionY = getDirection(ay)
            val currentDirectionZ = getDirection(az)

            if (currentDirectionX != 0) mLastDirectionX = currentDirectionX
            if (currentDirectionY != 0) mLastDirectionY = currentDirectionY
            if (currentDirectionZ != 0) mLastDirectionZ = currentDirectionZ
        }

        // Update previous values for next comparison
        mPrevAccelerationX = mAccelerationX
        mPrevAccelerationY = mAccelerationY
        mPrevAccelerationZ = mAccelerationZ

        // Update current values
        mAccelerationX = ax
        mAccelerationY = ay
        mAccelerationZ = az

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
