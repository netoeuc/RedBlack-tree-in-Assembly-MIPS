# Author = Euclides Carlos Pinto Neto
# Esse código NÃO TRATA a entrada e a saída: A leitura e a escrita dos valores é feita na ordem inversa, normal para o MIPS (primero se escreve o fim e vai caminhando até o começo, por byte)
# Versão 1


.data
buffer: .space 4
tree: .word 0x10040000

filein:   .asciiz "tree.in"       # filename for input
fileout:  .asciiz "tree.out"      # filename for output

# >>>>> Buffer aqui! <<<<<
numero: .word 10






.text

printInPostOrder: # $t2 points to the current Node. $t4 contains the heap address and $t3 cointains the current space in the heap
	lw $t0, 12($t2)
	beq $t0, -1, goToTheRightPostOrder
	move $t1, $t0
	
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t2, $t1
	jal printInPostOrder #left ($t2)
	
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	goToTheRightPostOrder:
	lw $t0, 16($t2)
	beq $t0, -1, goToTheRootPostOrder
	move $t1, $t0
	
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t2, $t1
	jal printInPostOrder #right ($t2)
	
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	addi $sp, $sp, 4
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	goToTheRootPostOrder:
	#la $t3, 0x10040000
	lw $t5, 0($t2)
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	jr $ra







.macro readFile()


       
  ###############################################################
  # Open (for reading) a file that does not exist
  li   $v0, 13       # system call for open file
  la   $a0, filein     # input file name
  li   $a1, 0        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor 
  ###############################################################
  # Read file just opened
  li   $v0, 14       # system call for write to file
  move $a0, $s6      # file descriptor 
  la   $a1, buffer   # address of buffer from which to put the content
  li   $a2, 4       # hardcoded buffer length
  syscall            # write to file
  la $s4, buffer
  lw $s4, 0($s4)
   # Read file just opened
  li   $v0, 14       # system call for write to file
  move $a0, $s6      # file descriptor 
  la   $a1, buffer   # address of buffer from which to put the content
  li   $a2, 4       # hardcoded buffer length
  syscall            # write to file
  la $a3, buffer
  lw $a3, 0($a3)
  ###############################################################
  # Close the file 
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file
  ###############################################################
  move $s2, $a1
.end_macro


.macro writeInFile(%reg) # %reg contains the string of the result ($s1)
  ###############################################################
  #move $s1, %reg # result is in $s1
  # Open (for reading) a file that does not exist
  li   $v0, 13       # system call for open file
  la   $a0, fileout     # output file name
  li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor 
  ###############################################################
  # Write to file just opened
  #li   $v0, 15       # system call for write to file
  #move $a0, $s6      # file descriptor 
  #move   $a1, $s1   # address of buffer from which to write
  #li   $a2, 10       # hardcoded buffer length
  #syscall            # write to file

  writeDecision:
  	lw $t1, 0($s1)
  	beq $t1, -2, dontWrite # "End of the sequence"
  	# teste
  	#la $t2, numero
  	#sw $t1, 0($t2)
  	
  	#li $t5, 0x000000ff
  	#li $t6, 0x0000ff00
  	#li $t7, 0x00ff0000
  	#li $t8, 0xff000000
	#and $t5, $t5, $t1
	#and $t6, $t6, $t1
	#and $t7, $t7, $t1
	#and $t8, $t8, $t1
	#sll $t5, $t5, 24
	#sll $t6, $t6, 8
	#srl $t7, $t7, 8
	#srl $t8, $t8, 24
	
	#li $t1, 0
	#add $t1, $t1, $t5
	#add $t1, $t1, $t6
	#add $t1, $t1, $t7
	#add $t1, $t1, $t8	
	
	la $t2, numero
  	sw $t1, 0($t2)
	
  write:
  	li   $v0, 15       # system call for write to file
  	move $a0, $s6      # file descriptor 
  	#la   $a1, 0($s1)   # address of buffer from which to put the content
  	la   $a1, numero   # address of buffer from which to put the content 
  	li   $a2, 4      # hardcoded buffer length
  	syscall            # write to file
  	
 	addi $s1, $s1, 4
 	

  	j writeDecision
  dontWrite:
  
  
  
  
  
  
  ###############################################################
  # Close the file 
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file
  move $a0, $v0
  	li $v0, 1
  	syscall
  ###############################################################
