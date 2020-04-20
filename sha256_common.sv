`ifndef SHA256_COMMON_SV
`define SHA256_COMMON_SV

`include "consts.sv"

//localparam reg [0:63][31:0] K = {
//	32'h428a2f98,
//	32'h71374491,
//	32'hb5c0fbcf,
//	32'he9b5dba5,
//	32'h3956c25b,
//	32'h59f111f1,
//	32'h923f82a4,
//	32'hab1c5ed5,
//	32'hd807aa98,
//	32'h12835b01,
//	32'h243185be,
//	32'h550c7dc3,
//	32'h72be5d74,
//	32'h80deb1fe,
//	32'h9bdc06a7,
//	32'hc19bf174,
//	32'he49b69c1,
//	32'hefbe4786,
//	32'hfc19dc6,
//	32'h240ca1cc,
//	32'h2de92c6f,
//	32'h4a7484aa,
//	32'h5cb0a9dc,
//	32'h76f988da,
//	32'h983e5152,
//	32'ha831c66d,
//	32'hb00327c8,
//	32'hbf597fc7,
//	32'hc6e00bf3,
//	32'hd5a79147,
//	32'h6ca6351,
//	32'h14292967,
//	32'h27b70a85,
//	32'h2e1b2138,
//	32'h4d2c6dfc,
//	32'h53380d13,
//	32'h650a7354,
//	32'h766a0abb,
//	32'h81c2c92e,
//	32'h92722c85,
//	32'ha2bfe8a1,
//	32'ha81a664b,
//	32'hc24b8b70,
//	32'hc76c51a3,
//	32'hd192e819,
//	32'hd6990624,
//	32'hf40e3585,
//	32'h106aa070,
//	32'h19a4c116,
//	32'h1e376c08,
//	32'h2748774c,
//	32'h34b0bcb5,
//	32'h391c0cb3,
//	32'h4ed8aa4a,
//	32'h5b9cca4f,
//	32'h682e6ff3,
//	32'h748f82ee,
//	32'h78a5636f,
//	32'h84c87814,
//	32'h8cc70208,
//	32'h90befffa,
//	32'ha4506ceb,
//	32'hbef9a3f7,
//	32'hc67178f2
//};

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
