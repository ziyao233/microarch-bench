// SPDX-License-Identifier: AGPL-3.0-or-later

/*	Latency		*/
	.macro		latency_3reg	name,		opcode

	.global		latency_\name
latency_\name:
	.rept		BATCHSIZE
	\opcode		$a0,		$a0,		$a0
	.endr
	ret
	.endm

	latency_3reg	add_d,		add.d
	latency_3reg	add_w,		add.w
	latency_3reg	mul_d,		mul.d
	latency_3reg	mul_w,		mul.w
	latency_3reg	mulh_d,		mulh.d
	latency_3reg	mulh_w,		mulh.w
	latency_3reg	and,		and
	latency_3reg	sll_d,		sll.d
	latency_3reg	sll_w,		sll.w
	latency_3reg	rotr_d,		rotr.d
	latency_3reg	rotr_w,		rotr.w
	latency_3reg	crc_wbw		crc.w.b.w
	latency_3reg	crc_whw		crc.w.h.w
	latency_3reg	crc_www		crc.w.w.w
	latency_3reg	crc_wdw		crc.w.d.w

	.macro		latency_2reg	name,		opcode

	.global		latency_\name
latency_\name:
	.rept		BATCHSIZE
	\opcode		$a0,		$a0
	.endr
	ret
	.endm

	latency_2reg	clo_d,		clo.d
	latency_2reg	clo_w,		clo.w
	latency_2reg	cto_d,		cto.d
	latency_2reg	cto_w,		cto.w
	latency_2reg	revb_d,		revb.d
	latency_2reg	revh_d,		revh.d
	latency_2reg	bitrev_8b,	bitrev.8b
	latency_2reg	bitrev_d,	bitrev.d

	.global		latency_bytepick_d_0
latency_bytepick_d_0:
	.rept		BATCHSIZE
	bytepick.d	$a0,		$a0,		$t0,		0
	.endr
	ret

	.global		latency_bytepick_d_4
latency_bytepick_d_4:
	.rept		BATCHSIZE
	bytepick.d	$a0,		$a0,		$t0,		4
	.endr
	ret

	.global		latency_bytepick_w_0
latency_bytepick_w_0:
	.rept		BATCHSIZE
	bytepick.w	$a0,		$a0,		$t0,		0
	.endr
	ret

	.global		latency_bytepick_w_2
latency_bytepick_w_2:
	.rept		BATCHSIZE
	bytepick.w	$a0,		$a0,		$t0,		2
	.endr
	ret

	.macro		latency_str	name,	opcode,	msb,	lsb
	.global		latency_\name\()_\msb\()_\lsb
latency_\name\()_\msb\()_\lsb:
	.rept		BATCHSIZE
	\opcode		$a0,		$a0,		\msb,		\lsb
	.endr
	ret
	.endm

	latency_str	bstrins_d,	bstrins.d,	31,		0
	latency_str	bstrins_d,	bstrins.d,	47,		16
	latency_str	bstrins_w	bstrins.w,	15,		0
	latency_str	bstrins_w	bstrins.w	23,		8
	latency_str	bstrpick_d,	bstrpick.d,	31,		0
	latency_str	bstrpick_d,	bstrpick.d,	47,		16
	latency_str	bstrpick_w,	bstrpick.w,	15,		0
	latency_str	bstrpick_w,	bstrpick.w,	23,		8

	.global		latency_maskeqz
latency_maskeqz:
	.rept		BATCHSIZE
	maskeqz		$t0,		$t0,		$a0
	.endr
	ret

	.global		latency_div_d_add
latency_div_d_add:
	.rept		BATCHSIZE
	div.d		$a0,		$a0,		$a1
	add.d		$a0,		$a0,		$a2
	.endr
	ret

/*	Throughput	*/

	.macro		thrput_3reg	name,		opcode

	.global		thrput_\name
