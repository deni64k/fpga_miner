`define H0 32'h6a09e667
`define H1 32'hbb67ae85
`define H2 32'h3c6ef372
`define H3 32'ha54ff53a
`define H4 32'h510e527f
`define H5 32'h9b05688c
`define H6 32'h1f83d9ab
`define H7 32'h5be0cd19

`define K0  32'h428a2f98
`define K1  32'h71374491
`define K2  32'hb5c0fbcf
`define K3  32'he9b5dba5
`define K4  32'h3956c25b
`define K5  32'h59f111f1
`define K6  32'h923f82a4
`define K7  32'hab1c5ed5
`define K8  32'hd807aa98
`define K9  32'h12835b01
`define K10 32'h243185be
`define K11 32'h550c7dc3
`define K12 32'h72be5d74
`define K13 32'h80deb1fe
`define K14 32'h9bdc06a7
`define K15 32'hc19bf174
`define K16 32'he49b69c1
`define K17 32'hefbe4786
`define K18 32'hfc19dc6
`define K19 32'h240ca1cc
`define K20 32'h2de92c6f
`define K21 32'h4a7484aa
`define K22 32'h5cb0a9dc
`define K23 32'h76f988da
`define K24 32'h983e5152
`define K25 32'ha831c66d
`define K26 32'hb00327c8
`define K27 32'hbf597fc7
`define K28 32'hc6e00bf3
`define K29 32'hd5a79147
`define K30 32'h6ca6351
`define K31 32'h14292967
`define K32 32'h27b70a85
`define K33 32'h2e1b2138
`define K34 32'h4d2c6dfc
`define K35 32'h53380d13
`define K36 32'h650a7354
`define K37 32'h766a0abb
`define K38 32'h81c2c92e
`define K39 32'h92722c85
`define K40 32'ha2bfe8a1
`define K41 32'ha81a664b
`define K42 32'hc24b8b70
`define K43 32'hc76c51a3
`define K44 32'hd192e819
`define K45 32'hd6990624
`define K46 32'hf40e3585
`define K47 32'h106aa070
`define K48 32'h19a4c116
`define K49 32'h1e376c08
`define K50 32'h2748774c
`define K51 32'h34b0bcb5
`define K52 32'h391c0cb3
`define K53 32'h4ed8aa4a
`define K54 32'h5b9cca4f
`define K55 32'h682e6ff3
`define K56 32'h748f82ee
`define K57 32'h78a5636f
`define K58 32'h84c87814
`define K59 32'h8cc70208
`define K60 32'h90befffa
`define K61 32'ha4506ceb
`define K62 32'hbef9a3f7
`define K63 32'hc67178f2

`define decl_components(x) \
	int A_``x, B_``x, C_``x, D_``x, E_``x, F_``x, G_``x, H_``x, T1_``x, T2_``x;

`define sha_round_16(t, t1)                                                              \
   assign T1_``t1 = H_``t1 + sigma1(E_``t1) + ch(E_``t1, F_``t1, G_``t1) + `K``t + W``t; \
   assign T2_``t1 = sigma0(A_``t1) + maj(A_``t1, B_``t1, C_``t1);                        \
	assign H_``t   = G_``t1;           \
	assign G_``t   = F_``t1;           \
	assign F_``t   = E_``t1;           \
	assign E_``t   = D_``t1 + T1_``t1; \
	assign D_``t   = C_``t1;           \
	assign C_``t   = B_``t1;           \
	assign B_``t   = A_``t1;           \
	assign A_``t   = T1_``t1 + T2_``t1;

`define sha_round(t, t1, t2, t7, t15, t16)                                             \
  assign W``t   = W``t16 + gamma0(W``t15) + W``t7 + gamma1(W``t2);                     \
  assign T1_``t = H_``t1 + sigma1(E_``t1) + ch(E_``t1, F_``t1, G_``t1) + `K``t + W``t; \
  assign T2_``t = sigma0(A_``t1) + maj(A_``t1, B_``t1, C_``t1);                        \
  assign H_``t  = G_``t1;          \
  assign G_``t  = F_``t1;          \
  assign F_``t  = E_``t1;          \
  assign E_``t  = D_``t1 + T1_``t; \
  assign D_``t  = C_``t1;          \
  assign C_``t  = B_``t1;          \
  assign B_``t  = A_``t1;          \
  assign A_``t  = T1_``t + T2_``t;

//struct block_state {
//  uint merkle_root;
//  uint timestamp;
//  uint target_bits;
//  uint nonce;
//  uint A, B, C, D, E, F, G, H, T1, T2;
//  uint W16, W17, W19;
//  uint W16_K, W17_K, W19_K;
//};

//`define htonl(x)                                 \
//  ((((x) & 32'hff000000U) >> 24)                   \
//   | (((x) & 32'h00ff0000U) >>  8)                 \
//   | (((x) & 32'h0000ff00U) <<  8)                 \
//   | (((x) & 32'h000000ffU) << 24))
//
//`define ntohl(x)                                 \
//  ((((x) & 32'hff000000U) >> 24)                   \
//   | (((x) & 32'h00ff0000U) >>  8)                 \
//   | (((x) & 32'h0000ff00U) <<  8)                 \
//   | (((x) & 32'h000000ffU) << 24))

