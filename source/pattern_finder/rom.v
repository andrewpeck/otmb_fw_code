module rom (
  input clock,
  input  [MXADRB-1:0] adr0, adr1,
  output [MXDATB-1:0] rd0, rd1
);

parameter FALLING_EDGE = 0;

parameter MXADRB  = 12;
parameter MXDATB  = 9;

parameter ROMLENGTH = 1 << MXADRB;

parameter ROM_FILE = "default.dat";

reg [MXDATB-1:0] rom [ROMLENGTH-1:0];

reg [MXDATB-1:0] rd_data0, rd_data1;

wire we = 0;
wire [MXDATB-1:0] din = 0;

wire logic_clock;
generate
if (FALLING_EDGE) assign logic_clock = ~clock;
else              assign logic_clock =  clock;
endgenerate

initial begin
  $readmemh(ROM_FILE, rom) ;
end

always @(posedge logic_clock) begin
  if (we)      rom[adr0[MXADRB-1:0]]<=din;  // dummy write to help Xilinx infer a dual port block RAM

  rd_data0 <= rom[adr0[MXADRB-1:0]];
  rd_data1 <= rom[adr1[MXADRB-1:0]];
end

assign rd0 = rd_data0[MXDATB-1:0];
assign rd1 = rd_data1[MXDATB-1:0];

endmodule