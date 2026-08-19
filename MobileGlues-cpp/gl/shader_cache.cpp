#include "shader_cache.h"
#include "mg.h"
#include "../includes.h"
#include <filesystem>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <cstring>
#include "sha256_min.h"
#include <chrono>

#define DEBUG 0

namespace fs = std::filesystem;

// Gera SHA256 hash do conteúdo
std::string sha256(const std::string& str) {
    unsigned char hash[SHA256_DIGEST_LENGTH];
    SHA256_CTX sha256;
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, str.c_str(), str.length());
    SHA256_Final(hash, &sha256);
    
    std::ostringstream ss;
    for (int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        ss << std::hex << std::setw(2) << std::setfill('0') << (int)hash[i];
    }
    return ss.str();
}

std::string generateShaderHash(const std::string& vertex, const std::string& fragment) {
    std::string combined = vertex + "\n--- FRAGMENT ---\n" + fragment;
    return sha256(combined);
}

std::string getCacheDirectory(ShaderSource source, const std::string& shader_name) {
    if (source == ShaderSource::Minecraft) {
        return std::string(SHADER_MINECRAFT_DIR);
    } else {
        return std::string(SHADER_EXTERNAL_DIR) + shader_name + "/";
    }
}

void ensureDirectoryExists(const std::string& path) {
    try {
        fs::path dir(path);
        if (!fs::exists(dir)) {
            fs::create_directories(dir);
            LOG_D("Created shader cache directory: %s", path.c_str());
        }
    } catch (const std::exception& e) {
        LOG_E("Failed to create directory %s: %s", path.c_str(), e.what());
    }
}

std::string getHashDirectory(const std::string& hash, ShaderSource source, const std::string& shader_name) {
    std::string base = getCacheDirectory(source, shader_name);
    ensureDirectoryExists(base);
    std::string hash_dir = base + hash + "/";
    ensureDirectoryExists(hash_dir);
    return hash_dir;
}

bool isShaderCached(const std::string& hash, ShaderSource source, const std::string& shader_name) {
    try {
        std::string hash_dir = getCacheDirectory(source, shader_name) + hash + "/";
        return fs::exists(hash_dir) && 
               fs::exists(hash_dir + "vertex.glsl") && 
               fs::exists(hash_dir + "fragment.glsl");
    } catch (const std::exception& e) {
        LOG_E("Error checking shader cache: %s", e.what());
        return false;
    }
}

bool saveShaderSource(const CompiledShaderInfo& info, ShaderSource source, const std::string& shader_name) {
    try {
        std::string hash_dir = getHashDirectory(info.shader_hash, source, shader_name);
        
        // Salva vertex shader
        std::ofstream vertex_file(hash_dir + "vertex.glsl");
        if (!vertex_file) {
            LOG_E("Failed to open vertex shader file: %s", (hash_dir + "vertex.glsl").c_str());
            return false;
        }
        vertex_file << info.vertex_source;
        vertex_file.close();
        
        // Salva fragment shader
        std::ofstream fragment_file(hash_dir + "fragment.glsl");
        if (!fragment_file) {
            LOG_E("Failed to open fragment shader file: %s", (hash_dir + "fragment.glsl").c_str());
            return false;
        }
        fragment_file << info.fragment_source;
        fragment_file.close();
        
        // Salva configurações em JSON se fornecidas
        if (!info.config_json.empty()) {
            std::ofstream config_file(hash_dir + "config.json");
            if (config_file) {
                config_file << info.config_json;
                config_file.close();
            }
        }
        
        LOG_D("Saved shader cache: %s (hash: %.8s...)", 
              source == ShaderSource::Minecraft ? "minecraft" : shader_name.c_str(),
              info.shader_hash.c_str());
        return true;
    } catch (const std::exception& e) {
        LOG_E("Exception saving shader source: %s", e.what());
        return false;
    }
}

bool loadShaderSource(CompiledShaderInfo& info, const std::string& hash, ShaderSource source, const std::string& shader_name) {
    try {
        std::string hash_dir = getCacheDirectory(source, shader_name) + hash + "/";
        
        if (!fs::exists(hash_dir)) {
            return false;
        }
        
        // Carrega vertex shader
        std::ifstream vertex_file(hash_dir + "vertex.glsl");
        if (!vertex_file) return false;
        std::stringstream vertex_ss;
        vertex_ss << vertex_file.rdbuf();
        info.vertex_source = vertex_ss.str();
        vertex_file.close();
        
        // Carrega fragment shader
        std::ifstream fragment_file(hash_dir + "fragment.glsl");
        if (!fragment_file) return false;
        std::stringstream fragment_ss;
        fragment_ss << fragment_file.rdbuf();
        info.fragment_source = fragment_ss.str();
        fragment_file.close();
        
        // Carrega config se existir
        std::string config_path = hash_dir + "config.json";
        if (fs::exists(config_path)) {
            std::ifstream config_file(config_path);
            if (config_file) {
                std::stringstream config_ss;
                config_ss << config_file.rdbuf();
                info.config_json = config_ss.str();
                config_file.close();
            }
        }
        
        info.shader_hash = hash;
        info.cached = true;
        
        LOG_D("Loaded shader from cache: %s (hash: %.8s...)", 
              source == ShaderSource::Minecraft ? "minecraft" : shader_name.c_str(),
              hash.c_str());
        return true;
    } catch (const std::exception& e) {
        LOG_E("Exception loading shader source: %s", e.what());
        return false;
    }
}

