#
# Makefile
#
# Created by Nicholas Gallimore
# Copyright Virtual Theologies all rights reserved.


# compiler to use
CC = gcc

# flags to pass compiler
CFLAGS = -O2 -std=c99 -Werror

# name for executable
EXE = slope

# space-separated list of header files
HDRS = src/lib/cs50.h

# space-separated list of source files
SRCS = src/slope.c src/lib/cs50.c

# automatically generated list of object files
OBJS = $(SRCS:.c=.o)

# default target
$(EXE): $(OBJS) $(HDRS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

# dependencies 
$(OBJS): $(HDRS)

# housekeeping
clean:
	rm -f core $(EXE) *.o

