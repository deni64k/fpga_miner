`include "sha256_common.sv"
`include "sha256.sv"

module bitcoin_miner(
		input clk,
		input rst,
		output reg [7:0][31:0] qdigest,
		output int nonce);

	reg [7:0][31:0] digest_init;
	reg [7:0][31:0] digest_first_block;
	reg [7:0][31:0] digest_second_block;
	reg [7:0][31:0] digest_block;

	always @ (posedge clk) begin
		sha256_init(digest_init);

		//	defparameter version     = 32'h00000002
		// prev_block  = 00000000_00000001_17c80378_b8da0e33_559b5997_f2ad55e2_f7d18ec1_975b9717
		// merkle_root = 871714dc_bae6c819_3a2bb9b2_a69fe1c0_440399f3_8d94b3a0_f1b44727_5a29978a
		// timestamp   = 32'h53058b35
		// bits        = 32'h19015f53
		// nonce       = 32'h33087548

		sha256_block(
			.digest(digest_init),
			// Version
			.W0 (htonl(32'h00000002)),
			// Previous block
			.W1 (htonl(32'h975b9717)),
			.W2 (htonl(32'hf7d18ec1)),
			.W3 (htonl(32'hf2ad55e2)),
			.W4 (htonl(32'h559b5997)),
			.W5 (htonl(32'hb8da0e33)),
			.W6 (htonl(32'h17c80378)),
			.W7 (htonl(32'h00000001)),
			.W8 (htonl(32'h00000000)),
			// Merkle root
			.W9 (htonl(32'h5a29978a)),
			.W10(htonl(32'hf1b44727)),
			.W11(htonl(32'h8d94b3a0)),
			.W12(htonl(32'h440399f3)),
			.W13(htonl(32'ha69fe1c0)),
			.W14(htonl(32'h3a2bb9b2)),
			.W15(htonl(32'hbae6c819)),
			.qdigest(digest_first_block));

		sha256_block(
			.digest(digest_first_block),
			// Merkle root (last int)
			.W0 (htonl(32'h871714dc)),
			// Timestamp
			.W1 (htonl(32'h53058b35)),
			// Target bits
			.W2 (htonl(32'h19015f53)),
			// Nonce
//			.W3 (htonl(32'h33087548)),
			.W3 (htonl(nonce)),
			// Padding
			.W4 (32'h80000000),
			.W5 (32'h00000000),
			.W6 (32'h00000000),
			.W7 (32'h00000000),
			.W8 (32'h00000000),
			.W9 (32'h00000000),
			.W10(32'h00000000),
			.W11(32'h00000000),
			.W12(32'h00000000),
			.W13(32'h00000000),
			.W14(32'h00000000),
			.W15(32'h00000280),
			.qdigest(digest_second_block));

		sha256_block(
			.digest(digest_init),
			.W0 (digest_second_block[0]),
			.W1 (digest_second_block[1]),
			.W2 (digest_second_block[2]),
			.W3 (digest_second_block[3]),
			.W4 (digest_second_block[4]),
			.W5 (digest_second_block[5]),
			.W6 (digest_second_block[6]),
			.W7 (digest_second_block[7]),
			.W8 (32'h80000000),
			.W9 (32'h00000000),
			.W10(32'h00000000),
			.W11(32'h00000000),
			.W12(32'h00000000),
			.W13(32'h00000000),
			.W14(32'h00000000),
			.W15(32'h00000100),
			.qdigest(qdigest));

		nonce <= nonce + 1;
	end
	
	always @ (posedge clk) begin
		$display("Calced %x\n", qdigest[3]);
	end
	
endmodule: bitcoin_miner

module bitcoin_miner_prenonce(
		input  int             version,
		input  reg [7:0][31:0] prev_block,
		input  reg [7:0][31:0] merkle_root,
		output reg [7:0][31:0] qdigest);

	reg [7:0][31:0] digest_init;

	initial
		sha256_init(
			.qdigest(digest_init));

	always @* begin

		sha256_block(
			.digest(digest_init),
			// Version
			.W0 (htonl(version)),
			// Previous block
			.W1 (htonl(prev_block[0])),
			.W2 (htonl(prev_block[1])),
			.W3 (htonl(prev_block[2])),
			.W4 (htonl(prev_block[3])),
			.W5 (htonl(prev_block[4])),
			.W6 (htonl(prev_block[5])),
			.W7 (htonl(prev_block[6])),
			.W8 (htonl(prev_block[7])),
			// Merkle root
			.W9 (htonl(merkle_root[0])),
			.W10(htonl(merkle_root[1])),
			.W11(htonl(merkle_root[2])),
			.W12(htonl(merkle_root[3])),
			.W13(htonl(merkle_root[4])),
			.W14(htonl(merkle_root[5])),
			.W15(htonl(merkle_root[6])),
			.qdigest(qdigest));
	end
endmodule: bitcoin_miner_prenonce

module bitcoin_miner_nonce(
		input  reg [7:0][31:0] digest,
		input  reg [7:0][31:0] merkle_root,
		input  int             timestamp,
		input  int             target_bits,
		input  int             nonce,
		output reg [7:0][31:0] qdigest);

	reg [7:0][31:0] digest_init;
	reg [7:0][31:0] digest_second_block;

	always @* begin
		sha256_block(
			.digest(digest),
			// Merkle root (last int)
			.W0 (htonl(merkle_root[7])),
			// Timestamp
			.W1 (htonl(timestamp)),
			// Target bits
			.W2 (htonl(target_bits)),
			// Nonce
			.W3 (htonl(nonce)),
			// Padding
			.W4 (32'h80000000),
			.W5 (32'h00000000),
			.W6 (32'h00000000),
			.W7 (32'h00000000),
			.W8 (32'h00000000),
			.W9 (32'h00000000),
			.W10(32'h00000000),
			.W11(32'h00000000),
			.W12(32'h00000000),
			.W13(32'h00000000),
			.W14(32'h00000000),
			.W15(32'h00000280),
			.qdigest(digest_second_block));

		sha256_init(
			.qdigest(digest_init));

		sha256_block(
			.digest(digest_init),
			.W0 (digest_second_block[0]),
			.W1 (digest_second_block[1]),
			.W2 (digest_second_block[2]),
			.W3 (digest_second_block[3]),
			.W4 (digest_second_block[4]),
			.W5 (digest_second_block[5]),
			.W6 (digest_second_block[6]),
			.W7 (digest_second_block[7]),
			.W8 (32'h80000000),
			.W9 (32'h00000000),
			.W10(32'h00000000),
			.W11(32'h00000000),
			.W12(32'h00000000),
			.W13(32'h00000000),
			.W14(32'h00000000),
			.W15(32'h00000100),
			.qdigest(qdigest));
	end
endmodule: bitcoin_miner_nonce

module bitcoin_miner_test(
		output reg [7:0][31:0] qdigest,
		output reg [7:0][31:0] qdigest_prenonce,
		output reg [7:0][31:0] qdigest_nonce);

	reg [7:0][31:0] digest_init;

	initial
		sha256_init(
			.qdigest(digest_init));

		
	initial begin
		sha256_block(
			.digest(digest_init),
			.W0 (32'h80000000),
			.W1 (32'h00000000),
			.W2 (32'h00000000),
			.W3 (32'h00000000),
			.W4 (32'h00000000),
			.W5 (32'h00000000),
			.W6 (32'h00000000),
			.W7 (32'h00000000),
			.W8 (32'h00000000),
			.W9 (32'h00000000),
			.W10(32'h00000000),
			.W11(32'h00000000),
			.W12(32'h00000000),
			.W13(32'h00000000),
			.W14(32'h00000000),
			.W15(32'h00000000),
			.qdigest(qdigest));
		// qdigest should be 7852b855 a495991b 649b934c 27ae41e4 996fb924 9afbf4c8 98fc1c14 e3b0c442
		// Or e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
	end
		// https://btc.com/0000000000000000e067a478024addfecdc93628978aa52d91fabd4292982a50
		bitcoin_miner_prenonce bitcoin_test_prenonce(
			.version(32'h00000002),
			.prev_block(256'h00000000_00000001_17c80378_b8da0e33_559b5997_f2ad55e2_f7d18ec1_975b9717),
			.merkle_root(256'h871714dc_bae6c819_3a2bb9b2_a69fe1c0_440399f3_8d94b3a0_f1b44727_5a29978a),
			.qdigest(qdigest_prenonce));
		// qdigest_prenonce should be fc48d2df 95f0172e 4cbb9b8f c3c1b9e4 e536f7d5 cb1a5434 0c69421a dc6a3b8d
		bitcoin_miner_nonce bitcoin_test_nonce(
			.digest(qdigest_prenonce),
			.merkle_root(256'h871714dc_bae6c819_3a2bb9b2_a69fe1c0_440399f3_8d94b3a0_f1b44727_5a29978a),
			.timestamp(32'h53058b35),  // 2014-02-19 23:57:25
			.target_bits(32'h19015f53),
			.nonce(32'h33087548),
			.qdigest(qdigest_nonce));
		// qdigest_nonce should be 00000000 00000000 78a467e0 fedd4a02 2836c9cd 2da58a97 42bdfa91 502a9892
		// Or 0000000000000000e067a478024addfecdc93628978aa52d91fabd4292982a50
	//end
endmodule: bitcoin_miner_test
