# QUANNEGGAES4D

**QUANNEGGAES4D**, which stands for "(on) Mobile, GL uses ES", is a GL implementation running on top of host OpenGL ES 3.x (best on 3.2, minimum 3.0), with running Minecraft: Java Edition in mind.

# For Shader Developers

1. QUANNEGGAES4D automatically:
   - Converts desktop GLSL → GLSL ES
   - Removes `layout(binding)` syntax
   - Handles version directives
   - Always declare precision explicitly:
     ```glsl
     precision highp float;
     precision highp int;
     ```

2. QUANNEGGAES4D (since V1.2.6) injects these macros into your shaders:
   ```glsl
   #define MG_QUANNEGGAES4D                   // Indicates QUANNEGGAES4D environment
   #define MG_QUANNEGGAES4D_VERSION 1260      // Version number (e.g. 1260 = V1.2.6)
   ```

   Use these macros for platform-specific logic:
   ```glsl
   #ifdef MG_QUANNEGGAES4D
       #if MG_QUANNEGGAES4D_VERSION >= 1270
           // Logic for QUANNEGGAES4D (version >= V1.2.7)
       #else
           // Logic for QUANNEGGAES4D (version < V1.2.7)
       #endif
   #else
       // ...
   #endif
   ```

3. If encountering issues:
   - Enable `Ignore shader/program error`, and check the logs (located at `/sdcard/QNG/latest.log`).

# License

QUANNEGGAES4D is licensed under **GNU LGPL-2.1 License**.

Please see [LICENSE](https://github.com/MobileGL-Dev/QUANNEGGAES4D/blob/main/LICENSE).

# Third-party components

**SPIRV-Cross** by **KhronosGroup** - [Apache License 2.0](https://github.com/KhronosGroup/SPIRV-Cross/blob/master/LICENSE): [github](https://github.com/KhronosGroup/SPIRV-Cross)

**glslang** by **KhronosGroup** - [Various Licenses](https://github.com/KhronosGroup/glslang/blob/main/LICENSE.txt): [github](https://github.com/KhronosGroup/glslang)

**cJSON** by **DaveGamble** - [MIT License](https://github.com/DaveGamble/cJSON/blob/master/LICENSE): [github](https://github.com/DaveGamble/cJSON)

**FidelityFX-FSR** by **AMD** - [MIT License](https://github.com/GPUOpen-Effects/FidelityFX-FSR/blob/master/license.txt): [github](https://github.com/GPUOpen-Effects/FidelityFX-FSR) 

**Perfetto** by **Google** - [Apache License 2.0](https://github.com/google/perfetto/blob/main/LICENSE): [github](https://github.com/google/perfetto)

**xxHash** by **Yann Collet** - [BSD 2-Clause License](https://github.com/Cyan4973/xxHash/blob/dev/LICENSE): [github](https://github.com/Cyan4973/xxHash)

**flat_hash_map** by **Malte Skarupke** - [Boost Software License 1.0](https://github.com/MobileGL-Dev/flat_hash_map/blob/master/LICENSE): [github](https://github.com/MobileGL-Dev/flat_hash_map) (fork of [skarupke/flat_hash_map](https://github.com/skarupke/flat_hash_map), carrying a fix that lets the header be included on 32-bit targets)
