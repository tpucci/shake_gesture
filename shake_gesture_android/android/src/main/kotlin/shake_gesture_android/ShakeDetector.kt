package shake_gesture_android

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.util.Log
import java.util.concurrent.TimeUnit
import kotlin.math.abs

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
        TimeUnit.NANOSECONDS.convert(20, TimeUnit.MILLISECONDS)

    // Number of nanoseconds to listen for and count shakes (nanoseconds)
    private val SHAKING_WINDOW_NS = TimeUnit.NANOSECONDS.convert(3, TimeUnit.SECONDS)

    // Required force to constitute a rage shake. Need to multiply gravity by 1.33 because a rage
    // shake in one direction should have more force than just the magnitude of free fall.
    private val REQUIRED_FORCE = SensorManager.GRAVITY_EARTH * 1.33f

    private var mAccelerationX = 0f
    private  var mAccelerationY = 0f
    private  var mAccelerationZ = 0f

    private var mLastTimestamp: Long = 0
    private var mNumShakes = 0
    private var mLastShakeTimestamp: Long = 0

    // number of shakes required to trigger onShake()
    private val mMinNumShakes = 1

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
     * @param a acceleration in x, y, or z applied to the sensor
     * @return true if the magnitude of the force exceeds the minimum required amount of force. false
     * otherwise.
     */
    private fun atLeastRequiredForce(a: Float): Boolean {
        return abs(a) > REQUIRED_FORCE
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
        if (atLeastRequiredForce(ax) && ax * mAccelerationX <= 0) {
            recordShake(mLastTimestamp)
            mAccelerationX = ax
        } else if (atLeastRequiredForce(ay) && ay * mAccelerationY <= 0) {
            recordShake(mLastTimestamp)
            mAccelerationY = ay
        } else if (atLeastRequiredForce(az) && az * mAccelerationZ <= 0) {
            recordShake(mLastTimestamp)
            mAccelerationZ = az
        }
        maybeDispatchShake(mLastTimestamp)
    }

    private fun maybeDispatchShake(currentTimestamp: Long) {
        if (mNumShakes >= 6 * mMinNumShakes) {
            reset()
            listener.onShake()
        }
        if (currentTimestamp - mLastShakeTimestamp > SHAKING_WINDOW_NS) {
            reset()
        }
    }
}