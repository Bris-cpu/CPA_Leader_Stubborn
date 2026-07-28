clc
close all

%Este código tiene como base el modelo CPA simple
% Usando como base el CPA simple se incluyó la versión de Liderazgo, este código incluye 3 tipos de líderes
%se incluye generación de red de SW
%Incluye la generación de todas las variables
%Incluye la opción usar el código CPA simple al desactivar la opción de
%lideres
%Incluye la modificación de variables 
%Incluye posibilidad de modificación de barrido de U y p o simplemente
%generar una simulación 
%Incluye la extracción de los datos usando promedios para varias
%simulaciones o la extracción para una única simulación
%No se incluye el código para visualizar datos




N = 1001; % numero de agentes (incluye a un lider)
gen = 2000; % numero de generaciones
Ngrafo=1000; % Tamaño del grafo sin el líder (indica las aristas unicamente del SW)
%% Tipo de red que se usará
red=1; %red= 1 (Sw), red = 2 (SF)   
beta=0.25; %Para la red SW
enlaces=10; %enlaces por nodo

PerAlcance=0.2; % 20% de 100% de N
Alcance=N*PerAlcance;

%% Tipo de lider que se tendrá
ActivaLider=1; %Lider Activo 1 (con líder), Lider inactivo 0  (sin lider, versión simple)
lider=1; %lider = 1 (Dictador), lider = 2 (democrata), lider = 3 (populista)
Mod=10; %momento de tiempo para que el lider pueda ser pasivo
uL0=0.5; %Tolerancia del Lider
xL0=0.2; %Opinión inicial del líder
TipoLider=1; %Antagonista parcial 1

%% Variables extra a modificar
mu = 1/2; % factor en opinion
mu1 = 1/20; % factor en incertidumbre
%
NumSim=30; %Promedio de simulaciones
% p=0.75;
% ValorU=0.55;

% ExtensionU = 0.2:0.01:1.0;   %PARA BARRIDO
ExtensionU = 0.7;        %PARA CORRIDA INDIVIDUAL

ExtensionX = -1:0.1:1;


Nuevodl = int32 (PerAlcance*10); %útil para nombrar archivos de salida
Nuevoxl = int32 (xL0*10); %útil para nombrar archivos de salida


for sociedad=1:2 %Más de un valor es para multiples p en varias simulaciones continuas
PdeSociedad=[0.3,0.7];
p=PdeSociedad(sociedad);  %probabilidad de que aparezcan agentes Concord



for ValorU= ExtensionU
%VariablesTolerancias
   NuevoU = int32(ValorU*10);




[TipoNodo]=TipoDeSociedad(N,p,TipoLider); %se crea en cada simulación el tipo de nodo
% load('p005TipoNodo.mat'); %se cargan valores ya predeterminados del tipo
% psicologico

nuevop=int32(p*10); %util para nombrar archivos de salida
%%
for k = 1 : NumSim %Ciclo principal


[grafo,GrafoComunes] = WattsStrogatzs_HJ(Ngrafo,N, beta, enlaces,Alcance,PerAlcance); %Se crea una red por cada Simulación
% load ('Grafocomunesediesca.mat');
% load ('Grafoediesca.mat'); %Se carga una red guardada para todos los
% experimentos

WS = length(GrafoComunes); %aristas originales del WS sin el lider

Uprom = ValorU;  % valor central de las tolerancias
ValExt=0.2; %cota de valor extremo para las opiniones
[ui0] = ValoresU(Uprom,ValExt,uL0,N); %generación aleatoria de tolerancias

 a=-1;
 b=1;
 [xi0] = ValoresX(a,b,xL0,N); %generación aleatoria de opiniones



[a,b] = size(grafo);
%
num_aristas = size(grafo,2);
cabezass = grafo(1,:);
colass = grafo(2,:);
aristas_etiqueta = 1:num_aristas;



