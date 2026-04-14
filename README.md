[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)

# q3 a
riscv64-unknown-linux-gnu-objdump -s target_malinigoyal07 | grep "passed"
riscv64-unknown-linux-gnu-objdump -d target_malinigoyal07 | grep "<strcmp>"
riscv64-unknown-linux-gnu-objdump -d target_malinigoyal07 | grep -A 5 -B 10 "1064c:" > output.txt 
  
   1062e:	e022                	sd	s0,0(sp)
   10630:	840a                	mv	s0,sp
   10632:	7139                	addi	sp,sp,-64
   10634:	00074517          	auipc	a0,0x74
   10638:	94453503          	ld	a0,-1724(a0) # 83f78 <_GLOBAL_OFFSET_TABLE_+0x8>
   1063c:	858a                	mv	a1,sp
   1063e:	297040ef          	jal	150d4 <__scanf>
   10642:	850a                	mv	a0,sp
   10644:	00074597          	auipc	a1,0x74
   10648:	93c5b583          	ld	a1,-1732(a1) # 83f80 <_GLOBAL_OFFSET_TABLE_+0x10>
   1064c:	5f7170ef          	jal	28442 <strcmp>
   10650:	e901                	bnez	a0,10660 <.fail>

0000000000010652 <.pass>:
   10652:	00074517          	auipc	a0,0x74
   10656:	93653503          	ld	a0,-1738(a0) # 83f88 <_GLOBAL_OFFSET_TABLE_+0x18>


riscv64-unknown-linux-gnu-objdump -s --start-address=0x83f80 --stop-address=0x83f88 target_malinigoyal07
riscv64-unknown-linux-gnu-objdump -s --start-address=0x5e091 --stop-address=0x5e0b0 target_malinigoyal07
grep bDY+


# q3 b

riscv64-unknown-linux-gnu-objdump -d target_malinigoyal07 > output.txt
riscv64-unknown-linux-gnu-objdump -d target_malinigoyal07 | grep -E "gets|scanf"
looked for 104.. bcs :The instruction at 104d8 is calling _IO_gets -> buffer

00000000000104c8 <main>:
   104c8:	1141                	addi	sp,sp,-16
   104ca:	e406                	sd	ra,8(sp)
   104cc:	e022                	sd	s0,0(sp)
   104ce:	840a                	mv	s0,sp
   104d0:	7155                	addi	sp,sp,-208
   104d2:	850a                	mv	a0,sp
   104d4:	00004097          	auipc	ra,0x4
   104d8:	50e080e7          	jalr	1294(ra) # 149e2 <_IO_gets>
   104dc:	850a                	mv	a0,sp
   104de:	00042597          	auipc	a1,0x42
   104e2:	7d258593          	addi	a1,a1,2002 # 52cb0 <secret>
   104e6:	e911                	bnez	a0,104fa <.fail>

00000000000104e8 <.pass>:
   104e8:	00042517          	auipc	a0,0x42
   104ec:	7da50513          	addi	a0,a0,2010 # 52cc2 <passed>
   104f0:	00001097          	auipc	ra,0x1
   104f4:	93c080e7          	jalr	-1732(ra) # 10e2c <_IO_printf>
   104f8:	a809                	j	1050a <.end>

00000000000104fa <.fail>:
   104fa:	00042517          	auipc	a0,0x42
   104fe:	7da50513          	addi	a0,a0,2010 # 52cd4 <fail>
   10502:	00001097          	auipc	ra,0x1
   10506:	92a080e7          	jalr	-1750(ra) # 10e2c <_IO_printf>

000000000001050a <.end>:
   1050a:	6169                	addi	sp,sp,208
   1050c:	6402                	ld	s0,0(sp)
   1050e:	60a2                	ld	ra,8(sp)
   10510:	0141                	addi	sp,sp,16
   10512:	4501                	li	a0,0
   10514:	8082                	ret


riscv64-unknown-linux-gnu-objdump -s --start-address=0x52cb0 --stop-address=0x52cc2 target_malinigoyal07 // didn work

in above stack length of 208, so input a string of length greater than that- 216 + return address set to pass instruction
python3 -c 'import sys; sys.stdout.buffer.write(b"A"*216 + b"\xe8\x04\x01\x00\x00\x00\x00\x00")' > payload