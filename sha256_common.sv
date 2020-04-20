`ifndef SHA256_COMMON_SV
`define SHA256_COMMON_SV

`include "consts.sv"

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

task sha_round_1(
		input int t,
		reg [7:0][31:0] digest,
		inout sha256_state_t state);

	int T1, T2;
	T1 = digest[7] + sigma1(digest[4]) + ch(digest[4], digest[5], digest[6]) + K[t] + state.W[t];
	T2 = sigma0(digest[0]) + maj(digest[0], digest[1], digest[2]);
	state.H[t]   = digest[6];
	state.G[t]   = digest[5];
	state.F[t]   = digest[4];
	state.E[t]   = digest[3] + T1;
	state.D[t]   = digest[2];
	state.C[t]   = digest[1];
	state.B[t]   = digest[0];
	state.A[t]   = T1 + T2;
	
endtask: sha_round_1

task sha_round_16(
		input int t,
		inout sha256_state_t state);

	int T1, T2;
	T1 = state.H[t-1] + sigma1(state.E[t-1]) + ch(state.E[t-1], state.F[t-1], state.G[t-1]) + K[t] + state.W[t];
	T2 = sigma0(state.A[t-1]) + maj(state.A[t-1], state.B[t-1], state.C[t-1]);
	state.H[t]   = state.G[t-1];
	state.G[t]   = state.F[t-1];
	state.F[t]   = state.E[t-1];
	state.E[t]   = state.D[t-1] + T1;
	state.D[t]   = state.C[t-1];
	state.C[t]   = state.B[t-1];
	state.B[t]   = state.A[t-1];
	state.A[t]   = T1 + T2;
	
endtask: sha_round_16

task sha_round(
		input int t,
		inout sha256_state_t state);

	state.W[t] = state.W[t-16] + gamma0(state.W[t-15]) + state.W[t-7] + gamma1(state.W[t-2]);
	sha_round_16(t, state);
	
endtask: sha_round

`endif
