default rel
	
section .text
global GetKernel32Base
GetKernel32Base:
    sub rsp, 0x28             
    mov rax, [gs:0x60]        
    mov rax, [rax + 0x18]   
    mov rax, [rax + 0x20]
    mov rax, [rax]       
    mov rax, [rax]     
    mov rax, [rax + 0x20]
    add rsp, 0x28  
    ret

.not_found:
	xor rax, rax

global FindExport
FindExport:
	push rbp
	mov rbp, rsp ;; set up stack frame
	sub rsp, 0x40

	mov [rbp - 0x08], rcx
	mov [rbp - 0x10], rdx
	
	mov eax, [rcx + 0x3C]
	add rax, rcx

	mov eax, [rax + 0x88]
	test eax, eax
	jz .not_found

	;; btw we use eax and stuff because windows PE is 32-bit


	;; base
	mov rbx, [rbp - 0x08]
	add rax, rbx
	mov [rbp - 0x18], rax

	mov ecx, [rax + 0x18]       ; NumberOfNames
    mov r8d, [rax + 0x20]       ; AddressOfNames RVA
    add r8, rbx                 ; convert
    mov r9d, [rax + 0x24]       ; AddressOfNameOrdinals RVA
    add r9, rbx                 ; convert
    mov r10d, [rax + 0x1C]      ; AddressOfFunctions RVA
    add r10, rbx                ; convert

	xor r11, r11

.search_loop:
	;; counter = r11d
	cmp r11d, ecx
	jge .not_found

	mov edx, [r8 + r11*4]
	add rdx, rbx
	
	mov rsi, rdx           ;; export name
	mov rdi, [rbp - 0x10]  ;; target func name

.compare_loop:
	mov al, [rsi] ;; export
	mov cl, [rdi] ;; target

	cmp al, cl
	jne .next_function

	test al, al ;; null terminator
	jz .found_match

	inc rsi ;; next char
	inc rdi ;; same shit
	jmp .compare_loop

.next_function:
	inc r11  ;; count of checked functions
	jmp .search_loop

.found_match:
	movzx eax, word [r9 + r11*2] ;; ordinal
	mov edx, [r10 + rax*4]      ;; function RVA
	add rdx, rbx                 ;; function address
	mov rax, rdx
	jmp .done

.not_found:
	xor rax, rax

.done:
	mov rsp, rbp
	pop rbp
	ret