function int htonl(int x);
	return {x[7:0], x[15:8], x[23:16], x[31:24]};
endfunction: htonl

function int ntohl(int x);
	return {x[7:0], x[15:8], x[23:16], x[31:24]};
endfunction: ntohl

function int ch(int x, int y, int z);
	return (x & y) ^ (~x & z);
endfunction: ch

function int maj(int x, int y, int z);
	return (x & y) ^ (x & z) ^ (y & z);
endfunction: maj

function int sigma0(int x);
	// (x rightrotate 2) xor (x rightrotate 13) xor (x rightrotate 22)
	return {x[1:0], x[31:2]} ^ {x[12:0], x[31:13]} ^ {x[21:0], x[31:22]};
endfunction: sigma0

function int sigma1(int x);
	// (x rightrotate 6) xor (x rightrotate 11) xor (x rightrotate 25)
	return {x[5:0], x[31:6]} ^ {x[10:0], x[31:11]} ^ {x[24:0], x[31:25]};
endfunction: sigma1

function int gamma0(int x);
	// (w[i-15] rightrotate  7) xor (w[i-15] rightrotate 18) xor (w[i-15] rightshift  3)
	return {x[6:0], x[31:7]} ^ {x[17:0], x[31:18]} ^ (x >> 3);
endfunction: gamma0

function int gamma1(int x);
	// (w[i- 2] rightrotate 17) xor (w[i- 2] rightrotate 19) xor (w[i- 2] rightshift 10)
	return {x[16:0], x[31:17]} ^ {x[18:0], x[31:19]} ^ (x >> 10);
endfunction: gamma1

module sha256_init(
		output reg [7:0][31:0] qdigest);
	assign qdigest = {`H7, `H6, `H5, `H4, `H3, `H2, `H1, `H0};
endmodule: sha256_init

