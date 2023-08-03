package shake_gesture_android.example

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import shake_gesture_android.ShakeGesturePlugin

class MainActivity: FlutterActivity() {
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_MENU) {
            this.flutterEngine?.plugins?.get(ShakeGesturePlugin::class.java).let { plugin ->
                if (plugin is ShakeGesturePlugin)
                    plugin.onShake()
            }
        }

        return super.onKeyDown(keyCode, event)
    }
}
