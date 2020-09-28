# Esercizio 3
# Nome: Alessio Falai
# Matricola: 6134275
# Email: alessio.falai@stud.unifi.it
# Data di consegna: 02/07/2017

.data
	str_dim: .asciiz "Inserire la dimensione delle matrici quadrate: "
	str_insert: .asciiz "Inserire il prossimo elemento: "
	str_exit: .asciiz "Programma terminato."
	str_menu: .asciiz "a) Inserimento di matrici\nb) Somma di matrici\nc) Sottrazione di matrici\nd) Prodotto di matrici\ne) Uscita\n"
	newline: .asciiz "\n"
	double_newline: .asciiz "\n\n"
	space: .asciiz " "
	
.text
.globl main
main:
	# Stampa il menù
	la $a0, str_menu
	li $v0, 4
	syscall

	# Chiamata di sistema per la lettura di un carattere
	li $v0, 12		
	syscall

	add $s5, $zero, $zero	# Registro per il controllo della dimensione delle matrici

	beq $s0, $zero, case_a	# Se le due matrici sono vuote, salta all'inserimento
	beq $v0, 97, case_a		# Inserimento delle matrici
	beq $v0, 98, case_b		# Somma delle matrici
	beq $v0, 99, case_c		# Sottrazione delle matrici
	beq $v0, 100, case_d	# Prodotto delle matrici
	beq $v0, 101, exit 		# Esci dal programma

	# Stampa due linee bianche
	la $a0, double_newline
	li $v0, 4				
	syscall

	j main 	# Se il carattere inserito non è tra quelli presenti nel menù, ristampa tutto

# Inserimento delle matrici
case_a:
	# Stampa due linee bianche
	la $a0, double_newline				
	li $v0, 4
	syscall

	# Inserimento della dimensione delle matrici
	matrix_dimension:
		# Stampa la stringa per l'inserimento della dimensione delle matrici
		la $a0, str_dim
		li $v0, 4
		syscall

		# Salva la vecchia dimensione delle matrici
		move $s5, $s0	

		# Chiamata di sistema per leggere un intero (Dimensione delle matrici) 
		li $v0, 5
		syscall

		# Controllo della dimensione (0 < n < 5), salvata in $s0
		ble $v0, 0, matrix_dimension
		bgt $v0, 4, matrix_dimension
		move $s0, $v0

	mul $s1, $s0, $s0	# $s1 contiene il numero di elementi delle matrici
	mul $t0, $s1, 4		# $t0 contiene la dimensione totale (in word) della matrice

	beq $s5, $s0, allocated

	# Allocazione dinamica (sbrk) delle due matrici
	alloc:
		li $v0, 9
		move $a0, $t0
		syscall
		move $s2, $v0

		li $v0, 9							
		move $a0, $t0
		syscall
		move $s3, $v0

	# Memoria già allocata, procede al caricamento delle matrici
	allocated:
		add $t7, $zero, $zero	# $t7 viene utilizzato per distinguere l'inserimento della prima matrice dalla seconda
		move $t2, $s2			# $t2 viene utilizzato per scorrere gli elementi delle matrici
		fill:
			add $t1, $zero, $zero	# $t1 conta il numero di elementi inseriti
			addi $t7, $t7, 1
			insert:
				# Stampa la stringa di inserimento di un elemento
				la $a0, str_insert
				li $v0, 4
				syscall

				# Inserimento di un elemento da tastiera
				li $v0, 5
				syscall

				sw $v0, 0($t2)			# Salva il valore inserito nella matrice
				addi $t2, $t2, 4		# Seleziona la posizione successiva della matrice
				addi $t1, $t1, 1		# Incremento il numero di elementi inseriti
				bne $t1, $s1, insert 	# Inserisco finchè la matrice non è piena

			# Stampa una linea vuota
			la $a0, newline
			li $v0, 4
			syscall

			# Inizializza i registri per la stampa della matrice
			add $t1, $zero, $zero				# $t1 contiene il numero di elementi stampati 
			add $t3, $zero, $zero				# $t3 contiene il numero di elementi presenti in ogni riga
			move $t2, $s2						# $t2 contiene il puntatore alla matrice
			beq $t7, 2, select_second_matrix	# Controlla quale delle due matrici si deve stampare
			j print_row

			# Seleziona la seconda matrice per la stampa
			select_second_matrix:
				move $t2, $s3

			# Stampa una riga della matrice
			print_row:
				lw $a0, 0($t2)
				li $v0, 1
				syscall
				la $a0, space
				li $v0, 4
				syscall

				addi $t1, $t1, 1
				addi $t3, $t3, 1
				addi $t2, $t2, 4
				beq $t1, $s1, end_pr	# Se il numero di elementi stampati è uguale al numero di elementi totali, esci
				beq $t3, $s0, new_row	# Se la riga attuale è stata completamente stampata, seleziona la successiva
				j print_row				# Altrimenti continua a stampare gli elementi della riga attuale

			# Seleziona una nuova riga della matrice
			new_row:
				add $t3, $zero, $zero
				la $a0, newline
				li $v0, 4
				syscall
				j print_row

			# Fine della stampa
			end_pr:
				# Stampa due linee bianche
				la $a0, double_newline
				li $v0, 4
				syscall
			
				beq $t7, 2, main 	# Se si sono processate entrambe le matrici torna al main
				move $t2, $s3		# Altrimenti carica l'indirizzo della seconda matrice in $t2
				j fill				# E salta alla procedura di inserimento degli elementi

