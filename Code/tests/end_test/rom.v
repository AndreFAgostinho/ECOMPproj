`PROG_ROM_ADDR_W'h0: data <= `INSTR_W'h60000000;
`PROG_ROM_ADDR_W'h1: data <= `INSTR_W'hc00000fe;
`PROG_ROM_ADDR_W'h2: data <= `INSTR_W'h00000000;
`PROG_ROM_ADDR_W'h3: data <= `INSTR_W'h00000000;
default: data <= `INSTR_W'h00000000;