// Reflect priority

#include <inc/lib.h>

#define TIMES 10

void
umain(int argc, char **argv)
{
	int i;
	envid_t t = sys_getenvid();
	sys_env_enable_priority(1);
	sys_env_set_priority(t, ENV_PRIORITY_HIGH);
	for (i = 0; i < TIMES; i++) {
		cprintf("i am high priority env %08x [runs = %d]\n", t, sys_env_get_runs(t));
		sys_yield();
	}
	return;
}

