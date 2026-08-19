package com.quanneggaes4d.plugin.settings

import android.content.Context

/**
 * ANGLE is now bundled directly inside the APK.
 * No launcher scanning needed — the .so files live next to libquanneggaes4d.so
 * and are resolved at runtime via dladdr in the native loader.
 */
data class AngleSource(
    val packageName: String,
    val label: String,
    val versionName: String?,
    val libraryDir: String,
)

object AngleProvider {

    const val GLES_LIBRARY = "libGLESv2_angle.so"
    const val EGL_LIBRARY = "libEGL_angle.so"

    /**
     * Returns a single built-in source representing the bundled ANGLE.
     * The empty libraryDir tells the native loader to use its own directory (dladdr path).
     */
    fun sources(context: Context): List<AngleSource> = listOf(
        AngleSource(
            packageName = context.packageName,
            label = "QUANNEGGAES4D (bundled)",
            versionName = null,
            libraryDir = "",   // empty = native loader uses dladdr to find its own dir
        )
    )

    /** Bundled ANGLE is always available. */
    fun hasAngle(directory: String?): Boolean = true
}
