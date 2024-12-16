# run make -r all

# Define variables for common paths and tools
TOOLPATH = /usr/aarch64-linux-gnu/bin
AS = $(TOOLPATH)/as
LD = $(TOOLPATH)/ld
CC = aarch64-linux-gnu-gcc  # Use cross-compiler directly
CFLAGS = -g
LDFLAGS = -lm

# Source files
SOURCES = main.c shunting_yard.c square_root.s trig_functions.s logarithm.s exponent.s factorial.s basic_arithmetic_operations.s fibonacci.s
OBJECTS = $(patsubst %.s,%.o,$(filter %.s, $(SOURCES))) \
          $(patsubst %.c,%.o,$(filter %.c, $(SOURCES)))

# Target executable
TARGET = program

# Default target
all: $(TARGET)
	@echo "Cleaning up object files..."
	@$(MAKE) clean_objects

# Linking the final executable
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

# Compile C source files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Assemble Assembly source files
%.o: %.s
	$(AS) -o $@ $<

# Clean only object files
clean_objects:
	@rm -f $(OBJECTS)

# Clean up generated files (target and object files)
clean:
	rm -f $(OBJECTS) $(TARGET)
