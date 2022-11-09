#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include <stdlib.h>


#define TRANSFER_RUNS 3750

#define NUM_CHANNELS 2
#define BPS 32
#define SAMPLE_RATE 48000
#define RECORD_DURATION 10


void create_wav(char *filename, uint32_t num_samples, uint16_t num_channels, uint32_t *data, uint32_t fs, uint16_t bit_depth) {
    FILE *wav_file;
    unsigned int bytes_per_sample = bit_depth / 8;
    uint32_t byte_rate = fs * num_channels * bytes_per_sample;
    uint32_t sub_chunk_1_size = 16;
    uint16_t pcm_format = 1;
    uint16_t block_align = num_channels * bytes_per_sample;
    uint32_t sub_chunk_2_size = num_samples * bytes_per_sample;
    uint32_t chunk_size = 36 + sub_chunk_2_size;

    wav_file = fopen(filename, "w+");
    assert(wav_file);

    fwrite("RIFF", 1, 4, wav_file);
    fwrite(&chunk_size, sizeof(uint32_t), 1, wav_file);
    fwrite("WAVE", 1, 4, wav_file);

    fwrite("fmt ", 1, 4, wav_file);
    fwrite(&sub_chunk_1_size, sizeof(uint32_t), 1, wav_file);
    fwrite(&pcm_format, sizeof(uint16_t), 1, wav_file);
    fwrite(&num_channels, sizeof(uint16_t), 1, wav_file);
    fwrite(&fs, sizeof(uint32_t), 1, wav_file);
    fwrite(&byte_rate, sizeof(uint32_t), 1, wav_file);
    fwrite(&block_align, sizeof(uint16_t), 1, wav_file);
    fwrite(&bit_depth, sizeof(uint16_t), 1, wav_file);

    fwrite("data", sizeof(char), 4, wav_file);
    fwrite(&sub_chunk_2_size, sizeof(uint32_t), 1, wav_file);

    // for (uint32_t i = 0; i < num_samples; i++) {
    //     fwrite(&data[i], bytes_per_sample, 1, wav_file);
    // }
    fwrite(data, 4,  num_samples, wav_file);

    fclose(wav_file);
}


int main(){
    FILE *txt_file;
    uint32_t *buffer = (uint32_t*) malloc(NUM_CHANNELS * SAMPLE_RATE * RECORD_DURATION * sizeof(uint32_t));
    txt_file = fopen("sample.txt", "r");
    char line[8];

    int index = 0;
    while (fgets(line, sizeof(line), txt_file)) {
        /* note that fgets don't strip the terminating \n, checking its
           presence would allow to handle lines longer that sizeof(line) */
        char *ptr;
        //printf("int: %d\n", (uint32_t)strtol(line, &ptr, 10));
        if (strtol(line, &ptr, 10) != 0) {
            buffer[index] = (uint32_t)strtol(line, &ptr, 10) << 14;
            index ++;
        }
       //printf("%d\n", (uint32_t)strtol(line));
       //printf("%d, %u\n", buffer[index], (uint32_t)buffer[index] << 14);
        
    }
    /* may check feof here to make a difference between eof and io failure -- network
       timeout for instance */
    //create_wav("wav_test1.wav", NUM_CHANNELS*SAMPLE_RATE*RECORD_DURATION, NUM_CHANNELS, buffer, SAMPLE_RATE, BPS);
    create_wav("wav_test1.wav", index + 1, NUM_CHANNELS, buffer, SAMPLE_RATE, BPS);
    printf("%d", index);

    fclose(txt_file);



    return 0;
}