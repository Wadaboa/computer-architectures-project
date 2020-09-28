# Esercizio 2
# Nome: Alessio Falai
# Matricola: 6134275
# Email: alessio.falai@stud.unifi.it
# Data di consegna: 02/07/2017

.data
	prompt: .asciiz "Inserire un numero naturale compreso tra 1 e 8: "
	error: .asciiz "Errore. Il numero inserito non è compreso tra 1 e 8."
	str_arrow: .asciiz "-->"
	str_return: .asciiz ":return"
	char_f: .asciiz "F"
	char_g: .asciiz "G"
	char_openbr: .asciiz "("
	char_closebr: .asciiz ")"

.text
.globl main
main:
	# Stampa la stringa per l'inserimento del numero 'n'
	li $v0, 4
	la $a0, prompt
	syscall

	# Prende in input l'intero 'n'
	li $v0, 5
	syscall

	# Controlla che n sia compreso tra 1 e 8
	add $s0, $v0, $zero
	bgt $s0, 8, print_error
	blt $s0, 1, print_error

	# Chiama la procedura 'g' con il parametro n inserito
	li $v0, 4
	la $a0, char_g
	syscall
	add $a3, $s0, $zero
	jal print_call
	jal g

	j exit

# Se il numero n inserito non è compreso tra 1 e 8 stampa un errore 
print_error:
	li $v0, 4
	la $a0, error
	syscall

	li $a0, 10
	li $v0, 11
	syscall

	j main

# Procedura di stampa della chiamata della funzione 'f' oppure 'g'
print_call:
	addi $sp, $sp, -8		# Prepara due word di spazio nello stack
    sw $ra, 4($sp)			# Salva l'indirizzo di ritorno nello stack
    sw $a3, 0($sp)			# Salva l'argomento passato alla funzione nello stack

    # Stampa una parentesi aperta, l'argomento della funzione ('f' oppure 'g'), una parentesi chiusa e una freccia
	li $v0, 4				
	la $a0, char_openbr
	syscall
	lw $a0, 0($sp)
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, char_closebr
	syscall
	li $v0, 4
	la $a0, str_arrow
	syscall

	# Estrae i valori dallo stack per ripristinare i registri e ritorna al chiamante 
	lw $a3, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

# Procedura di stampa del valore di ritorno della funzione 'f' oppure 'g'
print_return:
	addi $sp, $sp, -8		# Prepara due word di spazio nello stack
    sw $ra, 4($sp)			# Salva l'indirizzo di ritorno nello stack
    sw $a3, 0($sp)			# Salva l'argomento passato alla funzione nello stack

    # Stampa la stringa di return, una parentesi aperta, l'argomento della funzione ('f' oppure 'g') e una parentesi chiusa
	li $v0, 4
	la $a0, str_return
	syscall
	li $v0, 4
	la $a0, char_openbr
	syscall
	lw $a0, 0($sp)
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, char_closebr
	syscall

	# Stampa una freccia se non si sta processando l'ultima chiamata
	bne $a1, 1, print_arrow
	j end_pr

	# Stampa una freccia
	print_arrow:
		li $v0, 4
		la $a0, str_arrow
		syscall

	# Estrae i valori dallo stack per ripristinare i registri e ritorna al chiamante 
	end_pr:
		lw $a3, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra

# Procedura 'f'
f:
	addi $sp, $sp, -8		# Prepara due word di spazio nello stack
    sw $ra, 4($sp)			# Salva l'indirizzo di ritorno nello stack
    sw $a3, 0($sp)			# Salva l'argomento passato alla funzione nello stack
	bne $a3, $zero, core_f	# Se $a3 non contiene zero, ritorna 2 * f(n - 1) + n
	j end_f					# Altrimenti ritorna 1

	# Ritorna 2 * f(n - 1) + n
	core_f:
		# Calcola (n - 1), stampa la chiamata di procedura f(n - 1) e richiama 'f' con parametro (n - 1)
		addi $a3, $a3, -1
		li $v0, 4				
		la $a0, char_f
		syscall
		jal print_call
		jal f

		lw $a3, 0($sp)		# Ripristina il valore originario di 'n'
		mul $v1, $v1, 2		# Calcola il doppio del valore ritornato dalla procedura f(n - 1)
		add $v1, $a3, $v1	# Calcola la somma di 2 * f(n - 1) e 'n'
		
		# Stampa il valore ritornato dalla procedura 'f'
		li $v0, 4
		la $a0, char_f
		syscall
		add $a3, $v1, $zero
		add $a1, $zero, $zero
		jal print_return

		# Estrae i valori dallo stack per ripristinare i registri e ritorna al chiamante 
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra

	# Ritorna 1
	end_f:
		# Stampa la stringa di ritorno della procedura 'f' con parametro 1
		li $v0, 4
		la $a0, char_f
		syscall
		addi $a3, $zero, 1
		add $a1, $zero, $zero
		jal print_return
		li $v1, 1

		# Estrae i valori dallo stack per ripristinare i registri e ritorna al chiamante 
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra

# Procedura 'g'
g:
	add $s1, $zero, $zero	# Inizializzazione variabile 'b'
	add $s2, $zero, $zero	# Inizializzazione variabile 'k'
	addi $sp, $sp, -8		# Prepara due word di spazio nello stack
	sw $ra, 4($sp)			# Salva l'indirizzo di ritorno nello stack
    sw $a3, 0($sp)			# Salva l'argomento passato alla funzione nello stack

    # Per 'k' che va da 0 a 'n', esegue questo blocco di istruzioni
    loop:
    	# Chiama la funzione 'f' con parametro 'k' e stampa la chiamata di procedura
    	li $v0, 4
		la $a0, char_f
		syscall
		move $a3, $s2
		jal print_call
		jal f

		move $s3, $v1		# $s3 contiene la variabile 'u'
		mul $s1, $s1, $s1	# $s1 contiene 'b' al quadrato
		add $s1, $s1, $s3	# $s1 contiene la somma di 'b' al quadrato e 'u' 
		addi $s2, $s2, 1	# Incrementa la variabile 'k'
		blt $s2, $s0, loop	# Se 'k' è minore di 'n' continua a ciclare 
		beq $s2, $s0, loop	# Se 'k' è uguale a 'n' continua a ciclare 
	
	# Stampa la stringa di ritorno della funzione 'g' con parametro 'b'
	move $v1, $s1
	li $v0, 4
	la $a0, char_g
	syscall
	add $a3, $v1, $zero
	addi $a1, $zero, 1
	jal print_return

	# Estrae i valori dallo stack per ripristinare i registri e ritorna al chiamante 
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

# Esce dal programma
exit:
	li $v0, 10
	syscall