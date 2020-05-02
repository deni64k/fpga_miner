create_clock -period 50.000 -name OSC_CLK OSC_CLK
derive_pll_clocks
# -create_base_clocks
derive_clock_uncertainty
