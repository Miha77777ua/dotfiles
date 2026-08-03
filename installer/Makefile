CC = cc
CFLAGS = -Wall
LDLIBS = -lncurses -lmenu

SRC := src/main.c
OBJ := build/main.o

TARGET = installer

all: $(TARGET)

$(TARGET): $(OBJ) 
	$(CC) $(OBJ) $(LDLIBS) -o $@

$(OBJ): $(SRC)
	mkdir -p build
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)

.PHONY: all clean