.end_macro





.macro changeNodeColorToBlack(%reg) # the parameter is a pointer that points to the node (complete node). It uses $t1 and the parameter
	li $v1, 0 # 0 means black
	beq %reg, -1, endChangeNodeColorToBlack
	sw $v1, 4(%reg) # change the node color to black
	endChangeNodeColorToBlack:
.end_macro

.macro changeNodeColorToRed(%reg) # the parameter is a pointer that points to the node (complete node). It uses $t1 and the parameter
	li $v1, 1 # 1 means red
	beq %reg, -1, endChangeNodeColorToRed
	sw $v1, 4(%reg) # change the node color to red
	endChangeNodeColorToRed:
.end_macro


.macro updateRoot()
	#li $t8, 268500992
	# Original, bakcup: la $t8, tree
	li $t8, 0x10040000 # correto!
	
	updateRootLoop:
		lw $t9, 8($t8) # $t9 recebe o pai de $t8
		beq $t9, -1, endUpdateLoop # $t9 é igual a null? I.e., $t8==root?
		addi $t8, $t8, 20
		j updateRootLoop
	endUpdateLoop:
		move $s7, $t8
		li $t9, 0
		li $t8, 0

.end_macro


.macro insertRBTree() # parameter is a POINTER to the node address, it is not the node value
	# $a0 = VALUE of node to be added
	# $a1 = address of current node (x)
	# $t1 = p[p[x]]
	# $t2 = left(p[p[x]]) or (y = right(p[p[x]]) )
	# $t3 = p[x]
	# $t4 = color[p[x]]
	# $t5 = color(y)
	# $t6 = right[p[x]]
	# $t7 = 
	# $s3 = address of registers backup
	# $s7 = root
	# $a0 = contains the value to be put
	
	# ERRO NA HEAP!!!!# li $s3, 268697600 # set the backup address in $s3
	li $s3, 0x10010020 # .data, espaco vazio para colocar backup registradores
	
	move $a1, $s1 # $a1 (and $s1, contains the address of the address the node will be created)
	jal insertInTree # insertTree(T, value(x))
	
	# Original, backup: beq $a1, $s1, endInsertRBTree # while test: if x==root, branch to endInsertRBTree
	beq $a1, $s7, endInsertRBTree # while test: if x==root, branch to endInsertRBTree ($s7 contains the address of the root)
	
	
	lw $t3, 8($a1)
	lw $t4, 4($t3)
	bne $t4, 1, endInsertRBTree # while test: if color(p[x])!=red, branch to endInsertRBTree
	
	
	
	whileInsertTree: #while x!=root and color(p[x])==red
		
		lw $t1, 8($t3) # $t1 = p[p[x]]
		
		
		
		# Original, backup: lw $t2, 12($t3) # $t2 = left(p[p[x]])
		lw $t2, 12($t1) # $t2 = left(p[p[x]])
		
		
		bne $t3, $t2, elseInsertRBTree1 # if p[x]==left(p[p[x]]), continue; Else,  branch to elseInsertRBTree1
		
		ifInsertRBTree1:
			# Original, backup: lw $t2, 16($t3) # y = $t2 = right(p[p[x]])
			lw $t2, 16($t1) # y = $t2 = right(p[p[x]])
			
			
			beq $t2, -1,  elseInsertRBTree2 # y is null, so its color is black. The program can branch straight away
			lw $t5, 4($t2) # $t5 = color(y)
			
			bne $t5, 1, elseInsertRBTree2 # if color(y)==red, continue; else, branch to elseInsertRBTree2
			ifInsertRBTree2:
				##test##
				lw $t3, 8($a1)
				##test##
				sw $t1, 4($s3)
				changeNodeColorToBlack($t3) # color(p[x]) = black
				lw $t1, 4($s3)
				sw $t1, 4($s3)
				changeNodeColorToBlack($t2) #  color[y] = black
				lw $t1, 4($s3)
				
				sw $t2, 4($s3)
				move $t2, $t1
				changeNodeColorToRed($t2) # ($t1) color(p[p[x]]) = red
				move $t1, $t2
				lw $t2, 4($s3)
				
				move $a1, $t1 # x = p[p[x]]
				
				
				
				
					
				j continueWhileVerificationInsertRBTree
			elseInsertRBTree2:
			
			
				lw $t6, 16($t3)
				bne $a1, $t6, continueElseInsertRBTree2 # (if x = right(p[x])), continue; Else, branch to continueElseInsertRBTree
				ifInsertRBTree3:
				

	
	
				
				
				
					move $a1, $t3 # x = p[x]
					
					
					
					
					# store all registers in the stack
					sw $t0, 0($s3)
					sw $t1, 4($s3)
					sw $t2, 8($s3)
					sw $t3, 12($s3)
					sw $t4, 16($s3)
					sw $t5, 20($s3)
					sw $t6, 24($s3)
					sw $t7, 28($s3)
					sw $s1, 32($s3)
					sw $s7, 36($s3)
					sw $a0, 40($s3)
					sw $a1, 44($s3)
					
					move $v1, $a1
					leftRotate($v1) # leftRotate(T, x)
					li $v1, 0
					
				
					# load all registers in the stack
					lw $t0, 0($s3)
					lw $t1, 4($s3)
					lw $t2, 8($s3)
					lw $t3, 12($s3)
					lw $t4, 16($s3)
					lw $t5, 20($s3)
					lw $t6, 24($s3)
					lw $t7, 28($s3)
					lw $s1, 32($s3)
					lw $s7, 36($s3)
					lw $a0, 40($s3)
					lw $a1, 44($s3)
			
			
				#continueElse
				continueElseInsertRBTree2:
				##test##
				lw $t3, 8($a1)
				##test##
					sw $t1, 4($s3)
					changeNodeColorToBlack($t3) # color(p[x]) = black
					lw $t1, 4($s3)
					sw $t2, 4($s3)
					move $t2, $t1
					changeNodeColorToRed($t2) # color(p[p[x]]) = red
					move $t1, $t2
					lw $t2, 4($s3)
					
					# store all registers in the stack
					sw $t0, 0($s3)
					sw $t1, 4($s3)
					sw $t2, 8($s3)
					sw $t3, 12($s3)
					sw $t4, 16($s3)
					sw $t5, 20($s3)
					sw $t6, 24($s3)
					sw $t7, 28($s3)
					sw $s1, 32($s3)
					sw $s7, 36($s3)
					sw $a0, 40($s3)
					sw $a1, 44($s3)
					
					
					move $v1, $t1
					rightRotate($v1) # rightRotate(T, x)
					li $v1, 0
					
					
					# load all registers in the stack
					lw $t0, 0($s3)
					lw $t1, 4($s3)
					lw $t2, 8($s3)
					lw $t3, 12($s3)
					lw $t4, 16($s3)
					lw $t5, 20($s3)
					lw $t6, 24($s3)
					lw $t7, 28($s3)
					lw $s1, 32($s3)
					lw $s7, 36($s3)
					lw $a0, 40($s3)
					lw $a1, 44($s3)
					
					
					j continueWhileVerificationInsertRBTree
		
		elseInsertRBTree1: # the same, but with "right" and "left" swapped
		
			
			
		
		
			# Original, backup: lw $t2, 12($t3) # y = $t2 = left(p[p[x]])
			lw $t2, 12($t1) # y = $t2 = left(p[p[x]])
			
			
			beq $t2, -1,  elseInsertRBTree2Else # y is null, so its color is black. The program can branch straight away
			lw $t5, 4($t2) # $t5 = color(y)
			
			bne $t5, 1, elseInsertRBTree2Else # if color(y)==red, continue; else, branch to elseInsertRBTree2
			ifInsertRBTree2Else:
				##test##
				lw $t3, 8($a1)
				##test##
				sw $t1, 4($s3)
				changeNodeColorToBlack($t3) # color(p[x]) = black
				lw $t1, 4($s3)
				sw $t1, 4($s3)
				changeNodeColorToBlack($t2) # color[y] = black
				lw $t1, 4($s3)
				
				sw $t2, 4($s3)
				move $t2, $t1
				changeNodeColorToRed($t2) # color(p[p[x]]) = red
				move $t1, $t2
				lw $t2, 4($s3)
				
				move $a1, $t1 # x = p[p[x]]
				
				
				
					
				j continueWhileVerificationInsertRBTree
			elseInsertRBTree2Else:
			
			
				lw $t6, 12($t3)
				bne $a1, $t6, continueElseInsertRBTree2Else # (if x = left(p[x])), continue; Else, branch to continueElseInsertRBTree
				ifInsertRBTree3Else:
					move $a1, $t3 # x = p[x]
					
					
					# store all registers in the stack
					sw $t0, 0($s3)
					sw $t1, 4($s3)
					sw $t2, 8($s3)
					sw $t3, 12($s3)
					sw $t4, 16($s3)
					sw $t5, 20($s3)
					sw $t6, 24($s3)
					sw $t7, 28($s3)
					sw $s1, 32($s3)
					sw $s7, 36($s3)
					sw $a0, 40($s3)
					sw $a1, 44($s3)
					
					move $v1, $a1
					rightRotate($v1) # rightRotate(T, x)
					li $v1, 0
					
					
					# load all registers in the stack
					lw $t0, 0($s3)
					lw $t1, 4($s3)
					lw $t2, 8($s3)
					lw $t3, 12($s3)
					lw $t4, 16($s3)
					lw $t5, 20($s3)
					lw $t6, 24($s3)
					lw $t7, 28($s3)
					lw $s1, 32($s3)
					lw $s7, 36($s3)
					lw $a0, 40($s3)
					lw $a1, 44($s3)
					
					
			
				#continueElse
				
			
				continueElseInsertRBTree2Else:
					##test##
					lw $t3, 8($a1)
					##test##
					
					sw $t1, 4($s3)
					changeNodeColorToBlack($t3) # color(p[x]) = black
					lw $t1, 4($s3)
					
					sw $t2, 4($s3)
					move $t2, $t1
					changeNodeColorToRed($t1) # color(p[p[x]]) = red
					move $t1, $t2
					lw $t2, 4($s3)
					
					# store all registers in the stack
					sw $t0, 0($s3)
					sw $t1, 4($s3)
					sw $t2, 8($s3)
					sw $t3, 12($s3)
					sw $t4, 16($s3)
					sw $t5, 20($s3)
					sw $t6, 24($s3)
					sw $t7, 28($s3)
					sw $s1, 32($s3)
					sw $s7, 36($s3)
					sw $a0, 40($s3)
					sw $a1, 44($s3)
						
					move $v1, $t1
					leftRotate($v1) # leftRotate(T, p[p[x]])
					li $v1, 0
					
					
					# load all registers in the stack
					lw $t0, 0($s3)
					lw $t1, 4($s3)
					lw $t2, 8($s3)
					lw $t3, 12($s3)
					lw $t4, 16($s3)
					lw $t5, 20($s3)
					lw $t6, 24($s3)
					lw $t7, 28($s3)
					lw $s1, 32($s3)
					lw $s7, 36($s3)
					lw $a0, 40($s3)
					lw $a1, 44($s3)
						
					
					
					j continueWhileVerificationInsertRBTree
		
	
	
	
	
	continueWhileVerificationInsertRBTree:
		updateRoot()
		#changeNodeColorToBlack($s7)#color[root(T)] = black
		# Original, backup: beq $a1, $s1, endInsertRBTree # while test: if x==root, branch to endInsertRBTree
		beq $a1, $s7, endInsertRBTree # while test: if x==root, branch to endInsertRBTree
		
		lw $t3, 8($a1)
		
		
		
		lw $t4, 4($t3)
		bne $t4, 1, endInsertRBTree # while test: if color(p[x])!=red, branch to endInsertRBTree
		
		#test
		#lw $t1, 8($t3)
		#beq $t1, -1, endInsertRBTree
		
		
		j whileInsertTree
	endInsertRBTree:
	updateRoot()
	sw $t1, 4($s3)
	changeNodeColorToBlack($s7)#color[root(T)] = black
	lw $t1, 4($s3)
