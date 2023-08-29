extends Control

# Dicionário de palavras com a dica para a forca
var palavras = {
	"Endereço IP": "É atribuído a cada dispositivo como se fosse um CPF para redes.",
	"Roteador": "Encaminha dados entre redes diferentes.",
	"Gateway": "Atua como ponto de entrada e saída entre duas redes distintas.",
	"Firewall": "Controla o tráfego de entrada e saída em uma rede.",
	"Protocolo": "São regras e  formatos que controlam a comunicação entre dispositivos numa rede.",
	"Bandwidth": "Quantidade máxima de dados que podem ser transmitidos.",
	"Latência": "Tempo de atraso entre envio e recebimento.",
	"Pacote": "Unidade básica de dados transmitida numa rede.",
	"Ping": "Serve para verificar a conectividade e medir o tempo de resposta.",
	"Proxy": "Servidor que atua como intermediário entre os dispositivos de rede e a internet.",
	"Switch": "Conecta vários dispositivos e encaminha dados apenas para o destinatário correto.",
	"Sub-Rede": "Uma divisão lógica de uma rede IP maior em redes menores.",
	"Local Area Network": "Rede de computadores que abrange uma área limitada"
}
var termos = palavras.keys() # Lista/Array só com as palavras
var dicas = palavras.values() # Lista/Array só com as dicas

var palavra_escolhida: String # Palavra que será selecionada dos termos
var dica: String
var palavra_validar: String # Palavra que iremos validar as letras (É a palavra_escolhida, mas sem acentos)
var palavra_secreta: String # Palavra que será revelada aos poucos
var secret_word = [] # Array de letras da palavra secreta para poder separar os underlines
var letras_usadas = [] # Array de letras que já foram usadas
var erros = 0 # A variável erros serve para indicar a qntd de erros :O
var terminou = false
var pontos = 0

# Instancia os nódulos importantes
@onready var letra_input = $LineEdit
@onready var palavra_display = $Palavra
@onready var letras_usadas_display = $LetrasUsadas
@onready var dica_display = $Dica
@onready var figura = $FiguraPalito
@onready var figura_corpo = [figura.head, figura.eye_left, figura.eye_right, figura.body, figura.arm_left, figura.arm_right, figura.leg_left, figura.leg_right]
@onready var mudar_palavra_timer = $MudarPalavra
@onready var tempo_progresso = $Tempo
@export var tempo_velocidade: float = 0.025
var tempo_comecar = true

# Sinais que o jogo irá emitir para outras cenas
signal derrota()
signal vitoria()

# Escolhe uma palavra aleatória e estabelece uma condição de vitória
func _ready():
	randomize()
	terminou = false
	tempo_comecar = true
	var indice_aleatorio
	if not termos.is_empty():
		indice_aleatorio = randi() % termos.size()
		palavra_escolhida = termos[indice_aleatorio]
		dica = dicas[indice_aleatorio]
	else:
		vitoria.emit()
		return
	
	for letra in palavra_escolhida:
		palavra_validar = palavra_validar + unidecode(letra.to_upper())
		match letra:
			" ", "-":
				secret_word.append(letra)
				palavra_secreta = palavra_secreta + letra#"*"
			_:
				secret_word.append("_")
				palavra_secreta = palavra_secreta + "*"
	palavra_display.text = "[center][shake]" + " ".join(secret_word) # palavra_secreta

# Controla o display das palavras e da figura dos palitos e estabelece a condição de derrota
func _process(delta):
	# Mostra a figura de palitos conforme a qntd de acertos
	if erros > 0:
		figura_corpo[(erros-1) % figura_corpo.size()].visible = true
	
	# Uma maneira de diminuir o tempo sem usar if/else
	tempo_progresso.value -= tempo_velocidade * int(tempo_comecar)
	
	# Condição de derrota
	if erros > figura_corpo.size():
		derrota.emit()
	if tempo_progresso.value <= 0:
		tempo_comecar = false
		derrota.emit()
	
	# Display dos textos
	letras_usadas_display.text = "LETRAS USADAS:\n" + "-".join(letras_usadas)
	dica_display.text = "Dica:\n" + dica
	
	# Reseta a palavra
	if palavra_secreta.count("*") <= 0:
		if not terminou:
			terminou = true
			tempo_comecar = false
			$Acerto.play()
			$MudarPalavra.start()

# Valida a letra inserida
func validar_letra(letra: String):
	letra = letra[0].to_upper() # Tome somente o primeiro dígito da letra
	palavra_validar = palavra_validar.to_upper()
	
	# Se a letra já foi usada, avise ao jogador e nem execute o resto do script
	if letra in letras_usadas:
		$Erro.play()
		return
	
	# Se a letra existe, mostramos ela na tela e caso contrário, incrementamos a variável "erros"
	if palavra_validar.count(letra) > 0:
		for i in range(palavra_validar.length()):
			if palavra_validar[i] == letra:
				palavra_secreta[i] = palavra_escolhida[i]
				secret_word[i] = palavra_escolhida[i]
		# print(palavra_secreta)
		palavra_display.text = "[center][shake]" + " ".join(secret_word)# palavra_secreta
		letra_input.clear()
		letras_usadas.append(letra)
	else:
		# print("Errou")
		$Erro.play()
		erros += 1
		letras_usadas.append(letra)
		letra_input.clear()

# Troca a palavra e remove a palavra antiga que você acertou da lista
func resetar_palavra():
	if not termos.is_empty():
		pontos += 1
		palavra_secreta = ""
		secret_word = []
		palavra_validar = ""
		letras_usadas = []
		tempo_progresso.value = 100
		termos.erase(palavra_escolhida)
		dicas.erase(dica)
		_ready()
	else:
		return

# Transforma letras com acento ou cedilha em letras normais
func unidecode(character):
	match character:
		"Ã",  "Á", "Â":
			return "A"
		"É", "Ê":
			return "E"
		"Õ", "Ô", "Ó":
			return "O"
		"Ç":
			return "C"
		_:
			return character

# Sinal recebido de quando o usuário aperta 'enter' ao digitar algo
func _on_line_edit_text_submitted(guess):
	guess = unidecode(guess) # Só para aceitar inputs com acento ou cedilha
	if guess.length() > 0:
		validar_letra(guess)

# Sinal recebido do timer de mudar a palavra
# só para a palavra não mudar de forma bruta/instantânea
func _on_mudar_palavra_timeout():
	resetar_palavra()
