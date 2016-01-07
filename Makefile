URCUDIR ?= /usr/local

CC := gcc
LD := gcc


CFLAGS += -I$(URCUDIR)/include
CFLAGS += -D_REENTRANT
CFLAGS += -Wall -Winline
#CFLAGS += --param inline-unit-growth=1000
CFLAGS += -mrtm

#CFLAGS += -DHIDE_ALL_STATS

#CFLAGS += -O0 -g3
ifdef DEBUG
	CFLAGS += -O0 -g3
else
	CFLAGS += -DNDEBUG
	CFLAGS += -O3
endif

IS_HAZARD_PTRS_HARRIS = -DIS_HAZARD_PTRS_HARRIS
IS_HARRIS = -DIS_HARRIS
IS_RCU = -DIS_RCU
IS_RLU = -DIS_RLU
IS_W_LOCKS = -DIS_W_LOCKS

LDFLAGS += -L$(URCUDIR)/lib
LDFLAGS += -lpthread

BINS = bench-harris bench-hp-harris bench-rcu bench-rlu bench-lock test-lock

.PHONY:	all clean

all: $(BINS)

rlu.o: rlu.c rlu.h
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $<

new-urcu.o: new-urcu.c
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $<

hazard_ptrs.o: hazard_ptrs.c
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $<

hash-list.o: hash-list.c
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $<

hash-list-with-lock.o: hash-list-with-lock.c
	$(CC) $(CFLAGS) $(DEFINES) -c -o $@ $<

bench-harris.o: bench.c
	$(CC) $(CFLAGS) $(IS_HARRIS) $(DEFINES) -c -o $@ $<

bench-hp-harris.o: bench.c
	$(CC) $(CFLAGS) $(IS_HAZARD_PTRS_HARRIS) $(DEFINES) -c -o $@ $<

bench-rcu.o: bench.c
	$(CC) $(CFLAGS) $(IS_RCU) $(DEFINES) -c -o $@ $<

bench-rlu.o: bench.c
	$(CC) $(CFLAGS) $(IS_RLU) $(DEFINES) -c -o $@ $<

bench-lock.o: bench.c
	$(CC) $(CFLAGS) $(IS_W_LOCKS) $(DEFINES) -c -o $@ $<

test-lock.o: test-lock.c
	$(CC) $(CFLAGS) $(IS_W_LOCKS) $(DEFINES) -c -o $@ $<

bench-harris: new-urcu.o hazard_ptrs.o rlu.o hash-list.o bench-harris.o
	$(LD) -o $@ $^ $(LDFLAGS)

bench-hp-harris: new-urcu.o hazard_ptrs.o rlu.o hash-list.o bench-hp-harris.o
	$(LD) -o $@ $^ $(LDFLAGS)

bench-rcu: new-urcu.o hazard_ptrs.o rlu.o hash-list.o bench-rcu.o
	$(LD) -o $@ $^ $(LDFLAGS)

bench-rlu: new-urcu.o hazard_ptrs.o rlu.o hash-list.o bench-rlu.o
	$(LD) -o $@ $^ $(LDFLAGS)

bench-lock: new-urcu.o hazard_ptrs.o rlu.o hash-list.o hash-list-with-lock.o bench-lock.o
	$(LD) -o $@ $^ $(LDFLAGS)

test-lock: hash-list-with-lock.o test-lock.o
	$(LD) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(BINS) *.o
