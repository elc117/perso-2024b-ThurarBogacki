
# TRABALHO_1 PARADIGMAS DE PROGRAMAÇÃO

ARTHUR BOGACKI VERISSIMO

CIÊNCIAS DA COMPUTAÇÃO - UFSM


**Introdução:** O projeto consiste em um jogo web criado utilizando a linguagem de programação Haskell no back-end,  html\css para o front-end e a biblioteca Scotty que facilita a criação de projetos web em Haskell. O jogo consiste em um quadrado de cores RGB aleatório gerado pelo computador com valores entre 0 e 255 para R (RED), G (GREEN), B (BLUE), onde o objetivo do jogador é entrar com os valores RGB tentando se aproximar o máximo possivel dos valores gerados pela máquina, após entrar com os dados, o sistema calcula uma pontuação entre 0 a 100 sendo 0 o valor mais distante possível e 100 o valor exato.

**Processo de Desenvolvimento:** Ao decorrer do desenvolvimento me deparei com alguns problemas de ambiente, passei algumas horas rodeados de bugs ao tentar rodar um servidor Haskell usando Scotty. Após algumas tentativas, consultas na documentalção da biblioteca e perguntas ao Chat GPT, finalmente consegui rodar o servidor. A partir disto, usei as habilidades de escrita em Haskell aprendidas durante o semestre até aqui, para implementar uma lógica de geração de valores aleatórios, aprendi a usar código HTML em união com Haskell, usei rotas POST para obter os dados de entrada dos inputs RGB entregues pelo usuário, bem como para conferir resultados. A pontuação é calculada com base na fórmula da distância euclidiana que mede a diferença entre dois componentes no espaço tridimensional, para o intervalo de (0, 255) temos a seguinte fórmula: maxDistance= sqrt((255)^2 + (255)^2 + (255)^2) ≈ 441.67; A pontuação é calculada usando a fórmula **score = 100 * (1 - (distance / maxDistance))**.

**Para compilar:**
Dentro da pasta do projeto "my-scotty-server" usamos

stack build

stack exec my-scotty-server

Se nosso ambiente local possuir instalada a linguagem Haskell, a biblioteca Scotty e o compilador GHCUP em versões compatíveis, deve ser possível visualizar o projeto pelo navegador acessando:

http://localhost:3000