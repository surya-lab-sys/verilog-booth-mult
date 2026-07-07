# Verilog Booth Multiplier

A 4-bit signed Radix-2 Booth Multiplier implemented in Verilog, along with a testbench to verify it in simulation.

## What is Booth's Algorithm?

Booth's algorithm is a technique for multiplying two signed binary numbers. Instead of adding the multiplicand once for every `1` bit in the multiplier (as in simple binary multiplication), it looks at pairs of adjacent bits to detect the *start* and *end* of a run of consecutive `1`s, replacing multiple additions with a single subtraction and a single addition. This makes it efficient for signed (two's complement) multiplication in hardware.

## Files

| File | Description |
|---|---|
| `booth_mult.v` | The Booth multiplier module |
| `tb_booth.v` | Testbench that drives the module with sample inputs and checks the output |

## Module Interface

```verilog
module booth_mult(prod, q, m, clk, start);
    output reg signed [7:0] prod;  // 8-bit signed product
    input  signed [3:0] q, m;      // 4-bit signed multiplier and multiplicand
    input  clk, start;             // clock and start signal
```

| Signal | Direction | Width | Description |
|---|---|---|---|
| `q` | input | 4 bits, signed | Multiplier |
| `m` | input | 4 bits, signed | Multiplicand |
| `clk` | input | 1 bit | Clock signal |
| `start` | input | 1 bit | Loads `q`/`m` and begins a new multiplication while held high |
| `prod` | output | 8 bits, signed | Final signed product |

## How It Works

1. While `start` is held high, the module continuously loads the accumulator (`A`), the multiplier register (`q_reg`), and the counter to their initial values.
2. Once `start` is released (set low), the module performs one Booth iteration per clock cycle:
   - Looks at the current bit of `q_reg` and the previously shifted-out bit (`q_1`) to decide whether to add, subtract, or do nothing to the accumulator.
   - Performs a sign-preserving (arithmetic) right shift across `{A, q_reg, q_1}`.
3. After 4 iterations (since this is a 4-bit design), the final result is latched into `prod` as `{A, q_reg}`.

## Simulating

Using [Icarus Verilog](http://iverilog.icarus.com/):

```bash
iverilog -o sim booth_mult.v tb_booth.v
vvp sim
```

## Example

Multiplying `q = 3` and `m = -2` should produce `prod = -6`.

## Notes

- This is a fixed 4-bit implementation. `prod` is 8 bits wide since multiplying two N-bit numbers can require up to 2N bits to represent the result.
- There is no `reset` or `done` signal in this version â€” `start` alone handles initialization, and `prod` should be read only after enough clock cycles have passed for the multiplication to complete (4 cycles after `start` is released).
