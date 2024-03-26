```
usage: test.py [-h] cpu testcase [expected]

Adv Arch OoO Testbench

positional arguments:
  cpu         Path to your CPU implementation
  testcase    Path to the testcase elf
  expected    Path to the expected output of the testcase

optional arguments:
  -h, --help  show this help message and exit
```

See self_test.sv for example "CPU" implementation with compatible interface. Write characters with stores to addr -1, set `done=1` when finished. Elf program .text section is loaded in starting at address 0.


Run `python3 test.py self_test.sv test.elf self_test.expected` to execute self test.

Note: requires iverilog and llvm-objcopy in path.