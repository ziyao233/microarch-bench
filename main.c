// SPDX-License-Identifier: AGPL-3.0-or-later

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define S_TO_NS(x)	((x) * 1000 * 1000 * 1000)
#define NS_TO_S(x)	(((x) + .0) / 1000 / 1000 / 1000)
#define _DO_PRAGMA(x)	_Pragma(#x)
#define DO_PRAGMA(x)	_DO_PRAGMA(x)

unsigned long batches, frequency, warmupBatches;

static void
item_begin(struct timespec *ts1)
{
	clock_gettime(CLOCK_MONOTONIC, ts1);
}

static void
item_end(const char *name, struct timespec *ts1)
{
	struct timespec ts2;

	clock_gettime(CLOCK_MONOTONIC, &ts2);

	unsigned long long ns = S_TO_NS(ts2.tv_sec) + ts2.tv_nsec;
	ns -= S_TO_NS(ts1->tv_sec) + ts1->tv_nsec;

	unsigned long instructions = BATCHSIZE * batches;
	double cycles = frequency * NS_TO_S(ns);
	printf("%s: IPC/CPI = %.2f/%.2f\n", name,
	       instructions / cycles, cycles / instructions);
}

#define dotest(name, func, ...) do { \
	for (unsigned long int i = 0; i < warmupBatches; i++)		\
		func(__VA_ARGS__);					\
									\
	struct timespec ts;						\
	item_begin(&ts);						\
									\
	for (unsigned long int i = 0; i < batches; i++)			\
		func(__VA_ARGS__);					\
									\
	item_end(name, &ts);						\
} while (0)

void latency_add_d(void);
void latency_add_w(void);
void latency_mul_d(void);
void latency_mul_w(void);
void latency_mulh_d(void);
void latency_mulh_w(void);
void latency_and(void);
void latency_sll_d(void);
void latency_sll_w(void);
void latency_rotr_d(void);
void latency_rotr_w(void);
void latency_clo_d(void);
void latency_clo_w(void);
void latency_cto_d(void);
void latency_cto_w(void);
void latency_bytepick_d_0(void);
void latency_bytepick_d_4(void);
void latency_bytepick_w_0(void);
void latency_bytepick_w_2(void);
void latency_revb_d(void);
void latency_revh_d(void);
void latency_bitrev_8b(void);
void latency_bitrev_d(void);
void latency_bstrins_d_31_0(void);
void latency_bstrins_d_47_16(void);
void latency_bstrins_w_15_0(void);
void latency_bstrins_w_23_8(void);
void latency_bstrpick_d_31_0(void);
void latency_bstrpick_d_47_16(void);
void latency_bstrpick_w_15_0(void);
void latency_bstrpick_w_23_8(void);
void latency_maskeqz(unsigned long a);
void latency_crc_wbw(void);
void latency_crc_whw(void);
void latency_crc_www(void);
void latency_crc_wdw(void);
void latency_div_d_add(long int dividend, long int divisor, long int diff);

void thrput_add_d(void);
void thrput_add_w(void);
void thrput_mul_d(void);
void thrput_mul_w(void);
void thrput_mulh_d(void);
void thrput_mulh_w(void);
void thrput_and(void);
void thrput_sll_d(void);
void thrput_sll_w(void);
void thrput_rotr_d(void);
void thrput_rotr_w(void);
void thrput_clo_d(void);
void thrput_clo_w(void);
void thrput_cto_d(void);
void thrput_cto_w(void);
void thrput_bytepick_d(void);
void thrput_bytepick_w(void);
void thrput_revb_d(void);
void thrput_revh_d(void);
void thrput_bitrev_8b(void);
void thrput_bitrev_d(void);
void thrput_bstrins_d_31_0(void);
void thrput_bstrins_d_47_16(void);
void thrput_bstrins_w_15_0(void);
void thrput_bstrins_w_23_8(void);
void thrput_bstrpick_d_31_0(void);
void thrput_bstrpick_d_47_16(void);
void thrput_bstrpick_w_15_0(void);
void thrput_bstrpick_w_23_8(void);
void thrput_maskeqz(unsigned long a1, unsigned long a2, unsigned long a3,
		    unsigned long a4, unsigned long a5, unsigned long a6,
		    unsigned long a7, unsigned long a8);
void thrput_crc_wbw(void);
void thrput_crc_whw(void);
void thrput_crc_www(void);
void thrput_crc_wdw(void);
void thrput_div_d(long a0, long a1);

void thrput_nop(void);

