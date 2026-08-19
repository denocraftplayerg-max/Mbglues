#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "============================================================"
echo " QUANNEGGAES4D - Renomeação Completa Automática"
echo " QUANTIC NEXUS NEXT GENERATION GRAPHIC ENGINE SYSTEM 4D"
echo "============================================================"

# ═══════════════════════════════════════════════════════════
# FASE 0: Verificações
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 0] Verificações..."

if [ ! -d "MobileGlues-cpp" ]; then
    echo "❌ ERRO: MobileGlues-cpp não encontrado. Já foi renomeado?"
    exit 1
fi

command -v python3 >/dev/null 2>&1 || { echo "❌ python3 não encontrado"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "❌ git não encontrado"; exit 1; }

echo "✅ Ambiente OK"

# ═══════════════════════════════════════════════════════════
# FASE 1: Backup git
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 1] Criando backup git..."
git add -A
git commit -m "backup: pre-rename to QUANNEGGAES4D" --allow-empty || true
git tag backup-pre-quanneggaes4d || true
echo "✅ Backup criado (tag: backup-pre-quanneggaes4d)"

# ═══════════════════════════════════════════════════════════
# FASE 2: Renomear diretórios (ordem: mais profundo primeiro)
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 2] Renomeando diretórios..."

# Diretórios Java/Kotlin (package structure)
if [ -d "MobileGlues-plugin/app/src/main/java/com/fcl/plugin/mobileglues" ]; then
    mkdir -p "MobileGlues-plugin/app/src/main/java/com/quanneggaes4d/plugin"
    mv MobileGlues-plugin/app/src/main/java/com/fcl/plugin/mobileglues/* \
       MobileGlues-plugin/app/src/main/java/com/quanneggaes4d/plugin/ 2>/dev/null || true
    rmdir -p MobileGlues-plugin/app/src/main/java/com/fcl/plugin/mobileglues 2>/dev/null || true
    echo "  ✅ main/java renomeado"
fi

if [ -d "MobileGlues-plugin/app/src/main/aidl/com/fcl/plugin/mobileglues" ]; then
    mkdir -p "MobileGlues-plugin/app/src/main/aidl/com/quanneggaes4d/plugin"
    mv MobileGlues-plugin/app/src/main/aidl/com/fcl/plugin/mobileglues/* \
       MobileGlues-plugin/app/src/main/aidl/com/quanneggaes4d/plugin/ 2>/dev/null || true
    rmdir -p MobileGlues-plugin/app/src/main/aidl/com/fcl/plugin/mobileglues 2>/dev/null || true
    echo "  ✅ aidl renomeado"
fi

if [ -d "MobileGlues-plugin/app/src/test/java/com/fcl/plugin/mobileglues" ]; then
    mkdir -p "MobileGlues-plugin/app/src/test/java/com/quanneggaes4d/plugin"
    mv MobileGlues-plugin/app/src/test/java/com/fcl/plugin/mobileglues/* \
       MobileGlues-plugin/app/src/test/java/com/quanneggaes4d/plugin/ 2>/dev/null || true
    rmdir -p MobileGlues-plugin/app/src/test/java/com/fcl/plugin/mobileglues 2>/dev/null || true
    echo "  ✅ test renomeado"
fi

if [ -d "MobileGlues-plugin/app/src/androidTest/java/com/fcl/plugin/mobileglues" ]; then
    mkdir -p "MobileGlues-plugin/app/src/androidTest/java/com/quanneggaes4d/plugin"
    mv MobileGlues-plugin/app/src/androidTest/java/com/fcl/plugin/mobileglues/* \
       MobileGlues-plugin/app/src/androidTest/java/com/quanneggaes4d/plugin/ 2>/dev/null || true
    rmdir -p MobileGlues-plugin/app/src/androidTest/java/com/fcl/plugin/mobileglues 2>/dev/null || true
    echo "  ✅ androidTest renomeado"
fi

# Diretório MG dentro do include C++
if [ -d "MobileGlues-cpp/include/MG" ]; then
    git mv "MobileGlues-cpp/include/MG" "MobileGlues-cpp/include/QNG"
    echo "  ✅ include/MG -> include/QNG"
fi

# Diretório MG dentro do cpp do plugin
if [ -d "MobileGlues-plugin/app/src/main/cpp/MG" ]; then
    git mv "MobileGlues-plugin/app/src/main/cpp/MG" "MobileGlues-plugin/app/src/main/cpp/QNG"
    echo "  ✅ cpp/MG -> cpp/QNG"
fi

# Diretórios principais (por último)
if [ -d "MobileGlues-plugin/MobileGlues" ]; then
    git mv "MobileGlues-plugin/MobileGlues" "MobileGlues-plugin/Quanneggaes4d"
    echo "  ✅ MobileGlues-plugin/MobileGlues -> Quanneggaes4d"
fi

if [ -d "MobileGlues-cpp" ]; then
    git mv "MobileGlues-cpp" "Quanneggaes4d-cpp"
    echo "  ✅ MobileGlues-cpp -> Quanneggaes4d-cpp"
fi

if [ -d "MobileGlues-plugin" ]; then
    git mv "MobileGlues-plugin" "Quanneggaes4d-plugin"
    echo "  ✅ MobileGlues-plugin -> Quanneggaes4d-plugin"
fi

echo "✅ Diretórios renomeados"

# ═══════════════════════════════════════════════════════════
# FASE 3: Renomear arquivos
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 3] Renomeando arquivos..."

rename_file() {
    local dir="$1"
    local old="$2"
    local new="$3"
    if [ -f "$dir/$old" ]; then
        git mv "$dir/$old" "$dir/$new"
        echo "  ✅ $old -> $new"
    fi
}

PLUGIN_CPP="Quanneggaes4d-plugin/app/src/main/cpp"
PLUGIN_JAVA="Quanneggaes4d-plugin/app/src/main/java/com/quanneggaes4d/plugin"
PLUGIN_AIDL="Quanneggaes4d-plugin/app/src/main/aidl/com/quanneggaes4d/plugin"
PLUGIN_SETTINGS="$PLUGIN_JAVA/settings"

# C++ info getter
rename_file "$PLUGIN_CPP" "mobileglues_info_getter.cpp" "quanneggaes4d_info_getter.cpp"
rename_file "$PLUGIN_CPP" "mobileglues_info_getter.h" "quanneggaes4d_info_getter.h"

# Kotlin root
rename_file "$PLUGIN_JAVA" "MGInfoGetter.kt" "QNGInfoGetter.kt"
rename_file "$PLUGIN_JAVA" "MGBench.kt" "QNGBench.kt"
rename_file "$PLUGIN_JAVA" "MGApplication.kt" "QNGApplication.kt"
rename_file "$PLUGIN_JAVA" "MgQuery.kt" "QngQuery.kt"
rename_file "$PLUGIN_JAVA" "MgQueryService.kt" "QngQueryService.kt"

# AIDL
rename_file "$PLUGIN_AIDL" "IMgQuery.aidl" "IQngQuery.aidl"

# Settings
rename_file "$PLUGIN_SETTINGS" "MGCacheExporter.kt" "QNGCacheExporter.kt"
rename_file "$PLUGIN_SETTINGS" "MGConfig.kt" "QNGConfig.kt"
rename_file "$PLUGIN_SETTINGS" "MGConfigCodec.kt" "QNGConfigCodec.kt"
rename_file "$PLUGIN_SETTINGS" "MGConfigStore.kt" "QNGConfigStore.kt"
rename_file "$PLUGIN_SETTINGS" "MgStats.kt" "QngStats.kt"
rename_file "$PLUGIN_SETTINGS" "MgStorage.kt" "QngStorage.kt"

echo "✅ Arquivos renomeados"

# ═══════════════════════════════════════════════════════════
# FASE 4: Substituições de texto (Python - ordenado)
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 4] Aplicando substituições de texto..."

python3 << 'PYEOF'
import os
import sys

# Extensões de texto a processar
TEXT_EXTENSIONS = {
    '.cpp', '.h', '.c', '.hpp', '.cc',
    '.kt', '.kts', '.java', '.aidl',
    '.xml', '.gradle', '.properties', '.toml',
    '.yml', '.yaml', '.json', '.md', '.txt',
    '.py', '.sh', '.pro', '.cmake',
}

# Diretórios a pular
SKIP_DIRS = {
    '.git', 'build', '.gradle', '.cxx',
    '3rdparty', '.idea',
}

# Substituições ORDENADAS (mais específico primeiro)
REPLACEMENTS = [
    # === Nomes de diretórios e paths ===
    ('MobileGlues-cpp', 'Quanneggaes4d-cpp'),
    ('MobileGlues-plugin', 'Quanneggaes4d-plugin'),
    
    # === Package names (antes de substituições genéricas) ===
    ('com.fcl.plugin.mobileglues', 'com.quanneggaes4d.plugin'),
    ('top.mobilegl.mobileglues', 'top.quanneggaes4d.core'),
    
    # === Nomes de arquivos .so ===
    ('libmobileglues_info_getter', 'libquanneggaes4d_info_getter'),
    ('libmobileglues', 'libquanneggaes4d'),
    
    # === JNI function names ===
    ('Java_com_fcl_plugin_mobileglues_MGInfoGetter_getMobileGluesGLInfo', 
     'Java_com_quanneggaes4d_plugin_QNGInfoGetter_getQuanneggaes4dGLInfo'),
    ('Java_com_fcl_plugin_mobileglues_MGInfoGetter_setenv',
     'Java_com_quanneggaes4d_plugin_QNGInfoGetter_setenv'),
    ('Java_com_fcl_plugin_mobileglues_MGBench_runMultidrawBench',
     'Java_com_quanneggaes4d_plugin_QNGBench_runMultidrawBench'),
    ('Java_com_fcl_plugin_mobileglues_MGBench_benchProgress',
     'Java_com_quanneggaes4d_plugin_QNGBench_benchProgress'),
    ('getMobileGluesGLInfo', 'getQuanneggaes4dGLInfo'),
    
    # === Extensões GL custom ===
    ('GL_MG_backend_string_getter_access', 'GL_QNG_backend_string_getter_access'),
    ('GL_MG_settings_string_dump', 'GL_QNG_settings_string_dump'),
    ('GL_MG_mobileglues', 'GL_QNG_quanneggaes4d'),
    ('GL_BACKEND_GETTER_MG', 'GL_BACKEND_GETTER_QNG'),
    ('GL_SETTINGS_MG', 'GL_SETTINGS_QNG'),
    
    # === Símbolos C++ exportados ===
    ('mg_multidraw_bench_progress', 'qng_multidraw_bench_progress'),
    ('mg_multidraw_bench_run', 'qng_multidraw_bench_run'),
    ('mg_angle_in_use', 'qng_angle_in_use'),
    
    # === Classes Kotlin (específicas) ===
    ('MGConfigStore', 'QNGConfigStore'),
    ('MGConfigCodec', 'QNGConfigCodec'),
    ('MGCacheExporter', 'QNGCacheExporter'),
    ('MGApplication', 'QNGApplication'),
    ('MGInfoGetter', 'QNGInfoGetter'),
    ('MGConfig', 'QNGConfig'),
    ('MGBench', 'QNGBench'),
    ('MgQueryService', 'QngQueryService'),
    ('MgQuery', 'QngQuery'),
    ('MgStorage', 'QngStorage'),
    ('MgStats', 'QngStats'),
    ('IMgQuery', 'IQngQuery'),
    
    # === Env vars ===
    ('MG_ANGLE_DIR', 'QNG_ANGLE_DIR'),
    ('MG_DIR_PATH', 'QNG_DIR_PATH'),
    ('MG_PLUGIN_STATUS', 'QNG_PLUGIN_STATUS'),
    ('MG_COUNT_LAUNCH', 'QNG_COUNT_LAUNCH'),
    ('MG_DIRECTORY_PATH', 'QNG_DIRECTORY_PATH'),
    
    # === Diretório config ===
    ('/sdcard/MG', '/sdcard/QNG'),
    ('"MG_DIRECTORY_NAME = "MG"', 'MG_DIRECTORY_NAME = "QNG"'),
    ('MG_DIRECTORY_NAME = "MG"', 'MG_DIRECTORY_NAME = "QNG"'),
    
    # === Meta-data AndroidManifest ===
    ('fclPlugin', 'qngPlugin'),
    
    # === Strings visíveis ===
    ('MobileGlues', 'QUANNEGGAES4D'),
    ('mobileglues', 'quanneggaes4d'),
    ('MOBILEGLUES', 'QUANNEGGAES4D'),
    
    # === Prefixos C++ internos ===
    # ATENÇÃO: só substituir mg_ quando for prefixo de função/variável
    # Não substituir em palavras como "image", "damage", etc.
]

def should_process(filepath):
    """Verifica se o arquivo deve ser processado"""
    # Pular diretórios
    for skip in SKIP_DIRS:
        if skip in filepath.split(os.sep):
            return False
    # Pular binários
    ext = os.path.splitext(filepath)[1].lower()
    if ext not in TEXT_EXTENSIONS:
        return False
    return True

def apply_replacements(content):
    """Aplica substituições em ordem"""
    for old, new in REPLACEMENTS:
        content = content.replace(old, new)
    return content

def process_file(filepath):
    """Processa um arquivo"""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        new_content = apply_replacements(content)
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            return True
    except Exception as e:
        print(f"  ⚠️  Erro em {filepath}: {e}", file=sys.stderr)
    return False

# Prefixo mg_ precisa de tratamento especial (word boundary)
import re

def apply_mg_prefix(content):
    """Substitui prefixo mg_ apenas em contextos de código"""
    # mg_ seguido de letra minúscula (função/variável C)
    # mas não em strings como "image", "damage", "mg_glGetError" já tratado
    patterns = [
        (r'\bmg_draw_elements_restart\b', 'qng_draw_elements_restart'),
        (r'\bmg_restart_needs_rewrite\b', 'qng_restart_needs_rewrite'),
        (r'\bmg_restart_needs_driver_fixed\b', 'qng_restart_needs_driver_fixed'),
        (r'\bmg_restart_invalidate\b', 'qng_restart_invalidate'),
        (r'\bmg_enable_state\b', 'qng_enable_state'),
        (r'\bmg_enable_get\b', 'qng_enable_get'),
        (r'\bmg_enable_query\b', 'qng_enable_query'),
        (r'\bmg_enable_query_int\b', 'qng_enable_query_int'),
        (r'\bmg_enable_reset\b', 'qng_enable_reset'),
        (r'\bmg_enable_sync_driver\b', 'qng_enable_sync_driver'),
        (r'\bmg_driver_bound_buffer\b', 'qng_driver_bound_buffer'),
        (r'\bmg_max_texture_units\b', 'qng_max_texture_units'),
        (r'\bmg_set_gl_error\b', 'qng_set_gl_error'),
        (r'\bmg_multi_draw_arrays_ext_available\b', 'qng_multi_draw_arrays_ext_available'),
        (r'\bmg_multi_draw_elements_basevertex_ext_available\b', 'qng_multi_draw_elements_basevertex_ext_available'),
        (r'\bmg_glMultiDrawElements_drawelements\b', 'qng_glMultiDrawElements_drawelements'),
        (r'\bmg_glMultiDrawElements_indirect\b', 'qng_glMultiDrawElements_indirect'),
        (r'\bmg_glMultiDrawElements_multiindirect\b', 'qng_glMultiDrawElements_multiindirect'),
        (r'\bmg_glMultiDrawElements_multibasevertex\b', 'qng_glMultiDrawElements_multibasevertex'),
        (r'\bmg_glMultiDrawElements_multiarrays\b', 'qng_glMultiDrawElements_multiarrays'),
        (r'\bmg_glMultiDrawElements_compute\b', 'qng_glMultiDrawElements_compute'),
        (r'\bmg_glMultiDrawElements_basevertex\b', 'qng_glMultiDrawElements_basevertex'),
        (r'\bmg_glMultiDrawElementsBaseVertex_drawelements\b', 'qng_glMultiDrawElementsBaseVertex_drawelements'),
        (r'\bmg_glMultiDrawElementsBaseVertex_indirect\b', 'qng_glMultiDrawElementsBaseVertex_indirect'),
        (r'\bmg_glMultiDrawElementsBaseVertex_multiindirect\b', 'qng_glMultiDrawElementsBaseVertex_multiindirect'),
        (r'\bmg_glMultiDrawElementsBaseVertex_multibasevertex\b', 'qng_glMultiDrawElementsBaseVertex_multibasevertex'),
        (r'\bmg_glMultiDrawElementsBaseVertex_compute\b', 'qng_glMultiDrawElementsBaseVertex_compute'),
        (r'\bmg_glMultiDrawElementsBaseVertex_basevertex\b', 'qng_glMultiDrawElementsBaseVertex_basevertex'),
        (r'\bmg_glMultiDrawArrays_unroll\b', 'qng_glMultiDrawArrays_unroll'),
        (r'\bmg_glMultiDrawArrays_multiarrays\b', 'qng_glMultiDrawArrays_multiarrays'),
        (r'\bmg_glMultiDrawArrays_multiindirect\b', 'qng_glMultiDrawArrays_multiindirect'),
        (r'\bmg_glMultiDrawElements_multibasevertex\b', 'qng_glMultiDrawElements_multibasevertex'),
        (r'\bmg_context_create\b', 'qng_context_create'),
        (r'\bmg_context_make_current\b', 'qng_context_make_current'),
        (r'\bmg_context_destroy\b', 'qng_context_destroy'),
        (r'\bmg_context_find\b', 'qng_context_find'),
        (r'\bmg_context_forget_display\b', 'qng_context_forget_display'),
        (r'\bmg_display_initialised\b', 'qng_display_initialised'),
        (r'\bmg_display_release\b', 'qng_display_release'),
        (r'\bmg_buffer_forget_context\b', 'qng_buffer_forget_context'),
        (r'\bmg_texture_forget_context\b', 'qng_texture_forget_context'),
        (r'\bmg_framebuffer_forget_context\b', 'qng_framebuffer_forget_context'),
        (r'\bmg_fsr1_forget_context\b', 'qng_fsr1_forget_context'),
        (r'\bmg_depth_clear_forget_context\b', 'qng_depth_clear_forget_context'),
        (r'\bmg_buffer_bind_context\b', 'qng_buffer_bind_context'),
        (r'\bmg_texture_bind_context\b', 'qng_texture_bind_context'),
        (r'\bmg_framebuffer_bind_context\b', 'qng_framebuffer_bind_context'),
        (r'\bmg_fsr1_bind_context\b', 'qng_fsr1_bind_context'),
        (r'\bmg_pixel_store_query_int\b', 'qng_pixel_store_query_int'),
        (r'\bmg_egl_error_name\b', 'qng_egl_error_name'),
        (r'\bmg_egl_api_name\b', 'qng_egl_api_name'),
        (r'\bmg_draw_framebuffer_all_none\b', 'qng_draw_framebuffer_all_none'),
        (r'\bmg_primitive_restart_enabled\b', 'qng_primitive_restart_enabled'),
        (r'\bmg_primitive_restart_index_for\b', 'qng_primitive_restart_index_for'),
        (r'\bmg_gles_has_extension\b', 'qng_gles_has_extension'),
        (r'\bmg_md_check\b', 'qng_md_check'),
        (r'\bmg_md_drain\b', 'qng_md_drain'),
        (r'\bmg_index_size\b', 'qng_index_size'),
        (r'\bmg_verts_per_primitive\b', 'qng_verts_per_primitive'),
        (r'\bmg_rebase_indices_to_u32\b', 'qng_rebase_indices_to_u32'),
        (r'\bmg_validate_multidraw\b', 'qng_validate_multidraw'),
        (r'\bmg_validate_multidraw_arrays\b', 'qng_validate_multidraw_arrays'),
        (r'\bmg_multidraw_enter\b', 'qng_multidraw_enter'),
        (r'\bmg_multidraw_restart_takeover\b', 'qng_multidraw_restart_takeover'),
        (r'\bmd_backend_t\b', 'qng_md_backend_t'),
        (r'\bmd_entry_t\b', 'qng_md_entry_t'),
        (r'\bmd_backend_name\b', 'qng_md_backend_name'),
        (r'\bmd_backend_suffix\b', 'qng_md_backend_suffix'),
        (r'\bmd_next_backend\b', 'qng_md_next_backend'),
        (r'\bmg_multi_draw_basevertex\b', 'qng_multi_draw_basevertex'),
    ]
    for pattern, replacement in patterns:
        content = re.sub(pattern, replacement, content)
    return content

def process_file_with_mg(filepath):
    """Processa arquivo com substituições + prefixo mg_"""
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        new_content = apply_replacements(content)
        new_content = apply_mg_prefix(new_content)
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            return True
    except Exception as e:
        print(f"  ⚠️  Erro em {filepath}: {e}", file=sys.stderr)
    return False

# Processar todos os arquivos
count = 0
for root, dirs, files in os.walk('.'):
    # Pular diretórios indesejados
    dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
    
    for file in files:
        filepath = os.path.join(root, file)
        if should_process(filepath):
            if process_file_with_mg(filepath):
                count += 1
                print(f"  ✅ {filepath}")

print(f"\n✅ {count} arquivos modificados")
PYEOF

echo "✅ Substituições aplicadas"

# ═══════════════════════════════════════════════════════════
# FASE 5: Corrigir include path QNG
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 5] Corrigindo paths de include..."

# Garantir que includes de MG viraram QNG
find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.c" \) \
    -not -path "./.git/*" \
    -exec sed -i 's|include/MG/|include/QNG/|g' {} + 2>/dev/null || true

find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.c" \) \
    -not -path "./.git/*" \
    -exec sed -i 's|"MG/|"QNG/|g' {} + 2>/dev/null || true

find . -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.c" \) \
    -not -path "./.git/*" \
    -exec sed -i 's|<MG/|<QNG/|g' {} + 2>/dev/null || true

echo "✅ Includes corrigidos"

# ═══════════════════════════════════════════════════════════
# FASE 6: Criar documentação .md
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 6] Criando documentação..."

cat > QUANNEGGAES4D_IMPLEMENTATION.md << 'MDEOF'
# QUANNEGGAES4D - Implementation Guide

**QUANTIC NEXUS NEXT GENERATION GRAPHIC ENGINE SYSTEM 4D**

## Overview

This document describes the complete rename and rebranding from **MobileGlues** to **QUANNEGGAES4D**, performed to avoid installation and runtime conflicts with the original project.

## Rename Map

| Category | Original | New |
|---|---|---|
| Native library | `libmobileglues.so` | `libquanneggaes4d.so` |
| Info getter lib | `libmobileglues_info_getter.so` | `libquanneggaes4d_info_getter.so` |
| Android package | `com.fcl.plugin.mobileglues` | `com.quanneggaes4d.plugin` |
| Core namespace | `top.mobilegl.mobileglues` | `top.quanneggaes4d.core` |
| C++ directory | `MobileGlues-cpp` | `Quanneggaes4d-cpp` |
| Plugin directory | `MobileGlues-plugin` | `Quanneggaes4d-plugin` |
| Library module | `MobileGlues` | `Quanneggaes4d` |
| Config directory | `/sdcard/MG` | `/sdcard/QNG` |
| Env var prefix | `MG_*` | `QNG_*` |
| GL extensions | `GL_MG_*` | `GL_QNG_*` |
| C++ prefix | `mg_` | `qng_` |
| Kotlin classes | `MG*` / `Mg*` | `QNG*` / `Qng*` |

## Architecture
## ANGLE Integration

ANGLE is loaded conditionally based on `enableANGLE` in `QNG/config.json`:

| Value | Mode | Description |
|---|---|---|
| 0 | DisableIfPossible | ANGLE off unless forced |
| 1 | EnableIfPossible | ANGLE on if device supports (Vulkan 1.2+, not Adreno 730/740) |
| 2 | ForceDisable | ANGLE always off |
| 3 | ForceEnable | ANGLE always on |

## Environment Variables

| Variable | Purpose |
|---|---|
| `QNG_ANGLE_DIR` | Directory containing ANGLE .so files (empty = no ANGLE) |
| `QNG_DIR_PATH` | Path to QNG config directory |
| `QNG_PLUGIN_STATUS` | Set to "1" when running inside plugin app |
| `QNG_COUNT_LAUNCH` | Set to "1" to count as a game launch |

## Custom GL Extensions

| Extension | Value | Purpose |
|---|---|---|
| `GL_QNG_quanneggaes4d` | `0x0400` | Identifies QUANNEGGAES4D renderer |
| `GL_BACKEND_GETTER_QNG` | `0x0401` | Backend string getter access |
| `GL_SETTINGS_QNG` | `0x0402` | Settings string dump |

## Build

```bash
# Build native library
cd Quanneggaes4d-cpp
mkdir -p build && cd build
cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-21 \
  -DANDROID_STL=c++_static \
  -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release -j$(nproc)

# Build APK
cd ../Quanneggaes4d-plugin
./gradlew assembleRelease
```

## Conflict Avoidance

This rename ensures:
- No APK installation conflict (different package name)
- No native library loading conflict (different .so name)
- No config directory collision (different `/sdcard/QNG` path)
- No env var interference (different `QNG_*` prefix)

## Version

- **Version**: 2.0.0
- **Version Code**: 2000
- **Min SDK**: 26
- **Target SDK**: 36
- **NDK**: 27.3.13750724

## License

GNU LGPL-2.1 License
MDEOF

echo "✅ Documentação criada: QUANNEGGAES4D_IMPLEMENTATION.md"

# ═══════════════════════════════════════════════════════════
# FASE 7: Verificações finais
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 7] Verificações finais..."

echo ""
echo "--- Verificando referências residuais a 'mobileglues' ---"
RESIDUAL=$(grep -ri "mobileglues" \
    --include="*.cpp" --include="*.h" --include="*.kt" --include="*.kts" \
    --include="*.xml" --include="*.gradle" --include="*.aidl" --include="*.toml" \
    --exclude-dir=".git" --exclude-dir="build" --exclude-dir="3rdparty" \
    . 2>/dev/null | grep -v "QUANNEGGAES4D" | grep -v "quanneggaes4d" || true)

if [ -n "$RESIDUAL" ]; then
    echo "⚠️  Referências residuais encontradas:"
    echo "$RESIDUAL" | head -20
else
    echo "✅ Nenhuma referência residual a 'mobileglues'"
fi

echo ""
echo "--- Verificando estrutura de diretórios ---"
ls -d Quanneggaes4d-cpp Quanneggaes4d-plugin 2>/dev/null && echo "✅ Diretórios principais OK" || echo "❌ Diretórios principais FALTANDO"

echo ""
echo "--- Verificando arquivos renomeados ---"
[ -f "Quanneggaes4d-plugin/app/src/main/cpp/quanneggaes4d_info_getter.cpp" ] && echo "✅ quanneggaes4d_info_getter.cpp" || echo "❌ quanneggaes4d_info_getter.cpp FALTANDO"
[ -f "Quanneggaes4d-plugin/app/src/main/java/com/quanneggaes4d/plugin/QNGInfoGetter.kt" ] && echo "✅ QNGInfoGetter.kt" || echo "❌ QNGInfoGetter.kt FALTANDO"
[ -f "Quanneggaes4d-plugin/app/src/main/aidl/com/quanneggaes4d/plugin/IQngQuery.aidl" ] && echo "✅ IQngQuery.aidl" || echo "❌ IQngQuery.aidl FALTANDO"

# ═══════════════════════════════════════════════════════════
# FASE 8: Git commit
# ═══════════════════════════════════════════════════════════
echo ""
echo "[FASE 8] Commit das alterações..."

git add -A
git commit -m "feat: rename to QUANNEGGAES4D (QUANTIC NEXUS NEXT GENERATION GRAPHIC ENGINE SYSTEM 4D)

- Renamed libmobileglues.so -> libquanneggaes4d.so
- Renamed package com.fcl.plugin.mobileglues -> com.quanneggaes4d.plugin
- Renamed namespace top.mobilegl.mobileglues -> top.quanneggaes4d.core
- Renamed config dir /sdcard/MG -> /sdcard/QNG
- Renamed env vars MG_* -> QNG_*
- Renamed GL extensions GL_MG_* -> GL_QNG_*
- Renamed C++ prefix mg_ -> qng_
- Renamed Kotlin classes MG*/Mg* -> QNG*/Qng*
- Added QUANNEGGAES4D_IMPLEMENTATION.md documentation
- Avoids installation and runtime conflicts with original MobileGlues"

echo ""
echo "============================================================"
echo " ✅ RENOMEAÇÃO COMPLETA!"
echo "============================================================"
echo ""
echo " Próximos passos:"
echo "   1. git push"
echo "   2. Verificar CI/CD no GitHub Actions"
echo "   3. Testar instalação do APK renomeado"
echo ""
