%%% Definicao dos parametros %%%

a = 0.11;
b = 0.05;
c  = 0.04;
d = 0.02;
g  = 0.04;
h = (b - d)/2;
delta = 0.001;
erro = 0.0001 
dif = 1
m = b/delta + 1;  % Linhas totais na matriz  
n = a/delta + 1;  % Colunas totais na matriz
% Limites do retangulo menor
L1 = (b - d - h)/delta + 1 
L2 = (b - h)/delta + 1
C1 = g/delta + 1
C2 = (g + c)/delta + 1

%%% Calculo da funcao potencial %%%

M = zeros(m, n);

% Preparando a matriz com valores iniciais
for i = L1:L2
  for j = C1:C2
    if (i == L1 || i == L2 || j == C1 || j == C2
      M(i, j) = 100;
    
    else
      M(i, j) = NaN;
  end
end

% Iteracoes 
while dif > erro
  for i = 2:L1
    for j = 2:
      anterior = (M() + M() + M() + M())/4