.end_macro


.macro leftRotate(%reg) # rotate to left. The parameter points to the address of the node (to be rotated)
	# %reg = x
	# $t0 = y
	# $t1 = left(y)
	# $t2 = left(y).getValue()
	# $t3 = p[x]
	# $t4 = left[p[x]]
	# $t5 = 
	# $t6 = 
	# $t7 =   
	
	lw $t0, 16(%reg) # (rotateLeft) y = right[x]
	
	lw $t1, 12($t0) # left(y)
	sw $t1, 16(%reg) # right(x) = left(y)
	
	#lw $t2, 0($t1) # $t2 = left(y).getValue()
	#beq $t2, -1, leftRotateItIsNull # if left(y)!=null, branch to leftRotateItIsNull
	
	beq $t1, -1, leftRotateItIsNull # if left(y)!=null, branch to leftRotateItIsNull
	
	
	
	#if left(y) is null:	
	 sw %reg, 8($t1)# p[left(y)] = x
	
	#else
	leftRotateItIsNull:
	lw $t3, 8(%reg)
	sw $t3, 8($t0) # p[y] = p[x]
	
	bne $t3, -1, leftRotateParentXIsNotNull # if p[x]!=null, branch to leftRotateParentXIsNotNull
	# case: p[x] = null
		move $s7, $t0 # root(T) = y
	
		j endLeftRotate
	
	#case: p[x]!=null
	leftRotateParentXIsNotNull:
		lw $t4, 12($t3) # left[p[x]]
		bne %reg, $t4, leftRotateXIsNotLeftSon # if x!=left[p[x]], branch to leftRotateXIsNotLeftSon 
		
		# case: x = left[p[x]]
			sw $t0, 12($t3) # left[p[x]] = y
			j endLeftRotate
		
		#case: c!=left[p[x]]
		leftRotateXIsNotLeftSon:
			sw $t0, 16($t3) # right[p[x]] = y
		
	
	
	endLeftRotate:
		sw %reg, 12($t0) # left[y] = x
		#sw $t0, 12(%reg) # p[x] = y # befor: backup
		sw $t0, 8(%reg) # p[x] = y
