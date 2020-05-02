`ifndef SHA256_SV
`define SHA256_SV

`include "consts.sv"
`include "sha256_common.sv"

// TODO: Recall what W1*_K are meant for.
//struct block_state {
//  uint merkle_root;
//  uint timestamp;
//  uint target_bits;
//  uint nonce;
//  uint A, B, C, D, E, F, G, H, T1, T2;
//  uint W16, W17, W19;
//  uint W16_K, W17_K, W19_K;
//};

task sha256_init(
		output reg [7:0][31:0] qdigest);
	parameter int H0 = 32'h6a09e667;
	parameter int H1 = 32'hbb67ae85;
	parameter int H2 = 32'h3c6ef372;
	parameter int H3 = 32'ha54ff53a;
	parameter int H4 = 32'h510e527f;
	parameter int H5 = 32'h9b05688c;
	parameter int H6 = 32'h1f83d9ab;
	parameter int H7 = 32'h5be0cd19;

	qdigest = {H7, H6, H5, H4, H3, H2, H1, H0};
endtask: sha256_init

task digest_cmp(
		input reg [7:0][31:0] digest,
		inout reg [7:0][31:0] qdigest);
	if      (digest[7] < qdigest[7])
		qdigest = digest;
	else if (digest[7] > qdigest[7])
		qdigest = qdigest;
	else if (digest[6] < qdigest[6])
		qdigest = digest;
	else if (digest[6] > qdigest[6])
		qdigest = qdigest;
	else if (digest[5] < qdigest[5])
		qdigest = digest;
	else if (digest[5] > qdigest[5])
		qdigest = qdigest;
	else if (digest[4] < qdigest[4])
		qdigest = digest;
	else if (digest[4] > qdigest[4])
		qdigest = qdigest;
	else if (digest[3] < qdigest[3])
		qdigest = digest;
	else if (digest[3] > qdigest[3])
		qdigest = qdigest;
	else if (digest[2] < qdigest[2])
		qdigest = digest;
	else if (digest[2] > qdigest[2])
		qdigest = qdigest;
	else if (digest[1] < qdigest[1])
		qdigest = digest;
	else if (digest[1] > qdigest[1])
		qdigest = qdigest;
	else if (digest[0] < qdigest[0])
		qdigest = digest;
	else if (digest[0] > qdigest[0])
		qdigest = qdigest;
	else
		qdigest = qdigest;
endtask: digest_cmp

task sha256_block(
		input reg [7:0][31:0] digest,
		input int W0,
		input int W1,
		input int W2,
		input int W3,
		input int W4,
		input int W5,
		input int W6,
		input int W7,
		input int W8,
		input int W9,
		input int W10,
		input int W11,
		input int W12,
		input int W13,
		input int W14,
		input int W15,
		output reg [7:0][31:0] qdigest);
		
	typedef struct packed {
		reg [63:0][31:0] W;
		reg [63:0][31:0] A;
		reg [63:0][31:0] B;
		reg [63:0][31:0] C;
		reg [63:0][31:0] D;
		reg [63:0][31:0] E;
		reg [63:0][31:0] F;
		reg [63:0][31:0] G;
		reg [63:0][31:0] H;
	} sha256_state_t;

	sha256_state_t state;
	state.W[15:0] = {W15, W14, W13, W12, W11, W10, W9, W8,
						  W7,  W6,  W5,  W4,  W3,  W2,  W1, W0};

	sha_round_1(0, digest, state);

//	genvar i;
//	for (i = 1; i < 15; i = i + 1) begin : upto_16
//		sha_round_16(i, state);
//	end
//
//	for (i = 16; i < 63; i = i + 1) begin : upto_64
//		sha_round(i, state);
//	end

	sha_round_16(1,  state);
	sha_round_16(2,  state);
	sha_round_16(3,  state);
	sha_round_16(4,  state);
	sha_round_16(5,  state);
	sha_round_16(6,  state);
	sha_round_16(7,  state);
	sha_round_16(8,  state);
	sha_round_16(9,  state);
	sha_round_16(10, state);
	sha_round_16(11, state);
	sha_round_16(12, state);
	sha_round_16(13, state);
	sha_round_16(14, state);
	sha_round_16(15, state);

	sha_round(16, state);
	sha_round(17, state);
	sha_round(18, state);
	sha_round(19, state);
	sha_round(20, state);
	sha_round(21, state);
	sha_round(22, state);
	sha_round(23, state);
	sha_round(24, state);
	sha_round(25, state);
	sha_round(26, state);
	sha_round(27, state);
	sha_round(28, state);
	sha_round(29, state);
	sha_round(30, state);
	sha_round(31, state);
	sha_round(32, state);
	sha_round(33, state);
	sha_round(34, state);
	sha_round(35, state);
	sha_round(36, state);
	sha_round(37, state);
	sha_round(38, state);
	sha_round(39, state);
	sha_round(40, state);
	sha_round(41, state);
	sha_round(42, state);
	sha_round(43, state);
	sha_round(44, state);
	sha_round(45, state);
	sha_round(46, state);
	sha_round(47, state);
	sha_round(48, state);
	sha_round(49, state);
	sha_round(50, state);
	sha_round(51, state);
	sha_round(52, state);
	sha_round(53, state);
	sha_round(54, state);
	sha_round(55, state);
	sha_round(56, state);
	sha_round(57, state);
	sha_round(58, state);
	sha_round(59, state);
	sha_round(60, state);
	sha_round(61, state);
	sha_round(62, state);
	sha_round(63, state);

   qdigest = {
	      digest[7] + state.H[63], digest[6] + state.G[63], digest[5] + state.F[63], digest[4] + state.E[63],
	      digest[3] + state.D[63], digest[2] + state.C[63], digest[1] + state.B[63], digest[0] + state.A[63]
	};

