module fpga_miner(
		input clock,
		input reset,
		output reg [7:0][31:0] qdigest);

	function int htonl(int x);
		return {x[7:0], x[15:8], x[23:16], x[31:24]};
	endfunction: htonl
	function int ntohl(int x);
		return {x[7:0], x[15:8], x[23:16], x[31:24]};
	endfunction: ntohl

	reg [7:0][31:0] digest_init;
	reg [7:0][31:0] digest_first_block;
	reg [7:0][31:0] digest_second_block;
/*
	reg [7:0][31:0] digest_test;
*/

	sha256_init init(
		.qdigest(digest_init));

	// version     = 32'h00000002
	// prev_block  = 00000000_00000001_17c80378_b8da0e33_559b5997_f2ad55e2_f7d18ec1_975b9717
	// merkle_root = 871714dc_bae6c819_3a2bb9b2_a69fe1c0_440399f3_8d94b3a0_f1b44727_5a29978a
	// timestamp   = 32'h53058b35
	// bits        = 32'h19015f53
	// nonce       = 32'h33087548

	sha256_block first_block(
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

	sha256_block second_block(
		.digest(digest_first_block),
		// Merkle root (last int)
		.W0 (htonl(32'h871714dc)),
		// Timestamp
		.W1 (htonl(32'h53058b35)),
		// Target bits
		.W2 (htonl(32'h19015f53)),
		// Nonce
		.W3 (htonl(32'h33087548)),
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
	// Should be 7c122b86_287a3ef7eac247e0ad637091ccfecbf85f6213030d9c1f89_5515d9e6

	sha256_block hash_twice(
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
/*
	sha256_block block_test(
		.digest(digest_init),
		.W0 (32'h12345678),
		.W1 (32'h80000000),
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
		.W15(32'h00000020),
		.qdigest(digest_test));
	// Should be e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
	sha256_block block_test_twice(
		.digest(digest_init),
		.W0 (digest_test[0]),
		.W1 (digest_test[1]),
		.W2 (digest_test[2]),
		.W3 (digest_test[3]),
		.W4 (digest_test[4]),
		.W5 (digest_test[5]),
		.W6 (digest_test[6]),
		.W7 (digest_test[7]),
		.W8 (32'h80000000),
		.W9 (32'h00000000),
		.W10(32'h00000000),
		.W11(32'h00000000),
		.W12(32'h00000000),
		.W13(32'h00000000),
		.W14(32'h00000000),
		.W15(32'h00000100),
		.qdigest(digest_test_twice));
	
	bitcoin_sha256 block_test2(
		.merkle_root(0),
		.timestamp(0),
		.target_bits(0),
		.nonce(0),
		.qhash(digest_test2));
*/
	always @ (posedge clock) begin
		$display("Calced %x\n", qdigest[3]);
	end
	
endmodule: fpga_miner
