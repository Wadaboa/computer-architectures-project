# Esercizio 1
# Nome: Alessio Falai
# Matricola: 6134275
# Email: alessio.falai@stud.unifi.it
# Data di consegna: 02/07/2017

.data
	prompt: .asciiz "Inserire la stringa da analizzare: "
	user: .space 100
	one: .asciiz "uno"
	two: .asciiz "due"
	nine: .asciiz "nove"

.text
.globl main
main:
	# Stampa della stringa di inserimento
	la $a0, prompt
	li $v0, 4
	syscall

	# Input della stringa da analizzare
	la $a0, user
	li $a1, 100
	li $v0, 8
	syscall
	
	# Carica la stringa utente
	la $s0, user

strcmp:
	la $t1, one 			# Carica nel registro $t1 l'indirizzo della stringa "uno"
	la $t2, two 			# Carica nel registro $t2 l'indirizzo della stringa "due"
	la $t3, nine 			# Carica nel registro $t3 l'indirizzo della stringa "nove"
	lb $t0, 0($s0) 			# Carica nel registro $t0 il primo carattere della nuova parola della stringa da analizzare
	lb $t4, 0($t1)			# Carica nel registro $t4 il primo carattere della stringa "uno"
	lb $t5, 0($t2) 			# Carica nel registro $t5 il primo carattere della stringa "due"
	lb $t6, 0($t3) 			# Carica nel registro $t6 il primo carattere della stringa "nove"
	addi $t7, $zero, 1		# Inizializza il contatore del numero di caratteri di ogni parola
	beq $t0, 10, exit 		# Se la stringa da analizzare è finita esce dal programma 
	beq $t0, $t4, cmp_one	# Se il primo carattere della nuova parola della stringa da analizzare è uguale a 'u' salta a cmp_one
	beq $t0, $t5, cmp_two	# Se il primo carattere della nuova parola della stringa da analizzare è uguale a 'd' salta a cmp_two
	beq $t0, $t6, cmp_nine 	# Se il primo carattere della nuova parola della stringa da analizzare è uguale a 'n' salta a cmp_nine
	j print_question		# Se i controlli precedenti falliscono stampa un punto interrogativo

# Controlla se la parola analizzata corrisponde a "uno"
cmp_one:
	beq $t7, 3, check_one	# Se $t7 è uguale a 3, significa che abbiamo analizzato tutta la parola "uno" 
	addi $t1, $t1, 1		# Incrementa il puntatore all'indirizzo della stringa "uno"
	addi $s0, $s0, 1		# Incrementa il puntatore all'indirizzo della stringa da analizzare
	lb $t0, 0($s0)			# Carica il byte successivo della stringa da analizzare
	lb $t4, 0($t1)			# Carica il byte successivo della stringa "uno"
	addi $t7, $t7, 1		# Incrementa il numero di caratteri analizzati
	beq $t0, $t4, cmp_one	# Se i due caratteri estratti coincidono, passa al controllo dei byte successivi
	j print_question		# Altrimenti stampa un punto interrogativo

# Controlla il carattere successivo a 'o' della stringa da analizzare
check_one:
	addi $s0, $s0, 1		# Incrementa il puntatore all'indirizzo della stringa da analizzare
	lb $t0, 0($s0)			# Carica il carattere successivo della stringa da analizzare
	beq $t0, 10, print_one	# Se il carattere estratto è il carattere di fine riga, stampa 1
	beq $t0, 32, print_one	# Se il carattere estratto è uno spazio, stampa 1
	j print_question		# Altrimenti stampa un punto interrogativo 

# Controlla se la parola analizzata corrisponde a "due"
cmp_two:
	beq $t7, 3, check_two	# Se $t7 è uguale a 3, significa che abbiamo analizzato tutta la parola "due" 
	addi $t2, $t2, 1		# Incrementa il puntatore all'indirizzo della stringa "due"
	addi $s0, $s0, 1		# Incrementa il puntatore all'indirizzo della stringa da analizzare
	lb $t0, 0($s0)			# Carica il byte successivo della stringa da analizzare
	lb $t5, 0($t2)			# Carica il byte successivo della stringa "due"
	addi $t7, $t7, 1		# Incrementa il numero di caratteri analizzati
	beq $t0, $t5, cmp_two	# Se i due caratteri estratti coincidono, passa al controllo dei byte successivi
	j print_question		# Altrimenti stampa un punto interrogativo

# Controlla il carattere successivo a 'e' della stringa da analizzare
check_two:
	addi $s0, $s0, 1		# Incrementa il puntatore all'indirizzo della stringa da analizzare
	lb $t0, 0($s0)			# Carica il carattere successivo della stringa da analizzare
	beq $t0, 10, print_two	# Se il carattere estratto è il carattere di fine riga, stampa 2
	beq $t0, 32, print_two	# Se il carattere estratto è uno spazio, stampa 2
	j print_question		# Altrimenti stampa un punto interrogativo 

# Controlla se la parola analizzata corrisponde a "nove"
cmp_nine:
	beq $t7, 4, check_nine	# Se $t7 è uguale a 4, significa che abbiamo analizzato tutta la parola "nove" 
	addi $t3, $t3, 1		# Incrementa il puntatore all'indirizzo della stringa "nove"
	addi $s0, $s0, 1		# Incrementa il puntatore all'indirizzo della stringa da analizzare
	lb $t0, 0($s0)			# Carica il byte successivo della stringa da analizzare
	lb $t6, 0($t3)			# Carica il byte successivo della stringa "nove"
	addi $t7, $t7, 1		# Incrementa il numero di caratteri analizzati
	beq $t0, $t6, cmp_nine	# Se i due caratteri estratti coincidono, passa al controllo dei byte successivi
	j print_question		# Altrimenti stampa un punto interrogativo

# Controlla il carattere successivo a 'e' della stringa da analizzare
check_nine:
	addi $s0, $s0, 1		# Incrementa il puntatore all'indirizzo della stringa da analizzare
	lb $t0, 0($s0)			# Carica il carattere successivo della stringa da analizzare
	beq $t0, 10, print_nine	# Se il carattere estratto è il carattere di fine riga, stampa 9
	beq $t0, 32, print_nine	# Se il carattere estratto è uno spazio, stampa 9
	j print_question		# Altrimenti stampa un punto interrogativo 

# Stampa il numero 1
print_one:
	addi $s0, $s0, -1		# Decrementa il puntatore della stringa da analizzare in seguito ai controlli di check_one
	li $a0, 1
	li $v0, 1
	syscall

	j print_space 

# Stampa il numero 2
print_two:
	addi $s0, $s0, -1		# Decrementa il puntatore della stringa da analizzare in seguito ai controlli di check_two
	li $a0, 2
	li $v0, 1
	syscall

	j print_space

# Stampa il numero 9
print_nine:
	addi $s0, $s0, -1		# Decrementa il puntatore della stringa da analizzare in seguito ai controlli di check_nine
	li $a0, 9
	li $v0, 1
	syscall

	j print_space

# Stampa uno spazio
print_space:
	li $a0, 32
	li $v0, 11
	syscall

	j next_word

# Seleziona la parola successiva della stringa
next_word:
	addi $s0, $s0, 1
	lb $t0, 0($s0)
	beq $t0, 10, exit
	bne $t0, 32, next_word
	addi $s0, $s0, 1

	j strcmp

# Stampa un punto interrogativo
print_question:
	li $a0, 63
	li $v0, 11
	syscall

	j print_space

# Esce dal programma
exit:
	li $v0, 10
	syscall