module sha256_block(
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

	`decl_components(_1)
	`decl_components(0)
	`decl_components(1)
	`decl_components(2)
	`decl_components(3)
	`decl_components(4)
	`decl_components(5)
	`decl_components(6)
	`decl_components(7)
	`decl_components(8)
	`decl_components(9)
	`decl_components(10)
	`decl_components(11)
	`decl_components(12)
	`decl_components(13)
	`decl_components(14)
	`decl_components(15)
	`decl_components(16)
	`decl_components(17)
	`decl_components(18)
	`decl_components(19)
	`decl_components(20)
	`decl_components(21)
	`decl_components(22)
	`decl_components(23)
	`decl_components(24)
	`decl_components(25)
	`decl_components(26)
	`decl_components(27)
	`decl_components(28)
	`decl_components(29)
	`decl_components(30)
	`decl_components(31)
	`decl_components(32)
	`decl_components(33)
	`decl_components(34)
	`decl_components(35)
	`decl_components(36)
	`decl_components(37)
	`decl_components(38)
	`decl_components(39)
	`decl_components(40)
	`decl_components(41)
	`decl_components(42)
	`decl_components(43)
	`decl_components(44)
	`decl_components(45)
	`decl_components(46)
	`decl_components(47)
	`decl_components(48)
	`decl_components(49)
	`decl_components(50)
	`decl_components(51)
	`decl_components(52)
	`decl_components(53)
	`decl_components(54)
	`decl_components(55)
	`decl_components(56)
	`decl_components(57)
	`decl_components(58)
	`decl_components(59)
	`decl_components(60)
	`decl_components(61)
	`decl_components(62)
	`decl_components(63)

	//$display("digest[0] = %08x", digest[0]);
	assign A__1 = digest[0];
	assign B__1 = digest[1];
	assign C__1 = digest[2];
	assign D__1 = digest[3];
	assign E__1 = digest[4];
	assign F__1 = digest[5];
	assign G__1 = digest[6];
	assign H__1 = digest[7];

   int W16, W17,      W19;

	int           W18,      W20, W21, W22, W23;
	int W24, W25, W26, W27, W28, W29, W30, W31;
	int W32, W33, W34, W35, W36, W37, W38, W39;
	int W40, W41, W42, W43, W44, W45, W46, W47;
	int W48, W49, W50, W51, W52, W53, W54, W55;
	int W56, W57, W58, W59, W60, W61, W62, W63;

	`sha_round_16(0,  _1)
	`sha_round_16(1,  0)
	`sha_round_16(2,  1)
	`sha_round_16(3,  2)
	`sha_round_16(4,  3)
	`sha_round_16(5,  4)
	`sha_round_16(6,  5)
	`sha_round_16(7,  6)
	`sha_round_16(8,  7)
	`sha_round_16(9,  8)
	`sha_round_16(10, 9)
	`sha_round_16(11, 10)
	`sha_round_16(12, 11)
	`sha_round_16(13, 12)
	`sha_round_16(14, 13)
	`sha_round_16(15, 14)
	`sha_round(16, 15, 14, 9,  1,  0)
	`sha_round(17, 16, 15, 10, 2,  1)
	`sha_round(18, 17, 16, 11, 3,  2)
	`sha_round(19, 18, 17, 12, 4,  3)
	`sha_round(20, 19, 18, 13, 5,  4)
	`sha_round(21, 20, 19, 14,  6,  5)
	`sha_round(22, 21, 20, 15,  7,  6)
	`sha_round(23, 22, 21, 16,  8,  7)
	`sha_round(24, 23, 22, 17,  9,  8)
	`sha_round(25, 24, 23, 18, 10,  9)
	`sha_round(26, 25, 24, 19, 11, 10)
	`sha_round(27, 26, 25, 20, 12, 11)
	`sha_round(28, 27, 26, 21, 13, 12)
	`sha_round(29, 28, 27, 22, 14, 13)
	`sha_round(30, 29, 28, 23, 15, 14)
	`sha_round(31, 30, 29, 24, 16, 15)
	`sha_round(32, 31, 30, 25, 17, 16)
	`sha_round(33, 32, 31, 26, 18, 17)
	`sha_round(34, 33, 32, 27, 19, 18)
	`sha_round(35, 34, 33, 28, 20, 19)
	`sha_round(36, 35, 34, 29, 21, 20)
	`sha_round(37, 36, 35, 30, 22, 21)
	`sha_round(38, 37, 36, 31, 23, 22)
	`sha_round(39, 38, 37, 32, 24, 23)
	`sha_round(40, 39, 38, 33, 25, 24)
	`sha_round(41, 40, 39, 34, 26, 25)
	`sha_round(42, 41, 40, 35, 27, 26)
	`sha_round(43, 42, 41, 36, 28, 27)
	`sha_round(44, 43, 42, 37, 29, 28)
	`sha_round(45, 44, 43, 38, 30, 29)
	`sha_round(46, 45, 44, 39, 31, 30)
	`sha_round(47, 46, 45, 40, 32, 31)
	`sha_round(48, 47, 46, 41, 33, 32)
	`sha_round(49, 48, 47, 42, 34, 33)
	`sha_round(50, 49, 48, 43, 35, 34)
	`sha_round(51, 50, 49, 44, 36, 35)
	`sha_round(52, 51, 50, 45, 37, 36)
	`sha_round(53, 52, 51, 46, 38, 37)
	`sha_round(54, 53, 52, 47, 39, 38)
	`sha_round(55, 54, 53, 48, 40, 39)
	`sha_round(56, 55, 54, 49, 41, 40)
	`sha_round(57, 56, 55, 50, 42, 41)
	`sha_round(58, 57, 56, 51, 43, 42)
	`sha_round(59, 58, 57, 52, 44, 43)
	`sha_round(60, 59, 58, 53, 45, 44)
	`sha_round(61, 60, 59, 54, 46, 45)
	`sha_round(62, 61, 60, 55, 47, 46)
	`sha_round(63, 62, 61, 56, 48, 47)

   assign qdigest = {
	      digest[7] + H_63, digest[6] + G_63, digest[5] + F_63, digest[4] + E_63,
	      digest[3] + D_63, digest[2] + C_63, digest[1] + B_63, digest[0] + A_63
	};

endmodule: sha256_block
