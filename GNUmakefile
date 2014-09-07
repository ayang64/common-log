# CFLAGS := -std=c99 -pipe -ggdb -MMD -W -Wall -DYYDEBUG=1
CFLAGS := -std=c99 -pipe -MMD -W -Wall -O3
FLEX_FLAGS := -F

.PHONY : clean

clp : common-log.tab.o common-log.yy.o
	$(CC) $^ -o $@ -ll -ly

common-log.tab.o common-log.yy.o : common-log.tab.h common-log.yy.h

common-log.yy.c common-log.yy.h :	common-log.l common-log.tab.c common-log.tab.h
	/usr/local/bin/flex $(FLEX_FLAGS) common-log.l

common-log.tab.c common-log.tab.h : common-log.y
	/usr/local/bin/bison -t --defines=common-log.tab.h common-log.y

clean :
	rm -f clp common-log-parse *.o common-log.tab.c common-log.tab.h common-log.yy.c common-log.yy.h *.d

-include *.d
