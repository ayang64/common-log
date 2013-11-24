CFLAGS := -std=c99 -pipe -g -MMD -W -Wall -DYYDEBUG=1

.PHONY : clean

clp : common-log.tab.o common-log.yy.o
	$(CC) $^ -o $@ -ll -ly

common-log.tab.o common-log.yy.o : common-log.tab.h common-log.yy.h

common-log.yy.c common-log.yy.h :	common-log.l common-log.tab.c common-log.tab.h
	/usr/local/bin/flex common-log.l

common-log.tab.c common-log.tab.h : common-log.y
	/usr/local/bin/bison -t --defines=common-log.tab.h common-log.y

clean :
	rm -f common-log-parse *.o common-log.tab.c common-log.tab.h common-log.yy.c common-log.yy.h *.d

-include *.d
