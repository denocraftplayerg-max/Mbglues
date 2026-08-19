#ifndef QUANNEGGAES4D_SHADER_CACHE_H
#define QUANNEGGAES4D_SHADER_CACHE_H

#include <string>
#include <vector>
#include <GL/gl.h>
#include <unordered_map>

#ifdef __cplusplus
extern "C" {
#endif

#define SHADER_CACHE_BASE "/sdcard/QNG/shaders/"
#define SHADER_MINECRAFT_DIR SHADER_CACHE_BASE "minecraft/"
#define SHADER_EXTERNAL_DIR SHADER_CACHE_BASE "external/"

// Tipos de shader
enum class ShaderSource {
    Minecraft,      // Shaders nativos do Minecraft
    External        // Shaders externos
};

// Estructura para armazenar info do shader compilado
struct CompiledShaderInfo {
    std::string shader_hash;      // Hash SHA256 do código-fonte
    std::string vertex_source;
    std::string fragment_source;
    std::string config_json;
    std::string binary_path;
    bool cached;
};

// Gera hash SHA256 do código fonte (vertex + fragment)
std::string generateShaderHash(const std::string& vertex, const std::string& fragment);

// Obtem caminho do diretório de cache baseado na fonte
std::string getCacheDirectory(ShaderSource source, const std::string& shader_name = "");

// Salva configurações do shader (source code + metadata)
bool saveShaderSource(const CompiledShaderInfo& info, ShaderSource source, const std::string& shader_name = "");

// Carrega configurações do shader do cache
bool loadShaderSource(CompiledShaderInfo& info, const std::string& hash, ShaderSource source, const std::string& shader_name = "");

// Verifica se shader já existe em cache
bool isShaderCached(const std::string& hash, ShaderSource source, const std::string& shader_name = "");

// Salva binário compilado com hash
bool saveProgramBinary(GLuint program, const std::string& shader_hash, ShaderSource source, const std::string& shader_name = "");

// Carrega binário compilado
bool loadProgramBinary(GLuint program, const std::string& shader_hash, ShaderSource source, const std::string& shader_name = "");

// Obtem caminho completo do binário
std::string getProgramBinaryPath(const std::string& shader_hash, ShaderSource source, const std::string& shader_name = "");

// Limpa cache antigo (opcional)
void cleanOldShaderCache(ShaderSource source, int days = 30);

#ifdef __cplusplus
}
#endif

#endif // QUANNEGGAES4D_SHADER_CACHE_H
