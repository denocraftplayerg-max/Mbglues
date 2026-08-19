#ifndef SHA256_MIN_H
#define SHA256_MIN_H
#include <stdint.h>
#include <stddef.h>
#define SHA256_DIGEST_LENGTH 32
typedef struct {
    uint32_t state[8];
    uint64_t bitlen;
    uint8_t data[64];
    size_t datalen;
} SHA256_CTX;
#ifdef __cplusplus
extern "C" {
#endif
void SHA256_Init(SHA256_CTX *ctx);
void SHA256_Update(SHA256_CTX *ctx, const void *data, size_t len);
void SHA256_Final(unsigned char *hash, SHA256_CTX *ctx);
#ifdef __cplusplus
}
#endif
#endif