# Somma delle matrici
case_b:
	# Stampa due linee bianche
	la $a0, double_newline
	li $v0, 4
	syscall

	add $t1, $zero, $zero		# $t1 contiene il numero totale di elementi processati
	add $t3, $zero, $zero		# $t3 contiene il numero di elementi processati per ogni riga
	move $t2, $s2				# $t2 contiene il puntatore alla prima matrice
	move $t4, $s3				# $t4 contiene il puntatore alla seconda matrice

	# Calcola la somma fra elementi delle due matrici
	sum_row:
		# Somma i due elementi e stampa il risultato
		lw $a0, 0($t2)
		lw $a1, 0($t4)
		add $a0, $a0, $a1
		li $v0, 1
		syscall
		la $a0, space
		li $v0, 4
		syscall

		addi $t1, $t1, 1		# Incrementa il numero totale di elementi processati
		addi $t3, $t3, 1		# Incrementa il numero di elementi processati nella riga corrente
		addi $t2, $t2, 4		# Punta all'elemento successivo della prima matrice
		addi $t4, $t4, 4		# Punta all'elemento successivo della seconda matrice
		beq $t1, $s1, end_sum	# Se sono stati processati tutti gli elementi, esci
		beq $t3, $s0, new_sum	# Se sono stati processati tutti gli elementi della riga corrente, seleziona la riga successiva
		j sum_row				# Altrimenti continua a lavorare sulla stessa riga

	# Seleziona una nuova riga delle due matrici
	new_sum:
		add $t3, $zero, $zero	# Inizializza il contatore del numero di elementi processati della nuova riga
		la $a0, newline
		li $v0, 4
		syscall
		j sum_row

	# Fine della somma
	end_sum:
		la $a0, double_newline
		li $v0, 4
		syscall
		j main

# Sottrazione delle matrici
case_c:
	# Stampa due linee bianche
	la $a0, double_newline
	li $v0, 4
	syscall

	add $t1, $zero, $zero		# $t1 contiene il numero totale di elementi processati
	add $t3, $zero, $zero		# $t3 contiene il numero di elementi processati per ogni riga
	move $t2, $s2				# $t2 contiene il puntatore alla prima matrice
	move $t4, $s3				# $t4 contiene il puntatore alla seconda matrice

	# Calcola la differenza fra elementi delle due matrici
	sub_row:
		# Sottrae i due elementi e stampa il risultato
		lw $a0, 0($t2)
		lw $a1, 0($t4)
		sub $a0, $a0, $a1
		li $v0, 1
		syscall
		la $a0, space
		li $v0, 4
		syscall

		addi $t1, $t1, 1		# Incrementa il numero totale di elementi processati
		addi $t3, $t3, 1		# Incrementa il numero di elementi processati nella riga corrente
		addi $t2, $t2, 4		# Punta all'elemento successivo della prima matrice
		addi $t4, $t4, 4		# Punta all'elemento successivo della seconda matrice
		beq $t1, $s1, end_sub	# Se sono stati processati tutti gli elementi, esci
		beq $t3, $s0, new_sub	# Se sono stati processati tutti gli elementi della riga corrente, seleziona la riga successiva
		j sub_row				# Altrimenti continua a lavorare sulla stessa riga

	# Seleziona una nuova riga delle due matrici
	new_sub:
		add $t3, $zero, $zero	# Inizializza il contatore del numero di elementi processati della nuova riga
		la $a0, newline
		li $v0, 4
		syscall
		j sub_row

	# Fine della sottrazione
	end_sub:
		la $a0, double_newline
		li $v0, 4
		syscall
		j main

