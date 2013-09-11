
LEX			:=	/home/ayan/usr/bin/flex
CFLAGS	:=	-std=gnu99 -W -Wall -MMD -pipe

.PHONY : clean

common-log : common-log.yy.o buf.o
	$(CC) $(CFLAGS) $^ -o $@ -ll

common-log.yy.c common-log.yy.h : common-log.l
	$(LEX) $^

clean:
	rm -f common-log common-log.yy.* *.o *.d