endtask: sha256_block

task sha_once_round_1(
		reg [7:0][31:0] digest,
		inout sha256_round_state_t state);
	int T1, T2;
	T1 = digest[7] + sigma1(digest[4]) + ch(digest[4], digest[5], digest[6]) + K[0] + state.W[0];
	T2 = sigma0(digest[0]) + maj(digest[0], digest[1], digest[2]);
	state.H   = digest[6];
	state.G   = digest[5];
	state.F   = digest[4];
	state.E   = digest[3] + T1;
	state.D   = digest[2];
	state.C   = digest[1];
	state.B   = digest[0];
	state.A   = T1 + T2;
endtask: sha_once_round_1

task sha_once_round_16(
		input int i,
		inout sha256_round_state_t state);
	int T1, T2;
//	for (i = 1; i < 16; i++) begin
		T1 = state.H + sigma1(state.E) + ch(state.E, state.F, state.G) + K[i] + state.W[i];
		T2 = sigma0(state.A) + maj(state.A, state.B, state.C);
		state.H   = state.G;
		state.G   = state.F;
		state.F   = state.E;
		state.E   = state.D + T1;
		state.D   = state.C;
		state.C   = state.B;
		state.B   = state.A;
		state.A   = T1 + T2;
//	end
endtask: sha_once_round_16

task sha_once_round(
		input int t,
		inout sha256_round_state_t state);
	int T1, T2;
	state.W[t] = state.W[t-16] + gamma0(state.W[t-15]) + state.W[t-7] + gamma1(state.W[t-2]);
	T1 = state.H + sigma1(state.E) + ch(state.E, state.F, state.G) + K[t] + state.W[t];
	T2 = sigma0(state.A) + maj(state.A, state.B, state.C);
	state.H   = state.G;
	state.G   = state.F;
	state.F   = state.E;
	state.E   = state.D + T1;
	state.D   = state.C;
	state.C   = state.B;
	state.B   = state.A;
	state.A   = T1 + T2;
endtask: sha_once_round

task sha256_round_block(
		inout int round,
		input int W0,
		input int W1,
		input int W2,
		input int W3,
		input int W4,
		input int W5,
		input int W6,
		input int W7,
		input int W8,
		input int W9,
		input int W10,
		input int W11,
		input int W12,
		input int W13,
		input int W14,
		input int W15,
		inout sha256_round_state_t state,
		inout reg [7:0][31:0] qdigest,
		output logic qfinish);

	if (round == 0) begin
		state.W[15:0] = {W15, W14, W13, W12, W11, W10, W9, W8,
							  W7,  W6,  W5,  W4,  W3,  W2,  W1, W0};
		sha_once_round_1(qdigest, state);
//		round = 1;
//		qfinish = 0;
//	end else if (round == 1) begin
		sha_once_round_16(1, state);
		sha_once_round_16(2, state);
		sha_once_round_16(3, state);
		sha_once_round_16(4, state);
		sha_once_round_16(5, state);
		sha_once_round_16(6, state);
		sha_once_round_16(7, state);
//		round = 8;
//		qfinish = 0;
//	end else if (round == 8) begin
		sha_once_round_16(8, state);
		sha_once_round_16(9, state);
		sha_once_round_16(10, state);
		sha_once_round_16(11, state);
		sha_once_round_16(12, state);
		sha_once_round_16(13, state);
		sha_once_round_16(14, state);
		sha_once_round_16(15, state);
		round = 16;
		qfinish = 0;
	end else begin
		sha_once_round(round, state);
		round = round + 1;

		if (round == 64) begin
			qdigest = {
				qdigest[7] + state.H, qdigest[6] + state.G, qdigest[5] + state.F, qdigest[4] + state.E,
				qdigest[3] + state.D, qdigest[2] + state.C, qdigest[1] + state.B, qdigest[0] + state.A
			};
			qfinish = 1;
		end else begin
			qdigest = qdigest;
			qfinish = 0;
		end
	end
endtask: sha256_round_block

`endif