thrput_\name:
	.rept		BATCHSIZE / 32
	\opcode		$t0,		$a7,		$a0
	\opcode		$t1,		$a6,		$a1
	\opcode		$t2,		$a5,		$a2
	\opcode		$t3,		$a4,		$a3
	\opcode		$t4,		$a3,		$a4
	\opcode		$t5,		$a2,		$a5
	\opcode		$t6,		$a1,		$a6
	\opcode		$t7,		$a0,		$a7

	\opcode		$t0,		$a6,		$a0
	\opcode		$t1,		$a5,		$a1
	\opcode		$t2,		$a4,		$a2
	\opcode		$t3,		$a3,		$a3
	\opcode		$t4,		$a2,		$a4
	\opcode		$t5,		$a1,		$a5
	\opcode		$t6,		$a0,		$a6
	\opcode		$t7,		$a7,		$a7

	\opcode		$t0,		$a5,		$a0
	\opcode		$t1,		$a4,		$a1
	\opcode		$t2,		$a3,		$a2
	\opcode		$t3,		$a2,		$a3
	\opcode		$t4,		$a1,		$a4
	\opcode		$t5,		$a0,		$a5
	\opcode		$t6,		$a7,		$a6
	\opcode		$t7,		$a6,		$a7

	\opcode		$t0,		$a4,		$a0
	\opcode		$t1,		$a3,		$a1
	\opcode		$t2,		$a2,		$a2
	\opcode		$t3,		$a1,		$a3
	\opcode		$t4,		$a0,		$a4
	\opcode		$t5,		$a7,		$a5
	\opcode		$t6,		$a6,		$a6
	\opcode		$t7,		$a5,		$a7
	.endr
	ret
	.endm

	thrput_3reg	add_d,		add.d
	thrput_3reg	add_w,		add.w
	thrput_3reg	mul_d,		mul.d
	thrput_3reg	mul_w,		mul.w
	thrput_3reg	mulh_d,		mulh.d
	thrput_3reg	mulh_w,		mulh.w
	thrput_3reg	and,		and
	thrput_3reg	sll_d,		sll.d
	thrput_3reg	sll_w,		sll.w
	thrput_3reg	rotr_d,		rotr.d
	thrput_3reg	rotr_w,		rotr.w
	thrput_3reg	crc_wbw,	crc.w.b.w
	thrput_3reg	crc_whw,	crc.w.h.w
	thrput_3reg	crc_www,	crc.w.w.w
	thrput_3reg	crc_wdw,	crc.w.d.w

	.macro		thrput_2reg	name,		opcode

	.global		thrput_\name
thrput_\name:
	.rept		BATCHSIZE / 16

	\opcode		$t0,		$a0
	\opcode		$t1,		$a1
	\opcode		$t2,		$a2
	\opcode		$t3,		$a3
	\opcode		$t4,		$a4
	\opcode		$t5,		$a5
	\opcode		$t6,		$a6
	\opcode		$t7,		$a7

	\opcode		$t0,		$s0
	\opcode		$t1,		$s1
	\opcode		$t2,		$s2
	\opcode		$t3,		$s3
	\opcode		$t4,		$s4
	\opcode		$t5,		$s5
	\opcode		$t6,		$s6
	\opcode		$t7,		$s7

	.endr
	ret
	.endm

	thrput_2reg	clo_d,		clo.d
	thrput_2reg	clo_w,		clo.w
	thrput_2reg	cto_d,		cto.d
	thrput_2reg	cto_w,		cto.w
	thrput_2reg	revb_d,		revb.d
	thrput_2reg	revh_d,		revh.d
	thrput_2reg	bitrev_8b,	bitrev.8b
	thrput_2reg	bitrev_d,	bitrev.d

	.global		thrput_bytepick_d
thrput_bytepick_d:
	.rept		BATCHSIZE / 16
	bytepick.d	$t0,		$a0,		$s0,		0
	bytepick.d	$t1,		$a1,		$s1,		1
	bytepick.d	$t2,		$a2,		$s2,		2
	bytepick.d	$t3,		$a3,		$s3,		3
	bytepick.d	$t4,		$a4,		$s4,		4
	bytepick.d	$t5,		$a5,		$s5,		5
	bytepick.d	$t6,		$a6,		$s6,		6
	bytepick.d	$t7,		$a7,		$s7,		7

	bytepick.d	$t0,		$a0,		$s0,		7
	bytepick.d	$t1,		$a1,		$s1,		6
	bytepick.d	$t2,		$a2,		$s2,		5
	bytepick.d	$t3,		$a3,		$s3,		4
	bytepick.d	$t4,		$a4,		$s4,		3
	bytepick.d	$t5,		$a5,		$s5,		2
	bytepick.d	$t6,		$a6,		$s6,		1
	bytepick.d	$t7,		$a7,		$s7,		0
	.endr

	ret

	.global		thrput_bytepick_w
