package com.quanneggaes4d.plugin

import java.io.File

object QNGInfoGetter {

    init {
        System.loadLibrary("quanneggaes4d_info_getter")
    }

    external fun setenv(key: String, value: String, overwrite: Int): Int

    external fun getQuanneggaes4dGLInfo(): String

    /**
     * 查询 QUANNEGGAES4D 的 GL 信息。
     *
     * 这是一个阻塞调用：native 侧会 dlopen libquanneggaes4d 并创建 EGL 上下文，必须放在后台线程。
     * [mgDirectory] 显式传入，而不是像以前那样从一个可变静态字段里读。
     */
    /**
     * @param angleDirectory 借来的 ANGLE 所在目录（某个启动器的 native 库目录）；
     *   null = 不借。配置若要求 ANGLE 而这里不借，渲染器会退回系统驱动，那这份信息
     *   讲的就不是游戏里的那个驱动了。
     */
    fun info(mgDirectory: File, angleDirectory: String? = null): String = try {
        // 这里不设 QNG_COUNT_LAUNCH：我们自己把渲染器加载起来问一句话，不是一次「启动」。
        setenv("QNG_PLUGIN_STATUS", "1", 1)
        setenv("QNG_DIR_PATH", mgDirectory.path, 1)
        // 空串等于没设：渲染器那边只认非空值，游戏进程里本来也不会有这个变量。
        setenv("QNG_ANGLE_DIR", angleDirectory.orEmpty(), 1)
        getQuanneggaes4dGLInfo()
    } catch (e: Throwable) {
        "Error: ${e.message}"
    }
}