# Prodotto delle matrici
case_d:
	# Stampa due linee bianche
	la $a0, double_newline
	li $v0, 4
	syscall

	add $s4, $zero, $zero	# $s4 contiene il numero di iterazioni necessarie a cambiare riga
	add $t0, $zero, $zero
	mul $t0, $s0, $s1		# $t0 contiene il numero di iterazioni (n x n x n)
	add $t1, $zero, $zero	# $t1 conta il numero totale di iterazioni (fino ad arrivare a $t0)
	add $t3, $zero, $zero	# $t3 conta il numero di passi necessari a calcolare ogni elemento
	add $t5, $zero, $zero	# $t5 mantiene il conto del cambio di colonna
	add $t6, $zero, $zero
	mul $t6, $s0, 4			# $t6 viene utilizzato per il movimento sulla colonna oppure per il cambio di riga
	add $t7, $zero, $zero	# $t7 contiene la somma parziale di ogni elemento della matrice prodotto
	add $t8, $zero, $zero	# $t8 è un registro di appoggio, che viene utilizzato per salvare risultati di operazioni 
	addi $t9, $zero, 0		# $t9 contiene il numero di riga corrente
	move $t2, $s2			# $t2 contiene il puntatore alla prima matrice
	move $t4, $s3			# $t4 contiene il puntatore alla seconda matrice

	# Calcola il prodotto tra una riga della prima matrice e una colonna della seconda matrice
	multiply:
		lw $a0, 0($t2)		# $a0 contiene il valore estratto dalla prima matrice
		lw $a1, 0($t4)		# $a1 contiene il valore estratto dalla seconda matrice
		mul $a0, $a0, $a1	# $a0 contiene il prodotto tra i due elementi considerati
		add $t7, $t7, $a0	# $t7 viene aggiornato, aggiungendo il prodotto appena calcolato

		addi $s4, $s4, 1	# Incrementa il contatore del numero di iterazioni necessarie a cambiare riga
		addi $t1, $t1, 1	# Incrementa il numero di iterazioni effettuate
		addi $t3, $t3, 1	# Incrementa il numero di passi effettuati per l'elemento attuale
		addi $t2, $t2, 4	# Incrementa il puntatore della prima matrice (Prossimo elemento della stessa riga)
		add $t4, $t4, $t6	# Incrementa il puntatore della seconda matrice (Prossimo elemento della stessa colonna)

		beq $t3, $s0, next_element	# Se l'elemento è stato completamente processato si passa al successivo  
		j multiply					# Altrimenti si continua con il calcolo della somma parziale

	# Prepara le matrici in ingresso per calcolare l'elemento successivo della matrice prodotto
	next_element:
		# Stampa l'elemento processato
		move $a0, $t7		
		li $v0, 1
		syscall
		la $a0, space
		li $v0, 4
		syscall

		addi $t5, $t5, 4		# Incrementa il contatore di cambio di colonna
		add $t3, $zero, $zero	# Azzera il numero di passi effettuati per l'elemento attuale
		add $t7, $zero, $zero	# Azzera la somma parziale
		move $t2, $s2			# Ricarica il puntatore iniziale della prima matrice
		move $t4, $s3			# Ricarica il puntatore iniziale della seconda matrice
		mul $t8, $t9, $t6		# Calcola l'offset necessario a selezionare la giusta riga
		add $t2, $t2, $t8		# Aggiunge lo scostamento calcolato al puntatore alla prima matrice
		add $t4, $t4, $t5		# Aggiunge l'offset necessario a selezionare la giusta colonna al puntatore alla seconda matrice

		beq $t1, $t0, end_mul	# Se sono state effettuate tutte le iterazioni, esci
		beq $s4, $s1, next_row	# Controlla se è necessario cambiare riga 
		j multiply				# Altrimenti continua a lavorare sulla stessa riga

	# Seleziona la riga successiva della prima matrice
	next_row:
		# Stampa due linee bianche
		la $a0, newline
		li $v0, 4
		syscall

		add $s4, $zero, $zero	# Azzera il numero di iterazioni necessarie a cambiare riga
		add $t5, $zero, $zero	# Azzera il contatore del cambio di colonna
		addi $t9, $t9, 1		# Incrementa il numero di riga
		mul $t8, $t9, $t6		# Calcola l'incremento necessario a cambiare riga
		move $t2, $s2			# Ricarica il puntatore iniziale della prima matrice
		add $t2, $t2, $t8		# Passa alla riga successiva
		move $t4, $s3			# Ricarica il puntatore iniziale della seconda matrice
		
		j multiply				# Inizia a calcolare il prodotto, partendo dalla nuova riga

	# Fine della moltiplicazione
	end_mul:
		la $a0, double_newline
		li $v0, 4
		syscall
		j main

# Esci dal programma
exit:
	la $a0, double_newline
	li $v0, 4
	syscall
	la $a0, str_exit
	li $v0, 4
	syscall

	li $v0, 10
	syscall