Evol_opi = zeros(gen+1,N);
Evol_inc = zeros(gen+1,N);
% t=0, de los datos iniciales
opi_ini = xi0;    
inc_inicial = ui0;
%
Evol_opi(1,:) = opi_ini; %Vector opiniones
Evol_inc(1,:) = inc_inicial; %Vector tolerancias

if lider==3 %Opción para populismo
    Acoplados(1,:)=zeros(1,N);
    xl=zeros(gen,1);
    xl(1)=Evol_opi(1,1001);
    ul=zeros(gen,1);
    ul(1)=Evol_inc(1,1001);
    PromedioXAcoplados=zeros(gen,1);
    PromedioXAcoplados(1)=xl(1);
    PromedioUAcoplados=zeros(gen,1);
    PromedioUAcoplados(1)=ul(1);
end

CondicionesX(k,:) = xi0;
CondicionesU(k,:)= ui0;
%
% 
% inicia la actualizacion de la opinion  e incertidumbre
%
for tiempo = 2:gen+1
    % seleccion aleatoria de las aristas: revolviendo
    sel = randi(num_aristas, 1, num_aristas);
    % SW:
    seleccion = sel(1:N); % N=1000 aristas seleccionadas para SW
    % Evaluando sobre cada arista
    for indice = 1:N
        arista = seleccion(indice);
        %
        % Definiendo quien es i-activo, j-pasivo  
if ActivaLider==1 %Esto pasa si hay algún lider
            if lider == 1 %si hay dictador
                [nodoi,nodoj] = Dictador(arista,cabezass,colass,WS);
            elseif lider == 2 %si hay democrata
                %[nodoi,nodoj] = Democrata(arista,cabezass,colass,WS);
                if arista > WS
                    if mod (tiempo,Mod) == 0
                        if rand(1,1) < 0.95
                            nodoi=cabezass(arista); % lider activo
                            nodoj=colass(arista);   % agente pasivo
                        else
                            nodoi=colass(arista);   % lider pasivo
                            nodoj=cabezass(arista); % agente retroalimentando lider
                        end
                    else
                        nodoi=cabezass(arista);
                        nodoj=colass(arista);
                    end
                elseif rand(1,1) > 0.5
                    nodoi = cabezass(arista); % activo
                    nodoj = colass(arista);   % pasivo
                else
                    nodoi = colass(arista);  % activo
                    nodoj = cabezass(arista); % pasivo
                end
            elseif lider == 3 %si hay populista
                [nodoi,nodoj] = Populista(arista,cabezass,colass,WS);
                if arista > WS
                    Acoplados(tiempo,nodoj)=1;
                else
                    Acoplados(tiempo,nodoj)=0;
                end
            end