.end_macro

.macro rightRotate(%reg) # rotate to right. The parameter points to the address of the node (to be rotated)
	# %reg = x
	# $t0 = y
	# $t1 = right(y)
	# $t2 = right(y).getValue()
	# $t3 = p[x]
	# $t4 = right[p[x]]
	# $t5 = 
	# $t6 = 
	# $t7 =   

	lw $t0, 12(%reg) # (rotateRight )y = left[x]
	
	lw $t1, 16($t0) # right(y)
	sw $t1, 12(%reg) # left(x) = right(y)
	
	#lw $t2, 0($t1) # $t2 = left(y).getValue()
	#beq $t2, -1, leftRotateItIsNull # if left(y)!=null, branch to leftRotateItIsNull
	
	beq $t1, -1, rightRotateItIsNull # if right(y)!=null, branch to leftRotateItIsNull
	
	
	
	#if right(y) is null:	
	 sw %reg, 8($t1)# p[right(y)] = x
	
	#else
	rightRotateItIsNull:
	lw $t3, 8(%reg)
	sw $t3, 8($t0) # p[y] = p[x]
	
	
	bne $t3, -1, rightRotateParentXIsNotNull # if p[x]!=null, branch to rightRotateParentXIsNotNull
	# case: p[x] = null
		move $s7, $t0 # root(T) = y
	
		j endRightRotate
	
	#case: p[x]!=nul
	rightRotateParentXIsNotNull: 
		
		
		
		lw $t4, 16($t3) # right[p[x]]
		bne %reg, $t4, rightRotateXIsNotLeftSon # if x!=right[p[x]], branch to rightRotateXIsNotLeftSon 
		
		# case: x = right[p[x]]
			sw $t0, 16($t3) # right[p[x]] = y
			j endRightRotate
		
		#case: c!=right[p[x]]
		rightRotateXIsNotLeftSon:
			sw $t0, 12($t3) # left[p[x]] = y
		
	
	
	endRightRotate:
		sw %reg, 16($t0) # right[y] = x
		sw $t0, 8(%reg) # p[x] = y
