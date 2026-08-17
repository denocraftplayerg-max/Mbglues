#ifndef MOBILEGLUES_PROGRAM_BINARY_H
#define MOBILEGLUES_PROGRAM_BINARY_H

#include <string>
#include <GL/gl.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SHADER_BINARY_DIR "/sdcard/MG/shaders/"

bool saveProgramBinary(GLuint program, const std::string& name);
bool loadProgramBinary(GLuint program, const std::string& name);
bool programBinarySupported();
std::string getProgramBinaryPath(const std::string& name);

#ifdef __cplusplus
}
#endif

#endif
