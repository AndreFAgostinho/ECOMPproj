//
// picoVersat system definitions
//

// DATA WIDTH
`define DATA_W 32 // bits

// ADDRESS WIDTH
`define ADDR_W 10

// DEBUG: USE PRINTER AND GENERATE VCD FILE
//`define DEBUG

//
// VERSAT MEMORY MAP (2^ADDR_W addresses) //1024
//

//addresses 0-15 are reserved by the controler
`define REGF_BASE `ADDR_W'h010 //16-31
`define CPRT_BASE `ADDR_W'h020 //32
`define PUSH_BASE	`ADDR_W'h021 //33
`define PS2_BASE	`ADDR_W'h022 //34
`define DISP_BASE	`ADDR_W'h023 //35
`define GPO_BASE	`ADDR_W'h024 //36
`define OPER_BASE	`ADDR_W'h025 //37
`define OP_BASE		`ADDR_W'h026 //38
`define PROG_BASE `ADDR_W'h200 //512-1024