.end_macro

.macro checkRedBlackTreeProperties() # check all properties of red-black tree (result in $v0)
	li $v0, 0
.end_macro
	
	
.macro changeColorRootToBlack()
	move $t0, $s0 # root
	changeColorRootLoopToBlack:
		
	
		move $t1, $t0 # 
		addi $t1, $t1, 8   # point to node father
		lw $t2, 0($t1)   # get node father value
				
		beq $t2, -1, endChangeColorRootLoopToBlack
		
		addi $t0, $t0, 20 # going to the next node
		j changeColorRootLoopToBlack
		endChangeColorRootLoopToBlack:
		addi $t1, $t1, -4
		li $t3, 0
		sw $t3, 0($t1)
		
.end_macro


.macro ajustRedBlackTree()
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	loopAjustTree: # keep in the loop until the tree is ajusted
		#checkRedBlackTreeProperties() # in the beginninig (result in $v0)
		#checkColorRoot() # result in $v0
		#checkIfExistsCase2a1() # result in $v0
		#checkIfExistsCase2a2() # result in ¢v0
		#checkIfExistsCase2b1() # result in $v0
		#checkIfExistsCase2b2() # result in $v0
		#checkRedBlackTreeProperties() # in the end (result in $v0)
		#beq $v0, 1, endLoopAjustTree # If tree is ajusted, go to the end
		
	endLoopAjustedTree:
