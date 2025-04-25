#include <inttypes.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_SIZE 512

#define MAX_PWD_SIZE 11
#define CHUNK_SIZE 4

typedef enum
{
    ERR_OK = 0,
    ERR_ALLOC,
    ERR_IO,
    ERR_ARGS,
    ERR_OVERFLOW
} err_t;

uintptr_t find_sig_offset(FILE *fp, const uint8_t *sig, size_t sig_size)
{
    uint8_t buf[BUF_SIZE];
    bool found = false;
    size_t cur_offset = 0;

    if (fseek(fp, 0, SEEK_SET))
        return -1;

    size_t read;
    size_t last_file_off = 0;
    while (!found && (read = fread(buf, 1, sizeof(buf), fp)) != 0)
    {
        for (size_t i = 0; !found && i < read; ++i)
        {
            if (sig[cur_offset] == buf[i])
                ++cur_offset;
            else
            {
                if (fseek(fp, ++last_file_off, SEEK_SET))
                    return -1;

                cur_offset = 0;
                break;
            }

            if (cur_offset == sig_size)
                found = true;
        }
    }

    if (found)
        return last_file_off;

    return -1;
}

// clang-format off
static const uint8_t main_sig[] = {
    0x83, 0xe4, 0xf0,
    0x83, 0xec, 0x50,
    0xe8, 0x32, 0x06, 0x00, 0x00
};

static const uint8_t original_msg[] = {
    0xc7,0x44,0x24,0x38,0x70,0x61,0x73,0x73, // mov dword [esp + 0x38], 0x73736170 ; 'pass'
    0xc7,0x44,0x24,0x3c,0x77,0x6f,0x72,0x64, // mov dword [esp + 0x3c], 0x64726f77 ; 'word'
    0xc7,0x44,0x24,0x40,0x31,0x32,0x33,0x00, // mov dword [esp + 0x40], 0x333231 ; '123'
};
// clang-format on

bool is_patched(const char *file_path)
{
    FILE *fp = fopen(file_path, "rb");
    bool found = find_sig_offset(fp, original_msg, sizeof(original_msg)) == (uintptr_t)-1;
    fclose(fp);

    return found;
}

int restore_file(const char *file_path)
{
    int rc = ERR_OK;
    FILE *fp = NULL;

    fp = fopen(file_path, "r+b");
    if (fp == NULL)
    {
        rc = ERR_IO;
        goto cleanup;
    }

    uintptr_t off = find_sig_offset(fp, main_sig, sizeof(main_sig));
    fseek(fp, off + sizeof(main_sig), SEEK_SET);
    fwrite(original_msg, 1, sizeof(original_msg), fp);

    cleanup:
    fclose(fp);

    return rc;
}

int patch_file(const char *file_path)
{
    int rc = ERR_OK;
    FILE *fp = NULL;

    printf("Input new password: ");
    char buf[128];
    if (fgets(buf, sizeof(buf), stdin) == NULL)
    {
        rc = ERR_IO;
        goto cleanup;
    }

    char *newline = strchr(buf, '\n');
    if (newline)
        *newline = '\0';
    else
    {
        rc = ERR_OVERFLOW;
        goto cleanup;
    }

    size_t pwd_len = strlen(buf);

    if (pwd_len > MAX_PWD_SIZE)
    {
        rc = ERR_OVERFLOW;
        goto cleanup;
    }

    fp = fopen(file_path, "r+b");
    if (fp == NULL)
    {
        rc = ERR_IO;
        goto cleanup;
    }

    uintptr_t off = find_sig_offset(fp, original_msg, sizeof(original_msg));
    for (size_t i = 0; i < pwd_len + 1; ++i)
    {
        size_t idx = i / CHUNK_SIZE;
        fseek(fp, off + (idx * 8) + 4 + i % CHUNK_SIZE, SEEK_SET);
        fwrite(buf + i, 1, 1, fp);
    }

    fclose(fp);

    cleanup:
    return rc;
}

int main(int argc, char **argv)
{
    int rc = ERR_OK;

    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <in-file-path>\n", argv[0]);
        return ERR_ARGS;
    }

    if (is_patched(argv[1]))
    {
        printf("File is already patched! Restoring...\n");
        rc = restore_file(argv[1]);
    }
    else
    {
        printf("Patching!\n");
        rc = patch_file(argv[1]);
    }

    if (rc != ERR_OK)
        printf("An error occured!\n");

    return rc;
}