thrput_bytepick_w:
	.rept		BATCHSIZE / 16
	bytepick.w	$t0,		$a0,		$s0,		0
	bytepick.w	$t1,		$a1,		$s1,		1
	bytepick.w	$t2,		$a2,		$s2,		2
	bytepick.w	$t3,		$a3,		$s3,		3
	bytepick.w	$t4,		$a4,		$s4,		0
	bytepick.w	$t5,		$a5,		$s5,		1
	bytepick.w	$t6,		$a6,		$s6,		2
	bytepick.w	$t7,		$a7,		$s7,		3

	bytepick.w	$t0,		$a0,		$s0,		3
	bytepick.w	$t1,		$a1,		$s1,		2
	bytepick.w	$t2,		$a2,		$s2,		1
	bytepick.w	$t3,		$a3,		$s3,		0
	bytepick.w	$t4,		$a4,		$s4,		3
	bytepick.w	$t5,		$a5,		$s5,		2
	bytepick.w	$t6,		$a6,		$s6,		1
	bytepick.w	$t7,		$a7,		$s7,		0
	.endr

	ret

	.macro		thrput_str	name,	opcode,	msb,	lsb
	.global		thrput_\name\()_\msb\()_\lsb
thrput_\name\()_\msb\()_\lsb:
	.rept		BATCHSIZE / 16
	\opcode		$t0,		$s0,		\msb,		\lsb
	\opcode		$t1,		$s1,		\msb,		\lsb
	\opcode		$t2,		$s2,		\msb,		\lsb
	\opcode		$t3,		$s3,		\msb,		\lsb
	\opcode		$t4,		$s4,		\msb,		\lsb
	\opcode		$t5,		$s5,		\msb,		\lsb
	\opcode		$t6,		$s6,		\msb,		\lsb
	\opcode		$t7,		$s7,		\msb,		\lsb

	\opcode		$a0,		$s0,		\msb,		\lsb
	\opcode		$a1,		$s1,		\msb,		\lsb
	\opcode		$a2,		$s2,		\msb,		\lsb
	\opcode		$a3,		$s3,		\msb,		\lsb
	\opcode		$a4,		$s4,		\msb,		\lsb
	\opcode		$a5,		$s5,		\msb,		\lsb
	\opcode		$a6,		$s6,		\msb,		\lsb
	\opcode		$a7,		$s7,		\msb,		\lsb
	.endr

	ret
	.endm

	thrput_str	bstrins_d,	bstrins.d,	31,		0
	thrput_str	bstrins_d,	bstrins.d,	47,		16
	thrput_str	bstrins_w,	bstrins.w,	15,		0
	thrput_str	bstrins_w,	bstrins.w,	23,		8
	thrput_str	bstrpick_d,	bstrpick.d,	31,		0
	thrput_str	bstrpick_d,	bstrpick.d,	47,		16
	thrput_str	bstrpick_w,	bstrpick.w,	15,		0
	thrput_str	bstrpick_w,	bstrpick.w,	23,		8

	.global		thrput_maskeqz
thrput_maskeqz:
	.rept		BATCHSIZE / 8
	maskeqz		$t0,		$s0,		$a0
	maskeqz		$t1,		$s1,		$a1
	maskeqz		$t2,		$s2,		$a2
	maskeqz		$t3,		$s3,		$a3
	maskeqz		$t4,		$s4,		$a4
	maskeqz		$t5,		$s5,		$a5
	maskeqz		$t6,		$s6,		$a6
	maskeqz		$t7,		$s7,		$a7
	.endr
	ret

	.global		thrput_div_d
thrput_div_d:
	.rept		BATCHSIZE / 8
	div.d		$t0,		$a0,		$a1
	div.d		$t1,		$a0,		$a1
	div.d		$t2,		$a0,		$a1
	div.d		$t3,		$a0,		$a1
	div.d		$t4,		$a0,		$a1
	div.d		$t5,		$a0,		$a1
	div.d		$t6,		$a0,		$a1
	div.d		$t7,		$a0,		$a1
	.endr
	ret

	.global		thrput_nop
thrput_nop:
	.rept		BATCHSIZE
	nop
	.endr
	ret