std::string getProgramBinaryPath(const std::string& shader_hash, ShaderSource source, const std::string& shader_name) {
    std::string hash_dir = getHashDirectory(shader_hash, source, shader_name);
    return hash_dir + "program.bin";
}

bool saveProgramBinary(GLuint program, const std::string& shader_hash, ShaderSource source, const std::string& shader_name) {
    try {
        std::string path = getProgramBinaryPath(shader_hash, source, shader_name);
        GLint binaryLength = 0;
        
        // Obtém tamanho do binário
        #if defined(GL_OES_get_program_binary)
            glGetProgramBinaryOES(program, 0, nullptr, nullptr, nullptr);
            glGetProgramiv(program, GL_PROGRAM_BINARY_LENGTH_OES, &binaryLength);
        #elif defined(GL_ARB_get_program_binary)
            glGetProgramiv(program, GL_PROGRAM_BINARY_LENGTH, &binaryLength);
        #else
            glGetProgramiv(program, GL_PROGRAM_BINARY_LENGTH, &binaryLength);
        #endif
        
        if (binaryLength <= 0) {
            LOG_D("Program binary length is 0 or negative, skipping binary cache");
            return false;
        }
        
        std::vector<GLubyte> binary(binaryLength);
        GLenum binaryFormat = 0;
        GLsizei actualLength = 0;
        
        // Obtém binário compilado
        #if defined(GL_OES_get_program_binary)
            glGetProgramBinaryOES(program, binaryLength, &actualLength, &binaryFormat, binary.data());
        #elif defined(GL_ARB_get_program_binary)
            glGetProgramBinary(program, binaryLength, &actualLength, &binaryFormat, binary.data());
        #else
            glGetProgramBinary(program, binaryLength, &actualLength, &binaryFormat, binary.data());
        #endif
        
        // Salva arquivo
        std::ofstream file(path, std::ios::binary);
        if (!file) {
            LOG_E("Failed to open binary file for writing: %s", path.c_str());
            return false;
        }
        
        // Escreve formato e dados
        file.write(reinterpret_cast<const char*>(&binaryFormat), sizeof(binaryFormat));
        file.write(reinterpret_cast<const char*>(binary.data()), actualLength);
        file.close();
        
        LOG_D("Saved program binary: %d bytes (hash: %.8s...)", actualLength, shader_hash.c_str());
        return true;
    } catch (const std::exception& e) {
        LOG_E("Exception saving program binary: %s", e.what());
        return false;
    }
}

bool loadProgramBinary(GLuint program, const std::string& shader_hash, ShaderSource source, const std::string& shader_name) {
    try {
        std::string path = getProgramBinaryPath(shader_hash, source, shader_name);
        
        std::ifstream file(path, std::ios::binary | std::ios::ate);
        if (!file) {
            LOG_D("Binary cache not found: %.8s...", shader_hash.c_str());
            return false;
        }
        
        std::streamsize size = file.tellg();
        file.seekg(0, std::ios::beg);
        
        if (size <= sizeof(GLenum)) {
            LOG_W("Binary file too small: %zd bytes", size);
            return false;
        }
        
        std::vector<GLubyte> data(size);
        file.read(reinterpret_cast<char*>(data.data()), size);
        file.close();
        
        // Extrai formato e binário
        GLenum binaryFormat = *reinterpret_cast<const GLenum*>(data.data());
        const GLubyte* binaryData = data.data() + sizeof(binaryFormat);
        GLsizei binaryLength = static_cast<GLsizei>(size - sizeof(binaryFormat));
        
        // Carrega binário no programa
        #if defined(GL_OES_get_program_binary)
            glProgramBinaryOES(program, binaryFormat, binaryData, binaryLength);
        #elif defined(GL_ARB_get_program_binary)
            glProgramBinary(program, binaryFormat, binaryData, binaryLength);
        #else
            glProgramBinary(program, binaryFormat, binaryData, binaryLength);
        #endif
        
        // Verifica se carregou corretamente
        GLint success = 0;
        glGetProgramiv(program, GL_LINK_STATUS, &success);
        
        if (!success) {
            GLchar infoLog[512];
            glGetProgramInfoLog(program, 512, nullptr, infoLog);
            LOG_E("Failed to load program binary - %s", infoLog);
            return false;
        }
        
        LOG_D("Loaded program binary from cache (hash: %.8s...)", shader_hash.c_str());
        return true;
    } catch (const std::exception& e) {
        LOG_E("Exception loading program binary: %s", e.what());
        return false;
    }
}

void cleanOldShaderCache(ShaderSource source, int days) {
    try {
        auto base = getCacheDirectory(source);
        if (!fs::exists(base)) return;
        
        auto now = std::chrono::system_clock::now();
        auto cutoff = now - std::chrono::hours(days * 24);
        
        for (const auto& entry : fs::recursive_directory_iterator(base)) {
            if (fs::is_regular_file(entry)) {
                auto lastWrite = fs::last_write_time(entry);
                auto sctp = std::chrono::time_point_cast<std::chrono::system_clock::duration>(
                    lastWrite - fs::file_time_type::clock::now() + std::chrono::system_clock::now()
                );
                
                if (sctp < cutoff) {
                    try {
                        fs::remove_all(entry.path().parent_path());
                        LOG_D("Removed old shader cache: %.8s...", entry.path().filename().c_str());
                    } catch (const std::exception& e) {
                        LOG_W("Failed to remove cache directory: %s", e.what());
                    }
                }
            }
        }
    } catch (const std::exception& e) {
        LOG_W("Exception cleaning shader cache: %s", e.what());
    }
}
