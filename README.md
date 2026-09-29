# uart_dp

A small UART data processor in SystemVerilog, built mostly as an excuse to write a proper UVM testbench around it.

The DUT takes bytes in over UART, does something with them, and sends the result back out. The RTL is intentionally simple. The fun part is the verification: agents, scoreboards, a reference model, SVA, coverage, error injection, and breaking my own RTL on purpose to see if the testbench notices.

## How it works

Two stages, same UART core (RX with 16x oversampling, TX, FIFOs). Only the processing block in the middle changes, selected by the `STAGE` parameter.

**Stage 1 - byte transformer.** Every byte gets transformed and echoed back. Modes: bypass, invert, XOR with key, add/sub key, ASCII case swap, bit reverse, hex encode.

**Stage 2 - packets with CRC.** Bytes become packets:

```
7E | CMD | LEN | PAYLOAD... | CRC16_H | CRC16_L
```

The DUT checks the CRC (CRC-16/CCITT-FALSE), runs the command (ping, sum, xor, reverse, sort, min/max, transform, status), and replies with an ACK or a NACK plus an error code. Bad CRC, bad length, garbage on the line, truncated packets, UART errors mid-packet, timeouts: it should survive all of it and recover on the next good packet.

## Verification

- UVM UART agent (driver / monitor / sequencer), with configurable baud deviation, parity/stop-bit errors, breaks and glitches
- Layered sequences for stage 2: packets -> bytes -> bits
- Reference model + scoreboard
- SVA checkers hooked in with `bind`
- Functional coverage, plus code coverage on the RTL
- A list of intentional RTL bugs ("mutants") that the testbench has to catch


## Status

- [ ] UART TX/RX + loopback
- [ ] UVM agent
- [ ] Stage 1 + tests + coverage
- [ ] Stage 2 + packet layer
- [ ] Mutation testing

