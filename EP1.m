%%% Definicao dos parametros %%%

a = 0.11;
b = 0.05;
c  = 0.04;
d = 0.02;
g  = 0.04;
h = (b - d)/2;
delta = 0.001;
erro = 0.0001 
dif = 0.0001
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
end

% Iteracoes 
while dif >= erro
  
  % Calculo do potencial acima do retangulo
  for i = 2:L1 - 1
    for j = 2:n - 1
      anterior = M(i, j);
      M(i, j) = M(i - 1, j) + M(i + 1, j) + M(i, j - 1) + M(i, j + 1))/4;
      if abs(anterior - M(i, j)) > dif
        dif = abs(anterior - M(i, j));
      end
    end
  end
  
  % Calculo do potencial ao lado do retangulo
  for i = L1:L2
    for j1 = 2:C1 - 1
      anterior = M(i, j1);
      M(i, j1) = M(i - 1, j1) + M(i + 1, j1) + M(i, j1 - 1) + M(i, j1 + 1))/4;
      if abs(anterior - M(i, j1)) > dif
        dif = abs(anterior - M(i, j1));
      end
    end
    
    for j2 = C2 + 1:n - 1 
      anterior = M(i, j2);
      M(i, j2) = M(i - 1, j2) + M(i + 1, j2) + M(i, j2 - 1) + M(i, j2 + 1))/4;
      if abs(anterior - M(i, j2)) > dif
        dif = abs(anterior - M(i, j2));
      end
    end
  end
  
  % Calculo do potencial abaixo do retangulo
  for i = L2 + 1: m - 1
    for j = 2:n - 1
      anterior = M(i, j);
      M(i, j) = M(i - 1, j) + M(i + 1, j) + M(i, j - 1) + M(i, j + 1))/4;
      if abs(anterior - M(i, j)) > dif
        dif = abs(anterior - M(i, j));
      end
    end
  end

end