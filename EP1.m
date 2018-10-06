tic
%********** Definicao de parametros **********%

% Dimensoes
a = 0.11;
b = 0.05;
c  = 0.04;
d = 0.02;
g  = 0.04;
h = (b - d)/2;
L = 1;
Ldual = 1;
delta = 0.001;

erro = 0.0001; % APAGAR
dif = 0.0001;  % APAGAR

% Constantes
e0 = 8.85419E-12;
e = 1.9*e0;
eDual = e0;
sigma = 3.2E-3;
sigmaDual = 3E-3;

% Matrizes
m = b/delta + 1;  % Linhas totais na matriz  
n = a/delta + 1;  % Colunas totais na matriz
% Limites do retangulo menor
L1 = (b - d - h)/delta + 1; 
L2 = (b - h)/delta + 1;
C1 = g/delta + 1;
C2 = (g + c)/delta + 1;

% Inicializacoes
M = zeros(m, n);
D = zeros(m, n); % Matriz para o problema dual
roMin = 0;
soma = 0;


%********** Calculo da funcao potencial **********%

% Preparacao da matriz com valores iniciais
for i = L1:L2
  for j = C1:C2
    if (i == L1 || i == L2 || j == C1 || j == C2)
      M(i, j) = 100;
    
    else
      M(i, j) = NaN;
    end
  end
end

% Iteracoes 
for num = 1:50000
  
  % Calculo do potencial acima do retangulo
  for i = 2:L1 - 1
    for j = 2:n - 1
      anterior = M(i, j);
      M(i, j) = (M(i - 1, j) + M(i + 1, j) + M(i, j - 1) + M(i, j + 1))/4;
    end
  end
  
  % Calculo do potencial ao lado do retangulo
  for i = L1:L2
    for j1 = 2:C1 - 1
      anterior = M(i, j1);
      M(i, j1) = (M(i - 1, j1) + M(i + 1, j1) + M(i, j1 - 1) + M(i, j1 + 1))/4;
    end
    
    for j2 = C2 + 1:n - 1 
      anterior = M(i, j2);
      M(i, j2) = (M(i - 1, j2) + M(i + 1, j2) + M(i, j2 - 1) + M(i, j2 + 1))/4;
    end
  end
  
  % Calculo do potencial abaixo do retangulo
  for i = L2 + 1: m - 1
    for j = 2:n - 1
      anterior = M(i, j);
      M(i, j) = (M(i - 1, j) + M(i + 1, j) + M(i, j - 1) + M(i, j + 1))/4;
    end
  end

end


%********** Mapa de quadrados curvilineos **********%

% Problema dual - Inicializacoes 
for i = (L1 + L2)/2:L2 - 1
  if i == (L1 + L2)/2
    for j = 1:C1
      D(i, j) = 100;
    end
  end

  for j = C1 + 1:C2 - 1
    D(i, j) = NaN;
  end
end

% Iteracoes em metade do problema
for num = 1:50000
  
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
      if i == m
        if j == 1
          D(i, j) = (2*D(i - 1, j) + 2*D(i, j + 1))/4;
        
        elseif j == n
          D(i, j) = (2*D(i - 1, j) + 2*D(i, j - 1))/4;
        
        else
          D(i, j) = (D(i, j - 1) + 2*D(i - 1, j) + D(i, j + 1))/4;
        end
        
      else
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


%********** Valor minimo da densidade superficial de carga **********%

% Limite superior
i = 1;
for j = 1:n
  ro = -e*(M(i + 1, j) - M(i, j))/delta;
  if ro < roMin
    roMin = ro;
  end
end

% Limite inferior
i = m;
for j = 1:n
  ro = -e*(M(i - 1, j) - M(i, j))/delta;
  if ro < roMin
    roMin = ro;
  end
end

% Limite lateral esquerdo
j = 1;
for i = 1:m
  ro = -e*(M(i, j + 1) - M(i, j))/delta;
  if ro < roMin
    roMin = ro;
  end
end

% Limite lateral direito
j = n;
for i = 1:m
  ro = -e*(M(i, j - 1) - M(i, j))/delta;
  if ro < roMin
    roMin = ro;
  end
end

roMin


%********** Resistencia e Capacitancia **********%

% Calculo da corrente total
% Limite superior
for j = 2:n - 1
  soma += M(2, j);
end

% Limite inferior
for j = 2:n - 1
  soma += M(m - 1, j);
end

% Limite lateral esquerdo
for i = 2:m - 1
  soma += M(i, 2);
end

% Limite lateral direito
for i = 2:m - 1
  soma += M(i, n - 1);
end

I = sigma*L*soma;

R = 100/I

C = e*I/(sigma*100)


%********** Resistencia R' entre as placas **********%
Rdual = 1/(R*sigma*L*sigmaDual*Ldual);
Rlinha = 2*Rdual


%********** Plot do mapa de quadrados curvilineos **********%
np = round(10/(R*sigma*L))
contour(M, 0:10:100)
hold
contour(D, np)

toc