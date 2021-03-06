function alineaB()

input = zeros(784,1000);
target = zeros(5,1000);

%a
d = dir('C:\Users\P\Desktop\isec\2? ano\cr\TP_CR\Pasta_2\A\*.jpg');
i =1;
j=6;
for n = 1 : size(d)
    
    folder = getfield(d, {i}, 'folder');        % folder ? a pasta
    nome = getfield(d, {i}, 'name');            % vai buscar cada imagem
    img = strcat(folder, '/', nome);            % cria localiza??o final
    arr = imbinarize(imread(img));              % guarda a imagem em forma de array
    arr = arr(:);                               %%transfoirma a imagem de array para um vector de 1 coluna
    input(:, j) = arr;                          % cada coluna ? uma imagem
    target(:, j) = [1, 0, 0, 0, 0];
    i = i + 1;
    j = j + 1 ;
      
end

%e
d = dir('C:\Users\P\Desktop\isec\2? ano\cr\TP_CR\Pasta_2\E\*.jpg');
i =1;
for n = 1 : size(d)
    
    folder = getfield(d, {i}, 'folder');        % folder ? a pasta
    nome = getfield(d, {i}, 'name');            % vai buscar cada imagem
    img = strcat(folder, '/', nome);            % cria localiza??o final
    arr = imbinarize(imread(img));              % guarda a imagem em forma de array
    arr = arr(:);                               %%transfoirma a imagem de array para um vector de 1 coluna
    input(:, j) = arr;                          % cada coluna ? uma imagem
    target(:, j) = [0, 1, 0, 0, 0];
    i = i + 1;
    j = j + 1 ;  
end

%I
d = dir('C:\Users\P\Desktop\isec\2? ano\cr\TP_CR\Pasta_2\I\*.jpg');
i =1;
for n = 1 : size(d)
    
    folder = getfield(d, {i}, 'folder');        % folder ? a pasta
    nome = getfield(d, {i}, 'name');            % vai buscar cada imagem
    img = strcat(folder, '/', nome);            % cria localiza??o final
    arr = imbinarize(imread(img));              % guarda a imagem em forma de array
    arr = arr(:);                               %%transfoirma a imagem de array para um vector de 1 coluna
    input(:, j) = arr;                          % cada coluna ? uma imagem
    target(:, j) = [0, 0, 1, 0, 0];
    i = i + 1;
    j = j + 1 ;
end
%O
d = dir('C:\Users\P\Desktop\isec\2? ano\cr\TP_CR\Pasta_2\O\*.jpg');
i =1;
for n = 1 : size(d)
    
    folder = getfield(d, {i}, 'folder');        % folder ? a pasta
    nome = getfield(d, {i}, 'name');            % vai buscar cada imagem
    img = strcat(folder, '/', nome);            % cria localiza??o final
    arr = imbinarize(imread(img));              % guarda a imagem em forma de array
    arr = arr(:);                               %%transfoirma a imagem de array para um vector de 1 coluna
    input(:, j) = arr;                          % cada coluna ? uma imagem
    target(:, j) = [0, 0, 0, 1, 0];
    i = i + 1;
    j = j + 1 ;
    
end
%U
d = dir('C:\Users\P\Desktop\isec\2? ano\cr\TP_CR\Pasta_2\U\*.jpg');
i =1;
for n = 1 : size(d)
    
    folder = getfield(d, {i}, 'folder');        % folder ? a pasta
    nome = getfield(d, {i}, 'name');            % vai buscar cada imagem
    img = strcat(folder, '/', nome);            % cria localiza??o final
    arr = imbinarize(imread(img));              % guarda a imagem em forma de array
    arr = arr(:);                               %%transfoirma a imagem de array para um vector de 1 coluna
    input(:, j) = arr;                          % cada coluna ? uma imagem
    target(:, j) = [0, 0, 0, 0, 1];
    i = i + 1;
    j = j + 1 ;
      
end

net = feedforwardnet(10);
%net = patternnet(10);
 
% FUNCAO DE ATIVACAO DA CAMADA DE SAIDA
net.layers{1}.transferFcn = 'tansig';
%net.layers{2}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'purelin';


% FUNCAO DE ATIVACAO DA CAMADA DE SAIDA
%net.layers{3}.transferFcn = 'purelin';

% FUNCAO DE TREINO 
%net.trainFcn = 'trainlm';
%net.trainFcn = 'traingd';
net.trainFcn = 'trainlm';
% NUMERO DE EPOCAS DE TREINO
net.trainParam.epochs=100;

net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 0.7;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0.15;
                

% COMPLETAR: treinar a rede
[net,tr] = train(net, input, target);
 view(net);
 disp(tr)
% SIMULAR
 out = sim(net, input);

% %VISUALIZAR DESEMPENHO
 
 plotconfusion(target, out) % Matriz de confusao
 
 plotperf(tr)         % Grafico com o desempenho da rede nos 3 conjuntos           

%Calcula e mostra a percentagem de classificacoes corretas no total dos exemplos
r=0;
for i=1:size(out,2)               % Para cada classificacao  
  [a b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
  [c d] = max(target(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
  if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
      r = r+1;
  end
end

accuracy = r/size(out,2)*100;
fprintf('Precisao total %f\n', accuracy)


% SIMULAR A REDE APENAS NO CONJUNTO DE TESTE
TInput = input(:, tr.testInd);
TTargets = target(:, tr.testInd);

out = sim(net, TInput);

%%para as q nao foram testadas-> apenas faz sentido quando as q foram
%%testadas pertencem ao msm grpo das de treino

%Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
r=0;
for i=1:size(tr.testInd,2)               % Para cada classificacao  
  [a b] = max(out(:,i));          %b guarda a linha onde encontrou valor mais alto da saida obtida
  [c d] = max(TTargets(:,i));  %d guarda a linha onde encontrou valor mais alto da saida desejada
  if b == d                       % se estao na mesma linha, a classificacao foi correta (incrementa 1)
      r = r+1;
  end
end
accuracy = r/size(tr.testInd,2)*100;
fprintf('Precisao teste %f\n', accuracy)

end