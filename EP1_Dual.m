%%% Definicao dos parametros %%%

a = 0.11;
b = 0.05;
c  = 0.04;
d = 0.02;
g  = 0.04;
h = (b - d)/2;
delta = 0.001;
m = b/delta + 1;  % Linhas totais na matriz  
n = a/delta + 1;  % Colunas totais na matriz
% Limites do retangulo menor
L1 = (b - d - h)/delta + 1; 
L2 = (b - h)/delta + 1;
C1 = g/delta + 1;
C2 = (g + c)/delta + 1;
% Definicoes iniciais para o problema dual
D = zeros(m, n);


%%% Mapa de quadrados curvilineos %%%

% Problema dual - Inicializacoes 
for i = (L1 + L2)/2:L2 - 1
  if i == (L1 + L2)/2
    for j = 1:C1
      D(i, j) = 100;
    end
    
    for j = C2:n % N necessario
      D(i, j) = 0;
    end
  end
  
  for j = C1 + 1:C2 - 1
    D(i, j) = NaN;
  end
end

% Iteracoes em metade do problema
for num = 1:1
  
  % Calculo do potencial ao lado do retangulo
  for i = (L1 + L2)/2 + 1:L2 - 1
    for j = 1:C1
      if j == 1
        D(i, j) = (D(i - 1, j) + 2*D(i, j + 1) + D(i + 1, j))/4;
      
      elseif j == C1
        D(i, j) = (D(i - 1, j) + 2*D(i, j - 1) + D(i + 1, j))/4;
      
      else
        D(i, j) = (D(i - 1, j) + D(i, j - 1) + D(i + 1, j) + D(i, j + 1))/4;
      end
    end
    
    for j = C2:n
      if j == C2
        D(i, j) = (D(i - 1, j) + 2*D(i, j + 1) + D(i + 1, j))/4;
      
      elseif j == n
        D(i, j) = (D(i - 1, j) + 2*D(i, j - 1) + D(i + 1, j))/4;
      
      else
        D(i, j) = (D(i - 1, j) + D(i, j - 1) + D(i + 1, j) + D(i, j + 1))/4;
      end
    end
  end
    
  % Calculo do potencial abaixo do retangulo
  for i = L2:m
    for j = 1:n
      if i ~= m
        if j == 1
          D(i, j) = (D(i - 1, j) + 2*D(i, j + 1) + D(i + 1, j))/4;
        
        elseif j == n
          D(i, j) = (D(i - 1, j) + 2*D(i, j - 1) + D(i + 1, j))/4;
        
        else
          if isnan(D(i - 1, j))
            D(i, j) = (D(i, j - 1) + 2*D(i + 1, j) + D(i, j + 1))/4;
          else
            D(i, j) = (D(i - 1, j) + D(i, j - 1) + D(i + 1, j) + D(i, j + 1))/4;
          end
        end
    
      else
        if j == 1
          D(i, j) = (2*D(i - 1, j) + 2*D(i, j + 1))/4;
          
        elseif j == n
          D(i, j) = (2*D(i - 1, j) + 2*D(i, j - 1))/4;
          
        else
          D(i, j) = (D(i, j - 1) + 2*D(i - 1, j) + D(i, j + 1))/4;
        end  
      end
    end
  end       
end

% Espelhamento do conteudo da matriz D para a metade superior
for i = 1:(L1 + L2)/2 - 1
  for j = 1:n
    D(i, j) = D(m - i + 1, j);
  end
end

% Plot do mapa
contour(D)
