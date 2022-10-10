CC       ?= gcc
CXX      ?= g++
LANGFLAG = -x c++
CPPFLAGS += -I include/
CFLAGS   += -g -Wall -O2 -std=c++11
LDFLAGS  += $(LIBS) -lpthread -lz -rdynamic
BUILD_DIR = build

ifeq ($(zstd),1)
LDFLAGS		+= -lzstd
endif

BINARY = audio_i2s
OBJ = $(BUILD_DIR)/main.o \
      $(BUILD_DIR)/audio_i2s.o \
	  $(BUILD_DIR)/axi_dma.o \

PREFIX = /usr/local
VERSION = `git describe --tags`

ifdef asan
	CFLAGS += -fsanitize=address -fno-omit-frame-pointer
	LDFLAGS += -fsanitize=address -fno-omit-frame-pointer
endif

.PHONY: clean distclean test

$(BINARY): $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)

$(BUILD_DIR)/main.o: src/main.c include/audio_i2s.h
	$(CXX) $(CFLAGS) $(CPPFLAGS) $(LANGFLAG) $< -c -o $@

$(BUILD_DIR)/audio_i2s.o: src/audio_i2s.c include/audio_i2s.h include/axi_dma.h include/misc.h
	$(CXX) $(CFLAGS) $(CPPFLAGS) $(LANGFLAG) $< -c -o $@

$(BUILD_DIR)/axi_dma.o: src/axi_dma.c include/axi_dma.h include/misc.h
	$(CXX) $(CFLAGS) $(CPPFLAGS) $(LANGFLAG) $< -c -o $@

clean:
	rm -rf $(BINARY) $(BUILD_DIR)/*.o

# Delete all gitignored files (but not directories)
distclean: clean
	git clean -f -X
	rm -rf $(BUILD_DIR)/* autom4te.cache