.end_macro

.macro findRoot(%reg)
	la $t1, tree
	loopFindRoot:
		addi $t1, $t1, 8
		lw $t2, 0($t1)
		beq $t2, -1, endFindRoot
		lw $t1, 0($t1)
		j loopFindRoot
	endFindRoot:
		addi $t1, $t1, -8
		add %reg, $t1, $zero
		li $t1, 0
		li $t2, 0
.end_macro			
	insertInTree:
		add $t7, $zero, $s0 # put the tree addres in $s1 in order to iterate
		
		
		
		lw $t1, 0($t7) # beginning of tree, $t7
		li $t2, -1
		li $t6, -1 # Set first father to -1 (null)
		bne $t1, $t2, beforeInsertLoop
		
		
		addNode:
		###### If it is the first elem  ######
			#add node value
				sw $a0, 0($t7)
				add $t7, $t7, 4
				
				# add node color
				li $t1, 1
				sw $t1, 0($t7)
				add $t7, $t7, 4
				
				
				# add node father (null)
				sw $t6, 0($t7)
				add $t7, $t7, 4
				
				
				# add node left child (null)
				li $t1, -1
				sw $t1, 0($t7)
				add $t7, $t7, 4
				
				# add node left child (null)
				sw $t1, 0($t7)
				add $t7, $t7, 4
				
				# update the next empy space for the next node
				addi $s1, $s1, 20
				
				jr $ra 
		################################################
			
		beforeInsertLoop:
			move $t7, $s7
		insertTreeLoop:
				
			
			
			
			#findRoot($t7) # find the tree root and puts it into $t1
			# findFatherOfFathers, iteratively
			
			#lw $t1, 0($t7) # beginning of tree, $t7
			lw $t1, 0($t7) # beginning of tree root (or current node), $t7
			#lw $t1, 0($s7) # $s7 ponits to the root address
			
			slt $t3, $a0, $t1 # if newValue<root: $t3 = 1; neValue>=root: $t3 = 0;
			
			
			beqz $t3, rightChild
			
			leftChild:
				add $t6, $zero, $t7 # store the address of $t7. $t6 stores the address of the node father
				#add $t6, $zero, $s7 # $s7 points to the root address, move it to $t6
				
				
				
				addi $t7, $t7, 12 # point to lefChild
				#addi $t7, $s7, 12 # $t7 points to the leftChild of the root node
				
				
				
				
				li $t5, -1
				lw $t2, 0($t7)
				beq $t5, $t2, leftIsNull # if left is null
				
				j leftEnd
				leftIsNull:
					add $t5, $zero, $s1
					sw $t5, 0($t7) 
					add $t7, $zero, $s1
					j addNode
				leftEnd:
				lw $t5, 0($t7)
				add $t7, $zero, $t5 
				j insertTreeLoop
				
				
			rightChild:
				add $t6, $zero, $t7 # store the address of $t7. $t6 stores the address of the node father
				#add $t6, $zero, $s7 # store the address of $t7. $t6 stores the address of the node father
				
				
				addi $t7, $t7, 16 # point to rightChild
				#addi $t7, $s7, 16 # point to rightChild
				
				
				
				
				li $t5, -1
				lw $t2, 0($t7)
				beq $t5, $t2, rightIsNull # if right is null
				
				j endRight
				rightIsNull:
					add $t5, $zero, $s1
					sw $t5, 0($t7)  
					add $t7, $zero, $s1
					j addNode
				endRight:
				lw $t5, 0($t7)
				add $t7, $zero, $t5  
				j insertTreeLoop
			
			
			
			lw $t0, 0($s1)
			beq $t0, -1, isNull # if True, branch to isNull. Else, continue;
			
			slt $t1, $a0, $t0 # if new Value<root: $t1=1; if newValue>=root: $t1 = 0;
			
			
			beq $t1, 1, leftChild # branch to leftChild if newValue<root
			j rightChild # else, jump to rigghtChild
			
			
			
				mul $t1, $t1, 2 #set the new top of stack
				addi $t2, $t1, -4 # just to set the real position of the element
				add $s1, $s1, $t2
				j insertTreeLoop
				

				mul $t1, $t1, 2 #set the new top of stack
				addi $t1, $t1, 4 #set the new top of stack
				addi $t2, $t1, -4 # just to set the real position of the element
				add $s1, $s1, $t2
				j insertTreeLoop
			
			isNull:
				
				sw $a0, 0($s1) # load the value into the memory
				add $s1, $zero, $zero # set $s1 to 0 
		
		
		
		jr $ra
		
		
		
		
	ajustRedBlackTree:
		jr $ra