int
main(int argc, const char *argv[])
{
	if (argc != 4) {
		fprintf(stderr,
			"Usage: %s <BATCHES> <FREQ> <WARMUP-BATCHES>\n",
			argv[0]);
		return 0;
	}

	batches = atol(argv[1]);
	frequency = atol(argv[2]);
	warmupBatches = atol(argv[3]);

	printf("batches %lu, frequency = %lu Hz, warmup for %lu batches\n",
	       batches, frequency, warmupBatches);

	dotest("add.d latency", latency_add_d);
	dotest("add.w latency", latency_add_w);
	dotest("mul.d latency", latency_mul_d);
	dotest("mul.w latency", latency_mul_w);
	dotest("mulh.d latency", latency_mulh_d);
	dotest("mulh.w latency", latency_mulh_w);
	dotest("and latency", latency_and);
	dotest("sll.d latency", latency_sll_d);
	dotest("sll.w latency", latency_sll_w);
	dotest("rotr.d latency", latency_rotr_d);
	dotest("rotr.w latency", latency_rotr_w);
	dotest("clo.d latency", latency_clo_d);
	dotest("clo.w latency", latency_clo_w);
	dotest("cto.d latency", latency_cto_d);
	dotest("cto.w latency", latency_cto_w);
	dotest("bytepick.d 0 latency", latency_bytepick_d_0);
	dotest("bytepick.d 4 latency", latency_bytepick_d_4);
	dotest("bytepick.w 0 latency", latency_bytepick_w_0);
	dotest("bytepick.w 2 latency", latency_bytepick_w_2);
	dotest("revb.d latency", latency_revb_d);
	dotest("revh.d latency", latency_revh_d);
	dotest("bitrev.8b latency", latency_bitrev_8b);
	dotest("bitrev.d latency", latency_bitrev_d);
	dotest("bstrins.d (31, 0) latency", latency_bstrins_d_31_0);
	dotest("bstrins.d (47, 16) latency", latency_bstrins_d_47_16);
	dotest("bstrins.w (15, 0) latency", latency_bstrins_w_15_0);
	dotest("bstrins.w (23, 8) latency", latency_bstrins_w_23_8);
	dotest("bstrpick.d (31, 0) latency", latency_bstrpick_d_31_0);
	dotest("bstrpick.d (47, 16) latency", latency_bstrpick_d_47_16);
	dotest("bstrpick.w (15, 0) latency", latency_bstrpick_w_15_0);
	dotest("bstrpick.w (23, 8) latency", latency_bstrpick_w_23_8);
	dotest("maskeqz masked/untaken latency", latency_maskeqz, 0);
	dotest("maskeqz unmasked/taken latency", latency_maskeqz, 1);
	dotest("crc.w.b.w latency", latency_crc_wbw);
	dotest("crc.w.h.w latency", latency_crc_whw);
	dotest("crc.w.w.w latency", latency_crc_www);
	dotest("crc.w.d.w latency", latency_crc_wdw);

	for (int i = 0; i < 64; i += 8) {
		long dividend = 1ULL << i;

		/*
		 * 16 > 3 * 3 so we could always verify against the most common
		 * cases of early termination, where dividend is less than
		 * divisor.
		 */
		for (long divisor = 1; divisor < dividend * 16; divisor *= 3) {
			char msg[256];
			snprintf(msg, 256, "div.d %ld %ld & add latency",
				 dividend, divisor);

			dotest(msg, latency_div_d_add, dividend, divisor,
			       dividend - dividend / divisor);
		}
	}

	dotest("add.d throughput", thrput_add_d);
	dotest("add.w throughput", thrput_add_w);
	dotest("mul.d throughput", thrput_mul_d);
	dotest("mul.w throughput", thrput_mul_w);
	dotest("mulh.d throughput", thrput_mulh_d);
	dotest("mulh.w throughput", thrput_mulh_w);
	dotest("and throughput", thrput_and);
	dotest("sll.d throughput", thrput_sll_d);
	dotest("sll.w throughput", thrput_sll_w);
	dotest("rotr.d throughput", thrput_rotr_d);
	dotest("rotr.w throughput", thrput_rotr_w);
	dotest("clo.d throughput", thrput_clo_d);
	dotest("clo.w throughput", thrput_clo_w);
	dotest("cto.d throughput", thrput_cto_d);
	dotest("cto.w throughput", thrput_cto_w);
	dotest("bytepick.d throughput", thrput_bytepick_d);
	dotest("bytepick.w throughput", thrput_bytepick_w);
	dotest("revb.d throughput", thrput_revb_d);
	dotest("revh.d throughput", thrput_revh_d);
	dotest("bitrev.8b throughput", thrput_bitrev_8b);
	dotest("bitrev.d throughput", thrput_bitrev_d);
	dotest("bstrins.d (31, 0) throughput", thrput_bstrins_d_31_0);
	dotest("bstrins.d (47, 16) throughput", thrput_bstrins_d_47_16);
	dotest("bstrins.w (15, 0) throughput", thrput_bstrins_w_15_0);
	dotest("bstrins.w (23, 8) throughput", thrput_bstrins_w_23_8);
	dotest("bstrpick.d (31, 0) throughput", thrput_bstrpick_d_31_0);
	dotest("bstrpick.d (47, 16) throughput", thrput_bstrpick_d_47_16);
	dotest("bstrpick.w (15, 0) throughput", thrput_bstrpick_w_15_0);
	dotest("bstrpick.w (23, 8) throughput", thrput_bstrpick_w_23_8);
	dotest("maskeqz masked/untaken throughput", thrput_maskeqz,
	       0, 0, 0, 0, 0, 0, 0, 0);
	dotest("maskeqz unmasked/taken throughput", thrput_maskeqz,
	       1, 1, 1, 1, 1, 1, 1, 1);
	dotest("crc.w.b.w throughput", thrput_crc_wbw);
	dotest("crc.w.h.w throughput", thrput_crc_whw);
	dotest("crc.w.w.w throughput", thrput_crc_www);
	dotest("crc.w.d.w throughput", thrput_crc_wdw);

	for (int i = 0; i < 64; i += 8) {
		long dividend = 1ULL << i;

		for (long divisor = 1; divisor < dividend * 16; divisor *= 3) {
			char msg[256];
			snprintf(msg, 256, "div.d %ld %ld throughput",
				 dividend, divisor);

			dotest(msg, thrput_div_d, dividend, divisor);
		}
	}

	dotest("nop throughput", thrput_nop);

	return 0;
}
