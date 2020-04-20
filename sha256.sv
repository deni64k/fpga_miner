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

`endif
