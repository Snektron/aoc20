pub const Opcode = enum {
    nop,
    acc,
    jmp,
};

pub const Instruction = struct {
    opcode: Opcode,
    arg: i32,
};

// (nop|acc|jmp) \+?(-?\d+)
//     .{.opcode = .\1, .arg = \2},

pub const input = [_]Instruction{
    .{.opcode = .jmp, .arg = 248},
    .{.opcode = .acc, .arg = 11},
    .{.opcode = .acc, .arg = 50},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .jmp, .arg = 531},
    .{.opcode = .acc, .arg = -17},
    .{.opcode = .jmp, .arg = 572},
    .{.opcode = .acc, .arg = 19},
    .{.opcode = .acc, .arg = 9},
    .{.opcode = .jmp, .arg = 221},
    .{.opcode = .nop, .arg = 373},
    .{.opcode = .acc, .arg = 7},
    .{.opcode = .jmp, .arg = 502},
    .{.opcode = .acc, .arg = 39},
    .{.opcode = .jmp, .arg = 12},
    .{.opcode = .acc, .arg = 7},
    .{.opcode = .nop, .arg = 482},
    .{.opcode = .jmp, .arg = 144},
    .{.opcode = .acc, .arg = -4},
    .{.opcode = .jmp, .arg = 85},
    .{.opcode = .acc, .arg = 12},
    .{.opcode = .nop, .arg = 446},
    .{.opcode = .nop, .arg = 162},
    .{.opcode = .jmp, .arg = 270},
    .{.opcode = .acc, .arg = -19},
    .{.opcode = .jmp, .arg = 402},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .acc, .arg = 28},
    .{.opcode = .acc, .arg = -13},
    .{.opcode = .acc, .arg = 30},
    .{.opcode = .jmp, .arg = 81},
    .{.opcode = .acc, .arg = -15},
    .{.opcode = .jmp, .arg = 20},
    .{.opcode = .acc, .arg = 28},
    .{.opcode = .jmp, .arg = -19},
    .{.opcode = .nop, .arg = 190},
    .{.opcode = .acc, .arg = 2},
    .{.opcode = .jmp, .arg = 61},
    .{.opcode = .nop, .arg = 237},
    .{.opcode = .jmp, .arg = 421},
    .{.opcode = .acc, .arg = 24},
    .{.opcode = .jmp, .arg = 221},
    .{.opcode = .acc, .arg = 1},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = 265},
    .{.opcode = .nop, .arg = 94},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = 370},
    .{.opcode = .acc, .arg = 19},
    .{.opcode = .nop, .arg = 39},
    .{.opcode = .jmp, .arg = 454},
    .{.opcode = .jmp, .arg = 162},
    .{.opcode = .jmp, .arg = 196},
    .{.opcode = .jmp, .arg = 7},
    .{.opcode = .acc, .arg = 37},
    .{.opcode = .acc, .arg = 14},
    .{.opcode = .jmp, .arg = 542},
    .{.opcode = .acc, .arg = -10},
    .{.opcode = .acc, .arg = 1},
    .{.opcode = .jmp, .arg = 324},
    .{.opcode = .nop, .arg = -45},
    .{.opcode = .acc, .arg = -5},
    .{.opcode = .jmp, .arg = 303},
    .{.opcode = .acc, .arg = 25},
    .{.opcode = .acc, .arg = 17},
    .{.opcode = .nop, .arg = 74},
    .{.opcode = .nop, .arg = 330},
    .{.opcode = .jmp, .arg = -7},
    .{.opcode = .acc, .arg = 45},
    .{.opcode = .jmp, .arg = 483},
    .{.opcode = .acc, .arg = -4},
    .{.opcode = .jmp, .arg = 230},
    .{.opcode = .jmp, .arg = 61},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .nop, .arg = 440},
    .{.opcode = .jmp, .arg = 104},
    .{.opcode = .acc, .arg = 33},
    .{.opcode = .jmp, .arg = 140},
    .{.opcode = .acc, .arg = -8},
    .{.opcode = .jmp, .arg = 19},
    .{.opcode = .acc, .arg = -10},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .acc, .arg = 30},
    .{.opcode = .jmp, .arg = 37},
    .{.opcode = .jmp, .arg = 457},
    .{.opcode = .jmp, .arg = 108},
    .{.opcode = .jmp, .arg = 182},
    .{.opcode = .acc, .arg = 23},
    .{.opcode = .acc, .arg = 38},
    .{.opcode = .acc, .arg = -1},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .jmp, .arg = 330},
    .{.opcode = .acc, .arg = 2},
    .{.opcode = .acc, .arg = -2},
    .{.opcode = .nop, .arg = 483},
    .{.opcode = .acc, .arg = 31},
    .{.opcode = .jmp, .arg = 426},
    .{.opcode = .acc, .arg = 25},
    .{.opcode = .acc, .arg = 1},
    .{.opcode = .jmp, .arg = 296},
    .{.opcode = .acc, .arg = 10},
    .{.opcode = .acc, .arg = 32},
    .{.opcode = .jmp, .arg = 223},
    .{.opcode = .acc, .arg = 3},
    .{.opcode = .nop, .arg = 350},
    .{.opcode = .acc, .arg = 29},
    .{.opcode = .acc, .arg = 4},
    .{.opcode = .jmp, .arg = 427},
    .{.opcode = .acc, .arg = 42},
    .{.opcode = .jmp, .arg = 312},
    .{.opcode = .acc, .arg = 7},
    .{.opcode = .acc, .arg = -6},
    .{.opcode = .nop, .arg = 366},
    .{.opcode = .nop, .arg = 409},
    .{.opcode = .jmp, .arg = 364},
    .{.opcode = .jmp, .arg = -78},
    .{.opcode = .acc, .arg = 42},
    .{.opcode = .jmp, .arg = 159},
    .{.opcode = .acc, .arg = 33},
    .{.opcode = .jmp, .arg = 128},
    .{.opcode = .nop, .arg = 86},
    .{.opcode = .acc, .arg = 5},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .acc, .arg = 47},
    .{.opcode = .jmp, .arg = 150},
    .{.opcode = .acc, .arg = -8},
    .{.opcode = .jmp, .arg = -101},
    .{.opcode = .acc, .arg = 31},
    .{.opcode = .nop, .arg = 55},
    .{.opcode = .acc, .arg = 2},
    .{.opcode = .jmp, .arg = 39},
    .{.opcode = .jmp, .arg = 12},
    .{.opcode = .acc, .arg = 5},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = -115},
    .{.opcode = .nop, .arg = 141},
    .{.opcode = .nop, .arg = 418},
    .{.opcode = .jmp, .arg = 75},
    .{.opcode = .nop, .arg = 430},
    .{.opcode = .acc, .arg = -19},
    .{.opcode = .acc, .arg = -12},
    .{.opcode = .jmp, .arg = 83},
    .{.opcode = .jmp, .arg = 82},
    .{.opcode = .acc, .arg = 27},
    .{.opcode = .jmp, .arg = -65},
    .{.opcode = .acc, .arg = -5},
    .{.opcode = .jmp, .arg = 422},
    .{.opcode = .acc, .arg = 16},
    .{.opcode = .acc, .arg = 20},
    .{.opcode = .jmp, .arg = 336},
    .{.opcode = .acc, .arg = 29},
    .{.opcode = .jmp, .arg = -110},
    .{.opcode = .acc, .arg = 1},
    .{.opcode = .acc, .arg = 13},
    .{.opcode = .acc, .arg = 37},
    .{.opcode = .jmp, .arg = 38},
    .{.opcode = .acc, .arg = 45},
    .{.opcode = .acc, .arg = 2},
    .{.opcode = .acc, .arg = 45},
    .{.opcode = .jmp, .arg = -12},
    .{.opcode = .acc, .arg = 36},
    .{.opcode = .acc, .arg = 26},
    .{.opcode = .acc, .arg = 50},
    .{.opcode = .jmp, .arg = 343},
    .{.opcode = .acc, .arg = -17},
    .{.opcode = .acc, .arg = -18},
    .{.opcode = .acc, .arg = 34},
    .{.opcode = .acc, .arg = 23},
    .{.opcode = .jmp, .arg = 274},
    .{.opcode = .acc, .arg = 20},
    .{.opcode = .acc, .arg = 12},
    .{.opcode = .nop, .arg = 129},
    .{.opcode = .acc, .arg = -1},
    .{.opcode = .jmp, .arg = 5},
    .{.opcode = .acc, .arg = 39},
    .{.opcode = .acc, .arg = 40},
    .{.opcode = .acc, .arg = 28},
    .{.opcode = .jmp, .arg = 272},
    .{.opcode = .jmp, .arg = 147},
    .{.opcode = .acc, .arg = 50},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .acc, .arg = 17},
    .{.opcode = .jmp, .arg = -131},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .acc, .arg = -17},
    .{.opcode = .acc, .arg = -16},
    .{.opcode = .acc, .arg = 7},
    .{.opcode = .jmp, .arg = 25},
    .{.opcode = .acc, .arg = 47},
    .{.opcode = .acc, .arg = 14},
    .{.opcode = .acc, .arg = 27},
    .{.opcode = .acc, .arg = -2},
    .{.opcode = .jmp, .arg = 224},
    .{.opcode = .acc, .arg = -6},
    .{.opcode = .acc, .arg = -10},
    .{.opcode = .acc, .arg = 23},
    .{.opcode = .jmp, .arg = -109},
    .{.opcode = .acc, .arg = -1},
    .{.opcode = .jmp, .arg = -145},
    .{.opcode = .acc, .arg = 40},
    .{.opcode = .nop, .arg = 275},
    .{.opcode = .jmp, .arg = 420},
    .{.opcode = .nop, .arg = -92},
    .{.opcode = .nop, .arg = -43},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = -134},
    .{.opcode = .nop, .arg = 297},
    .{.opcode = .acc, .arg = 14},
    .{.opcode = .jmp, .arg = 60},
    .{.opcode = .nop, .arg = 412},
    .{.opcode = .nop, .arg = 14},
    .{.opcode = .jmp, .arg = -79},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .acc, .arg = 25},
    .{.opcode = .jmp, .arg = 176},
    .{.opcode = .jmp, .arg = -206},
    .{.opcode = .acc, .arg = 50},
    .{.opcode = .acc, .arg = 17},
    .{.opcode = .jmp, .arg = 271},
    .{.opcode = .acc, .arg = 9},
    .{.opcode = .nop, .arg = -82},
    .{.opcode = .acc, .arg = 6},
    .{.opcode = .acc, .arg = 19},
    .{.opcode = .jmp, .arg = 184},
    .{.opcode = .acc, .arg = 34},
    .{.opcode = .acc, .arg = 32},
    .{.opcode = .acc, .arg = -6},
    .{.opcode = .jmp, .arg = -21},
    .{.opcode = .jmp, .arg = -4},
    .{.opcode = .nop, .arg = -154},
    .{.opcode = .acc, .arg = 38},
    .{.opcode = .jmp, .arg = 10},
    .{.opcode = .acc, .arg = 25},
    .{.opcode = .acc, .arg = 46},
    .{.opcode = .acc, .arg = 32},
    .{.opcode = .jmp, .arg = 65},
    .{.opcode = .acc, .arg = -3},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .jmp, .arg = -153},
    .{.opcode = .acc, .arg = 31},
    .{.opcode = .jmp, .arg = 21},
    .{.opcode = .acc, .arg = 31},
    .{.opcode = .acc, .arg = 40},
    .{.opcode = .jmp, .arg = 137},
    .{.opcode = .nop, .arg = 307},
    .{.opcode = .acc, .arg = -10},
    .{.opcode = .jmp, .arg = -193},
    .{.opcode = .acc, .arg = 5},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .acc, .arg = 42},
    .{.opcode = .acc, .arg = -7},
    .{.opcode = .jmp, .arg = -104},
    .{.opcode = .jmp, .arg = 233},
    .{.opcode = .acc, .arg = 41},
    .{.opcode = .acc, .arg = 42},
    .{.opcode = .acc, .arg = 43},
    .{.opcode = .jmp, .arg = 358},
    .{.opcode = .acc, .arg = 13},
    .{.opcode = .nop, .arg = 140},
    .{.opcode = .acc, .arg = 20},
    .{.opcode = .jmp, .arg = 337},
    .{.opcode = .acc, .arg = 18},
    .{.opcode = .acc, .arg = -7},
    .{.opcode = .acc, .arg = -14},
    .{.opcode = .jmp, .arg = -213},
    .{.opcode = .nop, .arg = 142},
    .{.opcode = .acc, .arg = 13},
    .{.opcode = .jmp, .arg = 115},
    .{.opcode = .acc, .arg = 48},
    .{.opcode = .acc, .arg = 30},
    .{.opcode = .acc, .arg = 15},
    .{.opcode = .jmp, .arg = 283},
    .{.opcode = .acc, .arg = -14},
    .{.opcode = .jmp, .arg = -153},
    .{.opcode = .jmp, .arg = -75},
    .{.opcode = .jmp, .arg = -178},
    .{.opcode = .acc, .arg = 36},
    .{.opcode = .acc, .arg = 9},
    .{.opcode = .jmp, .arg = 32},
    .{.opcode = .acc, .arg = 28},
    .{.opcode = .jmp, .arg = -229},
    .{.opcode = .jmp, .arg = 93},
    .{.opcode = .acc, .arg = 41},
    .{.opcode = .jmp, .arg = 91},
    .{.opcode = .acc, .arg = -17},
    .{.opcode = .acc, .arg = 3},
    .{.opcode = .jmp, .arg = 163},
    .{.opcode = .nop, .arg = 129},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .nop, .arg = -169},
    .{.opcode = .acc, .arg = -11},
    .{.opcode = .jmp, .arg = -23},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .acc, .arg = -8},
    .{.opcode = .jmp, .arg = 106},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .acc, .arg = 43},
    .{.opcode = .acc, .arg = -3},
    .{.opcode = .acc, .arg = 25},
    .{.opcode = .jmp, .arg = -15},
    .{.opcode = .nop, .arg = -296},
    .{.opcode = .acc, .arg = -4},
    .{.opcode = .jmp, .arg = 220},
    .{.opcode = .nop, .arg = -244},
    .{.opcode = .acc, .arg = 38},
    .{.opcode = .acc, .arg = -3},
    .{.opcode = .nop, .arg = -163},
    .{.opcode = .jmp, .arg = -169},
    .{.opcode = .jmp, .arg = -304},
    .{.opcode = .jmp, .arg = 169},
    .{.opcode = .acc, .arg = 22},
    .{.opcode = .acc, .arg = -5},
    .{.opcode = .acc, .arg = 21},
    .{.opcode = .acc, .arg = 7},
    .{.opcode = .jmp, .arg = -162},
    .{.opcode = .acc, .arg = 17},
    .{.opcode = .jmp, .arg = -229},
    .{.opcode = .nop, .arg = 35},
    .{.opcode = .acc, .arg = 42},
    .{.opcode = .acc, .arg = 12},
    .{.opcode = .acc, .arg = 12},
    .{.opcode = .jmp, .arg = 95},
    .{.opcode = .acc, .arg = -7},
    .{.opcode = .nop, .arg = 136},
    .{.opcode = .jmp, .arg = 130},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .acc, .arg = 16},
    .{.opcode = .acc, .arg = 50},
    .{.opcode = .jmp, .arg = -297},
    .{.opcode = .nop, .arg = 183},
    .{.opcode = .nop, .arg = 104},
    .{.opcode = .acc, .arg = 18},
    .{.opcode = .jmp, .arg = -65},
    .{.opcode = .acc, .arg = -4},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = 227},
    .{.opcode = .nop, .arg = -76},
    .{.opcode = .jmp, .arg = -109},
    .{.opcode = .acc, .arg = 27},
    .{.opcode = .acc, .arg = -2},
    .{.opcode = .acc, .arg = -9},
    .{.opcode = .jmp, .arg = 16},
    .{.opcode = .nop, .arg = 99},
    .{.opcode = .acc, .arg = 46},
    .{.opcode = .acc, .arg = -7},
    .{.opcode = .nop, .arg = 2},
    .{.opcode = .jmp, .arg = 258},
    .{.opcode = .acc, .arg = -10},
    .{.opcode = .jmp, .arg = 122},
    .{.opcode = .acc, .arg = -19},
    .{.opcode = .jmp, .arg = 23},
    .{.opcode = .nop, .arg = -205},
    .{.opcode = .acc, .arg = -16},
    .{.opcode = .jmp, .arg = 81},
    .{.opcode = .nop, .arg = 235},
    .{.opcode = .acc, .arg = -16},
    .{.opcode = .jmp, .arg = 69},
    .{.opcode = .acc, .arg = -11},
    .{.opcode = .acc, .arg = 4},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = -80},
    .{.opcode = .acc, .arg = -19},
    .{.opcode = .jmp, .arg = 108},
    .{.opcode = .acc, .arg = 31},
    .{.opcode = .acc, .arg = -7},
    .{.opcode = .nop, .arg = -137},
    .{.opcode = .acc, .arg = 26},
    .{.opcode = .jmp, .arg = -185},
    .{.opcode = .acc, .arg = -3},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .acc, .arg = -2},
    .{.opcode = .acc, .arg = 43},
    .{.opcode = .jmp, .arg = -137},
    .{.opcode = .acc, .arg = 14},
    .{.opcode = .nop, .arg = 96},
    .{.opcode = .jmp, .arg = -28},
    .{.opcode = .acc, .arg = 5},
    .{.opcode = .acc, .arg = 19},
    .{.opcode = .jmp, .arg = -31},
    .{.opcode = .jmp, .arg = 18},
    .{.opcode = .jmp, .arg = -356},
    .{.opcode = .acc, .arg = 34},
    .{.opcode = .acc, .arg = 45},
    .{.opcode = .jmp, .arg = 170},
    .{.opcode = .acc, .arg = 39},
    .{.opcode = .acc, .arg = 3},
    .{.opcode = .acc, .arg = 22},
    .{.opcode = .acc, .arg = 23},
    .{.opcode = .jmp, .arg = -370},
    .{.opcode = .jmp, .arg = -73},
    .{.opcode = .acc, .arg = 23},
    .{.opcode = .acc, .arg = 46},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .jmp, .arg = -297},
    .{.opcode = .acc, .arg = 46},
    .{.opcode = .jmp, .arg = -387},
    .{.opcode = .jmp, .arg = -312},
    .{.opcode = .jmp, .arg = -345},
    .{.opcode = .jmp, .arg = 229},
    .{.opcode = .acc, .arg = -6},
    .{.opcode = .jmp, .arg = 74},
    .{.opcode = .nop, .arg = -209},
    .{.opcode = .acc, .arg = 43},
    .{.opcode = .nop, .arg = -151},
    .{.opcode = .acc, .arg = 41},
    .{.opcode = .jmp, .arg = -182},
    .{.opcode = .acc, .arg = -12},
    .{.opcode = .acc, .arg = -5},
    .{.opcode = .acc, .arg = -13},
    .{.opcode = .acc, .arg = 3},
    .{.opcode = .jmp, .arg = -386},
    .{.opcode = .acc, .arg = 45},
    .{.opcode = .acc, .arg = 9},
    .{.opcode = .nop, .arg = -97},
    .{.opcode = .jmp, .arg = -411},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .jmp, .arg = 151},
    .{.opcode = .nop, .arg = 150},
    .{.opcode = .acc, .arg = 17},
    .{.opcode = .jmp, .arg = -144},
    .{.opcode = .acc, .arg = 3},
    .{.opcode = .acc, .arg = 12},
    .{.opcode = .nop, .arg = 55},
    .{.opcode = .jmp, .arg = -377},
    .{.opcode = .jmp, .arg = -421},
    .{.opcode = .nop, .arg = 52},
    .{.opcode = .acc, .arg = -18},
    .{.opcode = .acc, .arg = -9},
    .{.opcode = .jmp, .arg = -77},
    .{.opcode = .acc, .arg = -14},
    .{.opcode = .acc, .arg = 33},
    .{.opcode = .nop, .arg = -316},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .jmp, .arg = -193},
    .{.opcode = .nop, .arg = 150},
    .{.opcode = .acc, .arg = -16},
    .{.opcode = .jmp, .arg = -294},
    .{.opcode = .acc, .arg = 26},
    .{.opcode = .acc, .arg = -14},
    .{.opcode = .acc, .arg = -7},
    .{.opcode = .jmp, .arg = -61},
    .{.opcode = .nop, .arg = -84},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .jmp, .arg = -105},
    .{.opcode = .acc, .arg = 48},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .acc, .arg = -6},
    .{.opcode = .jmp, .arg = -109},
    .{.opcode = .acc, .arg = -12},
    .{.opcode = .acc, .arg = 37},
    .{.opcode = .acc, .arg = 24},
    .{.opcode = .jmp, .arg = 73},
    .{.opcode = .jmp, .arg = -275},
    .{.opcode = .acc, .arg = 14},
    .{.opcode = .acc, .arg = -19},
    .{.opcode = .jmp, .arg = -156},
    .{.opcode = .nop, .arg = -147},
    .{.opcode = .jmp, .arg = -94},
    .{.opcode = .acc, .arg = -4},
    .{.opcode = .acc, .arg = 50},
    .{.opcode = .acc, .arg = 26},
    .{.opcode = .acc, .arg = -1},
    .{.opcode = .jmp, .arg = -392},
    .{.opcode = .nop, .arg = 58},
    .{.opcode = .jmp, .arg = -440},
    .{.opcode = .acc, .arg = -1},
    .{.opcode = .jmp, .arg = -85},
    .{.opcode = .acc, .arg = 39},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .jmp, .arg = -318},
    .{.opcode = .nop, .arg = -123},
    .{.opcode = .jmp, .arg = 133},
    .{.opcode = .acc, .arg = -18},
    .{.opcode = .jmp, .arg = 131},
    .{.opcode = .acc, .arg = 50},
    .{.opcode = .jmp, .arg = -401},
    .{.opcode = .jmp, .arg = -458},
    .{.opcode = .acc, .arg = -9},
    .{.opcode = .acc, .arg = 23},
    .{.opcode = .jmp, .arg = 26},
    .{.opcode = .acc, .arg = 15},
    .{.opcode = .acc, .arg = -5},
    .{.opcode = .nop, .arg = -236},
    .{.opcode = .jmp, .arg = -89},
    .{.opcode = .acc, .arg = -3},
    .{.opcode = .acc, .arg = 28},
    .{.opcode = .jmp, .arg = 98},
    .{.opcode = .jmp, .arg = -413},
    .{.opcode = .acc, .arg = -19},
    .{.opcode = .acc, .arg = 41},
    .{.opcode = .acc, .arg = 21},
    .{.opcode = .jmp, .arg = -365},
    .{.opcode = .nop, .arg = 97},
    .{.opcode = .acc, .arg = 18},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .jmp, .arg = -186},
    .{.opcode = .acc, .arg = -3},
    .{.opcode = .acc, .arg = 31},
    .{.opcode = .nop, .arg = -356},
    .{.opcode = .acc, .arg = 26},
    .{.opcode = .jmp, .arg = -217},
    .{.opcode = .jmp, .arg = -13},
    .{.opcode = .acc, .arg = 42},
    .{.opcode = .jmp, .arg = -437},
    .{.opcode = .jmp, .arg = -322},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = -81},
    .{.opcode = .acc, .arg = 28},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .acc, .arg = 45},
    .{.opcode = .acc, .arg = 36},
    .{.opcode = .jmp, .arg = -441},
    .{.opcode = .acc, .arg = 50},
    .{.opcode = .acc, .arg = 23},
    .{.opcode = .acc, .arg = 1},
    .{.opcode = .acc, .arg = 45},
    .{.opcode = .jmp, .arg = -11},
    .{.opcode = .acc, .arg = 16},
    .{.opcode = .acc, .arg = -13},
    .{.opcode = .acc, .arg = 16},
    .{.opcode = .jmp, .arg = 13},
    .{.opcode = .jmp, .arg = -419},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = 66},
    .{.opcode = .acc, .arg = 40},
    .{.opcode = .acc, .arg = -5},
    .{.opcode = .acc, .arg = -8},
    .{.opcode = .acc, .arg = 39},
    .{.opcode = .jmp, .arg = 61},
    .{.opcode = .acc, .arg = 8},
    .{.opcode = .acc, .arg = 25},
    .{.opcode = .acc, .arg = 41},
    .{.opcode = .jmp, .arg = -395},
    .{.opcode = .acc, .arg = 5},
    .{.opcode = .acc, .arg = 28},
    .{.opcode = .jmp, .arg = -70},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .acc, .arg = 15},
    .{.opcode = .acc, .arg = -11},
    .{.opcode = .jmp, .arg = -437},
    .{.opcode = .acc, .arg = 17},
    .{.opcode = .acc, .arg = 30},
    .{.opcode = .acc, .arg = -15},
    .{.opcode = .acc, .arg = 22},
    .{.opcode = .jmp, .arg = -91},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .acc, .arg = 47},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .acc, .arg = 39},
    .{.opcode = .jmp, .arg = -258},
    .{.opcode = .jmp, .arg = -514},
    .{.opcode = .acc, .arg = 46},
    .{.opcode = .jmp, .arg = -478},
    .{.opcode = .acc, .arg = 38},
    .{.opcode = .acc, .arg = 12},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .jmp, .arg = -167},
    .{.opcode = .acc, .arg = 41},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .acc, .arg = 30},
    .{.opcode = .nop, .arg = -337},
    .{.opcode = .jmp, .arg = -521},
    .{.opcode = .acc, .arg = -11},
    .{.opcode = .nop, .arg = -426},
    .{.opcode = .jmp, .arg = -68},
    .{.opcode = .acc, .arg = -11},
    .{.opcode = .jmp, .arg = -331},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .acc, .arg = 6},
    .{.opcode = .acc, .arg = 13},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = -519},
    .{.opcode = .acc, .arg = 48},
    .{.opcode = .acc, .arg = 13},
    .{.opcode = .acc, .arg = 34},
    .{.opcode = .jmp, .arg = -51},
    .{.opcode = .acc, .arg = 19},
    .{.opcode = .acc, .arg = 46},
    .{.opcode = .acc, .arg = 26},
    .{.opcode = .acc, .arg = 35},
    .{.opcode = .jmp, .arg = -345},
    .{.opcode = .acc, .arg = 20},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .jmp, .arg = -220},
    .{.opcode = .acc, .arg = 18},
    .{.opcode = .acc, .arg = 43},
    .{.opcode = .nop, .arg = -65},
    .{.opcode = .jmp, .arg = -335},
    .{.opcode = .jmp, .arg = -305},
    .{.opcode = .acc, .arg = 19},
    .{.opcode = .acc, .arg = -1},
    .{.opcode = .jmp, .arg = -551},
    .{.opcode = .acc, .arg = 40},
    .{.opcode = .acc, .arg = 11},
    .{.opcode = .acc, .arg = -13},
    .{.opcode = .jmp, .arg = -196},
    .{.opcode = .acc, .arg = 18},
    .{.opcode = .nop, .arg = -460},
    .{.opcode = .acc, .arg = 28},
    .{.opcode = .jmp, .arg = -266},
    .{.opcode = .acc, .arg = 41},
    .{.opcode = .nop, .arg = -450},
    .{.opcode = .acc, .arg = 20},
    .{.opcode = .jmp, .arg = -380},
    .{.opcode = .acc, .arg = 24},
    .{.opcode = .acc, .arg = 44},
    .{.opcode = .acc, .arg = 2},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .jmp, .arg = 22},
    .{.opcode = .acc, .arg = -10},
    .{.opcode = .acc, .arg = 0},
    .{.opcode = .acc, .arg = -8},
    .{.opcode = .jmp, .arg = -255},
    .{.opcode = .nop, .arg = -80},
    .{.opcode = .acc, .arg = 24},
    .{.opcode = .jmp, .arg = -513},
    .{.opcode = .acc, .arg = 23},
    .{.opcode = .nop, .arg = -238},
    .{.opcode = .acc, .arg = 31},
    .{.opcode = .jmp, .arg = -504},
    .{.opcode = .nop, .arg = -461},
    .{.opcode = .acc, .arg = 40},
    .{.opcode = .acc, .arg = 39},
    .{.opcode = .jmp, .arg = 4},
    .{.opcode = .acc, .arg = 2},
    .{.opcode = .acc, .arg = 18},
    .{.opcode = .jmp, .arg = -359},
    .{.opcode = .jmp, .arg = -143},
    .{.opcode = .acc, .arg = -5},
    .{.opcode = .jmp, .arg = -117},
    .{.opcode = .acc, .arg = -12},
    .{.opcode = .acc, .arg = 40},
    .{.opcode = .jmp, .arg = 1},
    .{.opcode = .acc, .arg = 15},
    .{.opcode = .jmp, .arg = 1},
};
