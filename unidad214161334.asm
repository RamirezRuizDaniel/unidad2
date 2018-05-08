SYS_SALIDA equ 1
SYS_LEE equ 3
SYS_PRINT equ 4
STDIN equ 0
STDOUT equ 1

%macro print 2
  mov eax, 4
  mov ebx, 1
  mov ecx, %1; Que se va a imprimir
  mov edx, %2; La longitud de lo que se va a imprimir
  int 0x80
%endmacro

%macro input 2
  mov eax, 3
  mov ebx, 0
  mov ecx, %1; Donde guardar el valor
  mov edx, %2; el tamaño de la localidad de memoria
  int 0x80
%endmacro

segment .data
  msg1 db "La conjetura de Collatz, ingrese un numero y presione enter: ", 0xA,0xD
  len1 equ $- msg1
  
  msg2 db " "
  len2 equ $- msg2
  
  saltoLinea db 0xA,0xD
  lenSalto equ $- saltoLinea

segment .bss
  numx resb 2
  aux resb 2

section  .text
  global _start 
_start:
  print msg1, len1  
  mov edi, 2
  mov ebp, 9; Es el valor que entra por teclado
  mov eax, ebp

  add eax, '0'
  mov [aux], eax
  print aux, 2
  print saltoLinea, lenSalto
  mov eax, ebp

  ciclo:
    cmp eax, 1
    je salir
  no_es_uno:
    mov edx, 0; Para evitar resultados inesperados
    div edi;en eax esta el resultado en edx el residuo
    cmp edx, 0
    jne es_impar
    
    jmp continua

    es_impar:
    mov eax, 3; Es la multiplicacion primero si es impar
    mov ecx, ebp; Se mueve a ecx el valor de 2
    mul ecx; Despues de esto en eax esta la multiplicacion 
    inc eax; El resultado se le suma 1
    
    continua:

    mov ebp, eax

    add eax, '0'
    mov [aux], eax
    print aux, 2
    print msg2, len2
    mov eax, ebp
jmp ciclo    

salir:
  mov eax, SYS_SALIDA
	xor ebx, ebx
	int 0x80