.globl main

main:
	
	#li $t1, 4 # Number of elements the professor will put in the input. In first case, consider 3.
	#mul $t1, $t1, 4 # Each node has 4 fiels: Address, Color, LeftChild, RightChild
	#li $t0, 0
	#sub $t0, $t0, $t1
		
	
	#sub $sp, $sp, $s1 # sub, i.ie, takes as much space as it needs in the stack to execute (size will be specified by the professor, but for now it is equals to 3)
	#add $sp, $sp, $t0 # stack size
	
	
	
	#-1 is used in order to represent "null"
	# Original, backup: la $s0, tree  # load the tree address
	
	la $s0, 0x10040000 # correto
	
	
	add $s7, $s0, $zero # root address
	add $s1, $zero, $s0 # copy of the tree addres, in order to exploit it
	li $t1, -1
	sw $t1, 0($s0)
	add $s1, $zero, $s0 # the next free space in the tree (it will be changed in the procedures)
	
	
	
	# $s0 -> Tree address
	# $s1 -> Next available space
	# $s7 -> Root address

	
	# $s4 -> N (number of elements to be put in the tree) 
	# $a3 -> S (seed)
	# $s6 ->
	# $s2 -> buffer of inputs
	# $s4 -> number of nodes to be put in the tree
	
	
	la $s2, buffer
	
	readFile() # $s4 contains the number of nodes to be put in the tree and $a3 contains the seed
	
		
	
	move $a1, $a3 # move ($a3) (seed) to $a1
	#li $a1, 1 # move ($a3) (seed) to $a1
	li $a0, 1 # any int
	li $v0, 40
	syscall
	#li $v0, 42
	#li $a1, 10000
	#syscall
	
	
	#lw $s5, 0($s2)
	#move $s4, $s5 # put number of nodes in the tree in $s4
	
	#j endLoopInsertNodesInTheTree # TESTE
	#li $s4, 5 # N = number of nodes in the RBTree (to be read in the document). In the beginning, set $s4 to 4.
		loopInsertNodesInTheTree:
			addi $sp, $sp, -4
			sw $a0, 0($sp)
			
			li $v0, 42
			li $a1, 10000 # int in range [0, 10000)
			syscall
			#$a0 = randomNumber
			
			insertRBTree()
			addi $s4, $s4, -1 # n = n-1
			beq $s4, 0, endLoopInsertNodesInTheTree
			
			lw $a0, 0($sp)
			addi $sp, $sp, 4
			j loopInsertNodesInTheTree
		
	endLoopInsertNodesInTheTree:
	
	
	
	
	move $t4, $s1 # Thats the next available space (it will be used to store the postOrder elements)
	move $t3, $t4
	
	
	
	move $t2, $s7
	
	jal printInPostOrder
	li $t0, -2
	sw $t0, 0($t3)
	
	
	
	
	writeInFile($s1)
	
	
	
	
	#readFile()
	
	
	
	li $v0, 10
	syscall
	
