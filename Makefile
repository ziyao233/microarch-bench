CC		= $(CROSS_COMPILE)cc
CCLD		= $(CC)
CCAS		= $(CC)
ARCH		= $(shell uname -m)

BATCHES		= 512
MYCFLAGS	= $(CFLAGS) -O3 -std=gnu99 -DBATCHSIZE=$(BATCHES)
MYCCASFLAGS	= $(MYCFLAGS)
MYLDFLAGS	= $(LDFLAGS)

OBJS		= main.o
OBJS		+= $(patsubst %.S,%.o,$(wildcard $(ARCH)/*.S))

.PHONY: default

default: microarch-bench

microarch-bench: $(OBJS)
	$(CCLD) $(OBJS) -o $@ $(MYLDFLAGS)

%.o: %.c
	$(CC) $< -c -o $@ $(MYCFLAGS)

%.o: %.S
	$(CCAS) $< -c -o $@ $(MYCCASFLAGS)

clean:
	-rm $(OBJS)
