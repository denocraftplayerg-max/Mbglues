#include "program_binary.h"
#include "mg.h"
#include "../includes.h"
#include <filesystem>

#define DEBUG 0

namespace fs = std::filesystem;

void ensureBinaryDirExists() {
    fs::path dir(SHADER_BINARY_DIR);
    if (!fs::exists(dir)) fs::create_directories(dir);
}

std::string getProgramBinaryPath(const std::string& name) {
    ensureBinaryDirExists();
    return std::string(SHADER_BINARY_DIR) + name + ".bin";
}

bool programBinarySupported() {
    return true;
}

bool saveProgramBinary(GLuint program, const std::string& name) {
    if (!programBinarySupported()) return false;

    std::string path = getProgramBinaryPath(name);
    GLint binaryLength = 0;

    #if defined(GL_OES_get_program_binary)
        GLES.glGetProgramBinaryOES(program, &binaryLength, nullptr);
    #elif defined(GL_ARB_get_program_binary)
        GLES.glGetProgramBinary(program, &binaryLength, nullptr);
    #endif

    if (binaryLength <= 0) return false;

    std::vector<GLubyte> binary(binaryLength);
    GLenum binaryFormat = 0;

    #if defined(GL_OES_get_program_binary)
        GLES.glGetProgramBinaryOES(program, &binaryLength, binary.data());
    #elif defined(GL_ARB_get_program_binary)
        GLES.glGetProgramBinary(program, &binaryLength, &binaryFormat, binary.data());
    #endif

    std::ofstream file(path, std::ios::binary);
    if (!file) return false;

    #if defined(GL_ARB_get_program_binary)
        file.write(reinterpret_cast<const char*>(&binaryFormat), sizeof(binaryFormat));
    #endif
    file.write(reinterpret_cast<const char*>(binary.data()), binaryLength);
    file.close();

    LOG_D("Saved program binary: %s (%d bytes)", name.c_str(), binaryLength);
    return true;
}

bool loadProgramBinary(GLuint program, const std::string& name) {
    if (!programBinarySupported()) return false;

    std::string path = getProgramBinaryPath(name);
    std::ifstream file(path, std::ios::binary | std::ios::ate);
    if (!file) return false;

    std::streamsize size = file.tellg();
    file.seekg(0, std::ios::beg);
    if (size <= 0) return false;

    std::vector<GLubyte> binary(size);
    file.read(reinterpret_cast<char*>(binary.data()), size);
    file.close();

    GLenum binaryFormat = 0;
    const GLubyte* binaryData = binary.data();
    GLsizei binaryLength = static_cast<GLsizei>(size);

    #if defined(GL_ARB_get_program_binary)
        if (size >= sizeof(binaryFormat)) {
            binaryFormat = *reinterpret_cast<const GLenum*>(binary.data());
            binaryData += sizeof(binaryFormat);
            binaryLength -= sizeof(binaryFormat);
        }
    #endif

    #if defined(GL_OES_get_program_binary)
        GLES.glProgramBinaryOES(program, binaryFormat, binaryData, binaryLength);
    #elif defined(GL_ARB_get_program_binary)
        GLES.glProgramBinary(program, binaryFormat, binaryData, binaryLength);
    #endif

    GLint success = 0;
    GLES.glGetProgramiv(program, GL_LINK_STATUS, &success);
    if (!success) {
        GLchar infoLog[512];
        GLES.glGetProgramInfoLog(program, 512, nullptr, infoLog);
        LOG_E("Failed to load program binary: %s - %s", name.c_str(), infoLog);
        return false;
    }

    LOG_D("Loaded program binary: %s", name.c_str());
    return true;
}
