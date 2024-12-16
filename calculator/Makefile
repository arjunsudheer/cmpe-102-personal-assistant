# run make -r all

# Define variables for common paths and tools
TOOLPATH = /usr/aarch64-linux-gnu/bin
AS = $(TOOLPATH)/as
LD = $(TOOLPATH)/ld
CFLAGS = -g

# Automatically find all .s files in the current directory
SOURCES = calculator.s calculator.c
OBJECTS = $(patsubst %.s,%.o,$(filter %.s, $(SOURCES)))
TARGETS = $(patsubst %.c,%,$(patsubst %.s,%,$(SOURCES)))

# Default target
all: $(TARGETS)

%: %.s %.c
	aarch64-linux-gnu-gcc $(CFLAGS) $^ -o $@

# Clean up generated files
clean:
	rm -f $(OBJECTS) $(TARGETS)