elseif ActivaLider==0 %Si es C/PA simple
            if rand(1,1) > 0.5
                nodoi = cabezass(arista); % activo
                nodoj = colass(arista);   % pasivo
            else
                nodoi = colass(arista);  % activo
                nodoj = cabezass(arista); % pasivo
            end
        end
        %
        %
        % Traslape de opinion
       
        hij = min(Evol_opi(tiempo - 1,nodoi) + Evol_inc(tiempo - 1,nodoi), Evol_opi(tiempo - 1,nodoj) + Evol_inc(tiempo - 1, nodoj) ) - max(Evol_opi(tiempo - 1,nodoi) - Evol_inc(tiempo - 1, nodoi), Evol_opi(tiempo - 1,nodoj) - Evol_inc(tiempo - 1, nodoj) );
        %
        % C-acuerdo
        Cacuerdo = hij / Evol_inc(tiempo - 1,nodoi); %  inc_inicial(nodoi)
        % AP-acuerdo
        APacuerdo = 0.5 * Cacuerdo * (Cacuerdo - 1);
        %
        % inicio de actualizacion de ecuaciones
        %
        if hij > 0
            % Selecciona el "modelo" segun el perfil psicologico del agente
            %
            if TipoNodo(nodoj) == 1, % concordia
                opi_ini(nodoj) = Evol_opi(tiempo - 1,nodoj) + mu * Cacuerdo * (Evol_opi(tiempo - 1,nodoi) - Evol_opi(tiempo - 1,nodoj)) ;
                inc_inicial(nodoj) = Evol_inc(tiempo - 1, nodoj) + mu1 * Cacuerdo  * (Evol_inc(tiempo - 1, nodoi) - Evol_inc(tiempo - 1, nodoj));
                %
            else %  antagonismo
                opi_ini(nodoj) = Evol_opi(tiempo - 1,nodoj) + mu * APacuerdo * (Evol_opi(tiempo - 1,nodoi) - Evol_opi(tiempo - 1,nodoj)) ;
                inc_inicial(nodoj) = Evol_inc(tiempo - 1, nodoj) + mu1 * APacuerdo * (Evol_inc(tiempo - 1, nodoi) - Evol_inc(tiempo - 1, nodoj));
             end;
        end
         %
         % Hacemos correcciones en la opinion
         if opi_ini(nodoj) >=1,
             opi_ini(nodoj) = 1; % 1
         elseif opi_ini(nodoj) <= -1,
             opi_ini(nodoj) = -1; %-1
         end;
         %
         %Hacemos correcciones de incertidumbre en intervalo mayor
         if inc_inicial(nodoj) >= 1,  % U+0.15...no sale bien :(
             inc_inicial(nodoj) =  1; % U+0.15
         elseif inc_inicial(nodoj) <= 0.05, %  U-0.15
             inc_inicial(nodoj) = 0.05; % U-0.15
         end;
         %
         % fin de las actualizaciones de m=1
         %
    end % fin de "indice" es decir de evaluacion de aristas
    %
    %
    Evol_opi(tiempo,:) = opi_ini;
    OpiLider(tiempo,1) = Evol_opi(tiempo,1001);
    Evol_inc(tiempo,:) = inc_inicial;
     IncLider(tiempo,1) = Evol_inc(tiempo,1001);

    if ActivaLider==1;
        if lider == 3; %Función de Populista (Aún en pruebas)

            XAcoplados = find(Acoplados(tiempo,:)>0);
            PromedioXAcoplados(tiempo,1)= sum(Evol_opi(tiempo,XAcoplados))/length(XAcoplados);
            PromedioUAcoplados(tiempo,1)= sum(Evol_inc(tiempo,XAcoplados))/length(XAcoplados);
            xl(tiempo,1) = PromedioXAcoplados(tiempo-1,1);

            Evol_opi(tiempo,1001) = xl(tiempo,1);

            if mod(tiempo,5)==0
                ul(tiempo,1) = PromedioUAcoplados(tiempo-1,1);  
            else
                ul(tiempo,1) = ul(tiempo-1,1);
            end
            Evol_inc(tiempo,1001) = ul(tiempo,1);
        else

        end
    end
    %
end; % fin de generaciones
%
% guardando los datos de la evolucion de opinion e incertidumbre en t=final
opi_final = Evol_opi(gen+1,:);
opi_finalLider = OpiLider(gen+1,1);
inc_final = Evol_inc(gen+1,:);
inc_finalLider = IncLider(gen+1,1);



VectorOpiFinal(k,:) = opi_final; %Vector final de opiniones con bins
 ed=linspace(-1,1,22);
 edges = ed;
 ConteoX(k,:)=histcounts(VectorOpiFinal(k,:),edges);

 VectorOpiFinalLider(k,:) = opi_finalLider; %Vector final opinion de lider
 ed=linspace(-1,1,22);
 edges = ed;
 ConteoXLider(k,:)=histcounts(VectorOpiFinalLider(k,:),edges);

VectorTolFinal(k,:) = inc_final;
 edu=linspace(0,1,22);
 edgesU=edu;
 ConteoU(k,:)=histcounts(VectorTolFinal(k,:),edgesU);

 VectorTolFinalLider(k,:) = inc_finalLider;
 edu=linspace(0,1,22);
 edgesU=edu;
 ConteoULider(k,:)=histcounts(VectorTolFinalLider(k,:),edgesU);



ValoresDeU = [0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]; 
ValoresDeK = [1,2,3,4,5] ;
%% Esta sección es para guardar simulaciones individuales, principalmente uso para feedback
% if  any( ValoresDeU == ValorU) && any( ValoresDeK == k)
%    output_name = ['DEMONuevaOpiPruebaInd' num2str(k) 'conU' num2str(NuevoU) 'yMod' num2str(Mod) 'dl' num2str(Nuevodl) 'conp' num2str(nuevop) '.mat']
%    save (output_name, 'Evol_opi')
%    output_name = ['DEMONuevaIncPruebaInd' num2str(k) 'conU' num2str(NuevoU) 'yMod' num2str(Mod) 'dl' num2str(Nuevodl) 'conp' num2str(nuevop) '.mat']
%    save (output_name, 'Evol_inc')
% end

end


%% Esta sección se usa para guardar los promedios de 30 simulaciones, principalmente para datos de Dictator and Democrat Stubborn
 PromedioSimulacionesX = sum(ConteoX)/NumSim;

 PromedioSimulacionesU = sum(ConteoU)/NumSim;

  PromedioSimulacionesXLider = sum(ConteoXLider)/NumSim;

 PromedioSimulacionesULider = sum(ConteoULider)/NumSim;


 corrida= int32(ValorU*100-19);
 BifurcacionesX(corrida,:)=PromedioSimulacionesX;
 BifurcacionesU(corrida,:)=PromedioSimulacionesU;

  BifurcacionesXLider(corrida,:)=PromedioSimulacionesXLider;
 BifurcacionesULider(corrida,:)=PromedioSimulacionesULider;
 end


nuevop=int32(p*10);
%% Está sección guarda corridas de 30 sim para dictador y democrata stubborn
   output_name = ['SMBifurcacionesDemoXdl' num2str(Nuevodl) 'L' num2str(lider) 'xl' num2str(Nuevoxl) 'p' num2str(nuevop) '.mat'];
   save (output_name,'BifurcacionesX')
       output_name = ['SMBifurcacionesDemoUdl' num2str(Nuevodl) 'L' num2str(lider) 'xl' num2str(Nuevoxl) 'p' num2str(nuevop) '.mat'];
   save (output_name,'BifurcacionesU')

      output_name = ['SMBifurcacionesDemoX5Liderdl' num2str(Nuevodl) 'L' num2str(lider) 'xl' num2str(Nuevoxl) 'p' num2str(nuevop) '.mat'];
   save (output_name,'BifurcacionesXLider')
       output_name = ['SMBifurcacionesDemoU5Liderdl' num2str(Nuevodl) 'L' num2str(lider) 'xl' num2str(Nuevoxl) 'p' num2str(nuevop) '.mat'];
   save (output_name,'BifurcacionesULider')
%% Esta sección guarda corridas de 30 sim para democrata feedback
   %    output_name = ['SMBifurcacionesDemoX5dl' num2str(Nuevodl) 'L' num2str(lider) 'Mod' num2str(Mod) 'xl' num2str(Nuevoxl) 'p' num2str(nuevop) '.mat'];
   % save (output_name,'BifurcacionesX')
   %     output_name = ['SMBifurcacionesDemoU5dl' num2str(Nuevodl) 'L' num2str(lider) 'Mod' num2str(Mod) 'xl' num2str(Nuevoxl) 'p' num2str(nuevop) '.mat'];
   % save (output_name,'BifurcacionesU')
   % 
   %    output_name = ['SMBifurcacionesDemoX5Liderdl' num2str(Nuevodl) 'L' num2str(lider) 'Mod' num2str(Mod) 'xl' num2str(Nuevoxl) 'p' num2str(nuevop) '.mat'];
   % save (output_name,'BifurcacionesXLider')
   %     output_name = ['SMBifurcacionesDemoU5Liderdl' num2str(Nuevodl) 'L' num2str(lider) 'Mod' num2str(Mod) 'xl' num2str(Nuevoxl) 'p' num2str(nuevop) '.mat'];
   % save (output_name,'BifurcacionesULider')

   p %aviso para saber en que p se encuentra el programa

end




%% Esta sección contiene todas las funciones llamadas para el código


%Vector aleatorio de tolerancias
function [ui0] = ValoresU(Uprom, ValExt,uL0,N)
c= Uprom - ValExt; 
d = Uprom + ValExt;
r1 = (d-c).*rand(N-1,1) + c;  %Para U colocamos numeros aleatorios con las cotas alrededor del valor central de
% las opiniones
ui = r1; %vector de tamaño N de numeros aleatorios
ui0 = vertcat(ui,uL0);
save('inc_ini.mat','ui0')
end
%Tipos psicológicos aleatorios
function [TipoNodo]= TipoDeSociedad(N,p,TipoLider)
%vectores aleatorios para el tipo de agente
for i=1:N-1;
    ran(i) = rand();
  if ran(i) < p;
      TipodeNodo(i) = 1; %  valor de agente concord
  else
      TipodeNodo(i) = 0;  % valor de agente PA
  end
end
TipoNodo = horzcat(TipodeNodo,TipoLider);
save('p070TipoNod.mat','TipoNodo')
end
%Funcionamiento del dictador
function [nodoi,nodoj] = Dictador(arista,cabezass,colass,WS)

        if arista > WS;
           nodoi=cabezass(arista);
           nodoj=colass(arista);
        elseif rand(1,1) > 0.5,
            nodoi = cabezass(arista); % activo
            nodoj = colass(arista);   % pasivo
        else
            nodoi = colass(arista);  % activo
            nodoj = cabezass(arista); % pasivo
        end;

end
%Funcionamiento del demócrata (desglosado arriba por optimización)
function [nodoi,nodoj] = Democrata(arista,cabezass,colass,WS)

        if arista > WS;
            if rand(1,1) < 0.95
                nodoi=cabezass(arista); % lider activo
                nodoj=colass(arista);   % agente pasivo
            else
                nodoi=colass(arista);   % lider pasivo
                nodoj=cabezass(arista); % agente retroalimentando lider
            end
        elseif rand(1,1) > 0.5,
            nodoi = cabezass(arista); % activo
            nodoj = colass(arista);   % pasivo
        else
            nodoi = colass(arista);  % activo
            nodoj = cabezass(arista); % pasivo
        end;

end
%Funcionamiento del populista
function [nodoi,nodoj] = Populista(arista,cabezass,colass,WS)

        if arista > WS;
           nodoi=cabezass(arista);
           nodoj=colass(arista);
        elseif rand(1,1) > 0.5,
            nodoi = cabezass(arista); % activo
            nodoj = colass(arista);   % pasivo
        else
            nodoi = colass(arista);  % activo
            nodoj = cabezass(arista); % pasivo
        end;

end
%Vector aleatorio de opiniones
function [xi0] = ValoresX(a,b,xL0,N)
r = (b-a).*rand(N-1,1) + a;  % para x colocamos numeros aleatorios con cotas en a y b
xi = r;  %vector de tamaño N de numeros aleatorios
xi0 = vertcat(xi,xL0);
save('opi_ini.mat','xi0')
end
%Nodos acoplados del populista para funcionamiento
function [PromedioXAcoplados,PromedioUAcoplados,xl,Evol_opi] = PromedioXpopulista(Acoplados,Evol_opi,Evol_inc,tiempo,xl,PromedioXAcoplados,PromedioUAcoplados)
XAcoplados = find(Acoplados(tiempo,:)>0);
PromedioXAcoplados(tiempo,1)= sum(Evol_opi(tiempo,XAcoplados))/length(XAcoplados);
PromedioUAcoplados= sum(Evol_inc(tiempo,XAcoplados))/length(XAcoplados);
xl(tiempo,1) = PromedioXAcoplados(tiempo-1,1);
Evol_opi(tiempo,1001) = xl(tiempo,1);
end
%Generación de red si es necesaria.
function [grafo,GrafoComunes] = WattsStrogatzs_HJ(Ngrafo,N, beta, enlaces,Alcance,PerAlcance)

rng('shuffle'); %siembra el generador de números aleatorios basado en la hora actual.

Adja = zeros(Ngrafo, Ngrafo);
for i = 1:Ngrafo
    for jota = i+1:i+enlaces,
        j = mod(jota, Ngrafo); % mod(a,b)=a-b*floor(a/b)
        if j ~= 0, 
            Adja(i,j) = 1;
            Adja(j,i) = 1;
        else
            j = Ngrafo;
            Adja(i,j) = 1;
            Adja(j,i) = 1;
        end
    end
end
%
% Haciendo la matriz Adja triangular superior... y asi evitar los aristas
% repetidas
for i=1:Ngrafo,
    for j=1:i,
        Adja(i,j)=0;
    end
end
%
% Conviertiendo matriz dispersa : 
%MATLAB almacena matrices dispersas en formato de columna dispersa comprimida.
%las matrices dispersas almacenan solo los elementos distintos de cero y sus índices de fila
g = sparse(Adja);
[nodosi,nodosj,mv] = find(g);
cabezas = nodosi';
colas = nodosj';   
% 
% ARISTAS A CAMBIAR
% numero total de aristas:
total_aristas = size(cabezas,2);
% numero de aristas a cambiar:
limite = floor(beta*total_aristas);
% permutacion de la lista de aristas:
permutacion = randperm(total_aristas);
% aristas a cambiar:
porcambiar = permutacion(1:limite); 
%
% g_inicial = [cabezas; colas]; 
% Cambiando las aristas
for i = 1:limite
    % Solo se cambiara la cola de la arista para esto se selecciona un nuevo nodo
    temp = randi([1 Ngrafo], 1);
    %
    % Se conecta el nodo actual y el nuevo nodo solo si el nuevo nodo es 
    % diferente de la cabeza y no esta conectado al nodo actual
    if ((temp ~= cabezas(porcambiar(i))) & (Adja(cabezas(porcambiar(i)), temp) == 0)),
      colas(porcambiar(i)) = temp;
      Adja(cabezas(porcambiar(i)), temp) = 1;
      Adja(temp, cabezas(porcambiar(i))) = 1;
    end
end
%
GrafoComunes= [cabezas; colas]; % si resultan diferentes

LiderMatrix= zeros(N:N);
    while sum(LiderMatrix(1,:)) < Alcance;  %Hasta que el lider cumpla con este numero de enlaces los genera de manera aleatoria
        for i=1:N
                if rand()< PerAlcance
                    LiderMatrix(1,i) = 1;
                    LiderMatrix(i,1) = 1;
                else
                    LiderMatrix(i,1) = 0;
                    LiderMatrix(1,i) = 0;
                end
        LiderMatrix(1,1) = 0;
        end
    end

    for i=1:N,
        for j=1:i,
        LiderMatrix(i,j)=0;
        end
    end
%%
    gs = sparse(LiderMatrix);
    [nodosi,nodosj,nv] = find(gs);
    cabezass = nodosi';
    colass = nodosj';   
    grafolider = [cabezass; colass]; % aristas del grafo del lider
    for i= 1:length(grafolider)
        for j=1:2
            if grafolider(j,i) == 1;
                grafolider(j,i)= N; %N+1, primer miembro extra de la sociedad
            end
        end
    end

    % tamaño del grafo
%[a,b] = size(grafolider);
%
num_aristaslider = size(grafolider,2);
cabezaslider = grafolider(1,:);
colaslider = grafolider(2,:);
aristas_etiqueta = 1:num_aristaslider;

grafo=horzcat(GrafoComunes,grafolider);

end
