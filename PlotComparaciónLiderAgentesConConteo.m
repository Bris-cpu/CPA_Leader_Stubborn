

%% Caso bifurcaciones
% clc
% close all
% clear all
% 
% red=1;
% 
% 
% t=; %tiempo de simulación de cualquier experimento
% CorridasTotales=81; %numero de .01 que se encuentran en el intervalo de U
% %if red==1
%  %   load('SMBifurcacionesUp10.mat')
% %    load('SMBifurcacionesXp10.mat')
% %else
%  %   load('SFBifurcacionesUp10.mat')
%   %  load('SFBifurcacionesXp10.mat')
% %end
% 
% 
%     load('SMBifurcacionesUv7p6.mat')
%     load('SMBifurcacionesXv7p6.mat')
% 
% 
% 
% h=figure
% subplot(1,2,1)
% for i=1:CorridasTotales
% [N,edges] = histcounts(BifurcacionesU(i,:),'BinEdges',linspace(0, 1, 22));
% nHistogramaplotea(i,:) = N;
% %Histogramaplotea=transpose(nHistogramaplotea);
% end
% imagesc([0:0.1:1],[0.2:0.01:1.0],nHistogramaplotea)
% colormap('jet')
% colorbar
% axis xy
% % title('Bifurcaciones Tolerancias con p = 0.3, dl=0.5')
% % xlabel('Tolerancia')
% % ylabel('Uprom')
% 
% subplot(1,2,2)
% for i=1:CorridasTotales
% [N,edges] = histcounts(BifurcacionesX(i,:),'BinEdges',linspace(-1, 1, 22));
% nHistogramaplotea(i,:) = N;
% %Histogramaplotea=transpose(nHistogramaplotea);
% end
% imagesc([-1:0.1:1],[0.2:0.01:1.0],nHistogramaplotea)
% colorbar
% axis xy
% % title('Bifurcaciones Opiniones con p = 0.3, dl=0.5')
% % xlabel('Opiniones')
% % ylabel('Uprom')
% 
%  figure
%  for i=1:CorridasTotales
% [N,edges] = histcounts(BifurcacionesX(i,:),'BinEdges',linspace(-1, 1, 22));
% nHistogramaplotea(i,:) = N;
% %Histogramaplotea=transpose(nHistogramaplotea);
% end
%     surf([-1:0.1:1],[0.2:0.01:1.0],nHistogramaplotea)
%     colorbar
% axis xy
%% Corrida promedio 
clc
close all
clear all

t=2000; %tiempo de simulación de cualquier experimento
CorridasTotales=81; %numero de .01 que se encuentran en el intervalo de U
%if red==1
 %   load('SMBifurcacionesUv10p10.mat')
%    load('SMBifurcacionesXv10p10.mat')
%else
 %   load('SFBifurcacionesUp10.mat')
  %  load('SFBifurcacionesXp10.mat')
%end

    % 
    load('SMBifurcacionesXdl2L1xl2p3.mat')
    load('SMBifurcacionesUdl2L1xl2p3.mat')



% h=figure
% subplot(1,2,1)
% imagesc([0:0.1:1],[0.2:0.01:1.0],BifurcacionesU)
% colormap('jet')
% colorbar
% axis xy
%  title('Bifurcaciones Tolerancias')
%  xlabel('Tolerancia')
%  ylabel('Uprom')
% 
% subplot(1,2,2)
% imagesc([-1:0.1:1],[0.2:0.01:1.0],BifurcacionesX)
% colorbar
% axis xy
%  title('Bifurcaciones Opiniones')
%  xlabel('Opiniones')
%  ylabel('Uprom')

 figure
    surf([-1:0.1:1],[0.2:0.01:1.0],BifurcacionesX)
    colormap('jet')
    colorbar
    axis xy
    view([65 -90 100])
    %title('3-D Bifurcation diagram')
    xlabel('Opinion')
    ylabel('U')
    zlabel('Number of agents')


    load('OpiPruebaInd1conU7yMod10dl2conp7.mat')
Prueba1=Evol_opi;
load('OpiPruebaInd2conU7yMod10dl2conp7.mat')
Prueba2=Evol_opi;
load('OpiPruebaInd3conU7yMod10dl2conp7.mat')
Prueba3=Evol_opi;
load('OpiPruebaInd4conU7yMod10dl2conp7.mat')
Prueba4=Evol_opi;
load('OpiPruebaInd5conU7yMod10dl2conp7.mat')
Prueba5=Evol_opi;

  % load('SMBifurcacionesXdl2L2Mod10xl2p7.mat')



%% Caso de Corrida individual
%Códigos para la presentación de resultados en CMMSE donde las
%modificaciones de la carga de datos se encuentran en las funciones hasta
%abajo del código principal.




clc
close all
clear all

%Comparaciones

VistaLiderOpi

%VistaLiderInc

%LiderAgentes




%Cargamos datos



%% Funciones


function CorridaIndividual(PromedioOpiniones,t,p,VectorOpiFinal,Evol_opi,Evol_inc,VectorTolFinal,PromedioTolerancias,ind);

figure
histogram(PromedioOpiniones,'BinEdges',linspace(-1, 1, 22));
title('PromedioOpiniones')
xlabel('Opiniones')
ylabel('Agentes')

figure
histogram(PromedioTolerancias,'BinEdges',linspace(0, 1, 22));
title('PromedioTolerancias')
xlabel('Tolerancias')
ylabel('Agentes')

figure
subplot(2,3,1)
plot(Evol_opi(:,1:1000))
xlim([0,t])
title('Opiniones vs t')
xlabel('t')
ylabel('Opinión')
hold on
plot(Evol_opi(:,1001),':b')

subplot(2,3,2)
histogram(VectorOpiFinal(ind,:),'BinEdges',linspace(-1, 1, 22))
title('Histograma final opiniones')
xlabel('Opinión')
ylabel('N° de agentes')

subplot(2,3,3)
for i=1:t
[N,edges] = histcounts(Evol_opi(i,:),'BinEdges',linspace(-1, 1, 22));
Histogramaplot(i,:) = N;
end
imagesc([-1,1],[1,t],Histogramaplot)
axis xy
colorbar
title('Histograma temporal Opiniones')
xlabel('Opinión')
ylabel('Tiempo')

subplot(2,3,4)
plot(Evol_inc(:,1:1000))
xlim([0,t])
title('Tolerancias vs t')
axis([0 t 0 1])
xlabel('t')
ylabel('Tolerancia')
hold on
hold on
plot(Evol_inc(:,1001),'.b')

subplot(2,3,5)
histogram(VectorTolFinal(ind,:),'BinEdges',linspace(0, 1, 22))
title('Histograma final tolerancias')
xlabel('Tolerancia')
ylabel('N° de agentes')

subplot(2,3,6)
for i=1:t
[N,edges] = histcounts(Evol_inc(i,:),'BinEdges',linspace(0, 1, 22));
Histogramaplotea(i,:) = N;
end
imagesc([0,1],[1,t],Histogramaplotea)
axis xy
colorbar
title('Histograma temporal Tolerancias')
xlabel('Tolerancia')
ylabel('Tiempo')

end

function Comparaciones

load('SMBifurcacionesDicXdl8L1xl2p7.mat')
Dictador2=BifurcacionesX;
load('SMBifurcacionesDicXdl8L1xl5p7.mat')
Dictador5=BifurcacionesX;
load('SMBifurcacionesDemoXdl8L1xl2p7.mat')
Democrata2=BifurcacionesX;
load('SMBifurcacionesDemoXdl8L1xl5p7.mat')
Democrata5=BifurcacionesX;

ControlDictador2 = sum(Dictador2(:,12:14),2);
ControlDictador5 = sum(Dictador5(:,16:17),2);
ControlDemocrata2= sum(Democrata2(:,12:14),2);
ControlDemocrata5= sum(Democrata5(:,16:17),2);

plot([0.2:0.01:1],ControlDictador2,'-','LineWidth',2)
hold on
plot([0.2:0.01:1],ControlDictador5,'--','LineWidth',2)
hold on
plot([0.2:0.01:1],ControlDemocrata2,':k','LineWidth',2)
hold on
plot([0.2:0.01:1],ControlDemocrata5,'-.','LineWidth',2)
hold on
ylim ([-inf inf])
xlabel('U')
ylabel('Number of agents')
legend({'Dictator at x=0.2','Dictator at x=0.5','Democrat at x=0.2','Democrat at x=0.5'},'Location','southeast')
title(legend,'p=0.7')
%title ('Comparación de eficiencia de líderes con dl=0.8 y p=1')

end

function VistaLiderOpi  %Funcion para comparar 5 corridas individuales y el diagrama de bifurcaciones de cierto p


load('DEMONuevaOpiPruebaInd1conU7yMod10dl2conp7.mat')
Prueba1=Evol_opi;
load('DEMONuevaOpiPruebaInd2conU7yMod10dl2conp7.mat')
Prueba2=Evol_opi;
load('DEMONuevaOpiPruebaInd3conU7yMod10dl2conp7.mat')
Prueba3=Evol_opi;
load('DEMONuevaOpiPruebaInd4conU7yMod10dl2conp7.mat')
Prueba4=Evol_opi;
load('DEMONuevaOpiPruebaInd5conU7yMod10dl2conp7.mat')
Prueba5=Evol_opi;

  % load('SMBifurcacionesXdl2L2Mod10xl2p7.mat')

%% Para los histogramas y conteo de líderes
nbins=21;


%% Caso de control por parte del líder, dividiendo las opiniones en histogramas para verificar la suma de seguidores del lider en +-0.1

%Dividimos datos en secciones de conteos de histogramas para transformar
%espacio de opinión en conteo de agentes

%el número de nbins que buscamos es nbins=21

%El siguiente conteo representa la ubicación de los agentes a través de t
 ed=linspace(-1,1,nbins+1);
 edges = ed;
 for i=1:length(Prueba1(:,1))
     ConteoXPrueba1(i,:)=histcounts(Prueba1(i,:),edges);
     ConteoXPrueba2(i,:)=histcounts(Prueba2(i,:),edges);
     ConteoXPrueba3(i,:)=histcounts(Prueba3(i,:),edges);
     ConteoXPrueba4(i,:)=histcounts(Prueba4(i,:),edges);
     ConteoXPrueba5(i,:)=histcounts(Prueba5(i,:),edges);
 end

%El siguiente conteo representa la ubicación del líder a través de t
 for i=1:length(Prueba1(:,1))
     ConteoXPruebaLider1(i,:)=histcounts(Prueba1(i,1001),edges);
     ConteoXPruebaLider2(i,:)=histcounts(Prueba2(i,1001),edges);
     ConteoXPruebaLider3(i,:)=histcounts(Prueba3(i,1001),edges);
     ConteoXPruebaLider4(i,:)=histcounts(Prueba4(i,1001),edges);
     ConteoXPruebaLider5(i,:)=histcounts(Prueba5(i,1001),edges);
 end 

 %Lo siguiete me dará la ubicación de renglon y columna del líder en todo t
for i=1: 2001
 [r1(i,1),c1(i,1)] = find (ConteoXPruebaLider1(i,:) >0);
 [r2(i,1),c2(i,1)] = find (ConteoXPruebaLider2(i,:) >0);
 [r3(i,1),c3(i,1)] = find (ConteoXPruebaLider3(i,:) >0);
 [r4(i,1),c4(i,1)] = find (ConteoXPruebaLider4(i,:) >0);
 [r5(i,1),c5(i,1)] = find (ConteoXPruebaLider5(i,:) >0);
end
 %solo necesitamos el numero de columna en este caso

 %para sumar los seguidores, en el caso de que busquemos limites de +-0.1
 %el numero de columnas ya está separado en secciones de 0.1 para 21 bins
 %en otros casos se deberá modificar el +-1 segun lo que se busque con los
 %bins, por ejemplo, para 41 bins buscando +-0.15, se necesita c+-3

  for i=1:2001
    if c1(i)+1 > nbins-1 
        ControlPrueba1(i,:) = sum(ConteoXPrueba1(i,c1(i)-1:c1(i)),2);
    elseif c1(i)-1 < 1+1
        ControlPrueba1(i,:) = sum(ConteoXPrueba1(i,c1(i):c1(i)+1),2);
    else
    ControlPrueba1(i,:) = sum(ConteoXPrueba1(i,c1(i)-1:c1(i)+1),2);
    end
end

 for i=1:2001
    if c2(i)+1 > nbins-1 
        ControlPrueba2(i,:) = sum(ConteoXPrueba2(i,c2(i)-1:c2(i)),2);
    elseif c2(i)-1 < 1+1
        ControlPrueba2(i,:) = sum(ConteoXPrueba2(i,c2(i):c2(i)+1),2);
    else
    ControlPrueba2(i,:) = sum(ConteoXPrueba2(i,c2(i)-1:c2(i)+1),2);
    end
 end

  for i=1:2001
    if c3(i)+1 > nbins-1 
        ControlPrueba3(i,:) = sum(ConteoXPrueba3(i,c3(i)-1:c3(i)),2);
    elseif c3(i)-1 < 1+1
        ControlPrueba3(i,:) = sum(ConteoXPrueba3(i,c3(i):c3(i)+1),2);
    else
    ControlPrueba3(i,:) = sum(ConteoXPrueba3(i,c3(i)-1:c3(i)+1),2);
    end
  end

   for i=1:2001
    if c4(i)+1 > nbins-1 
        ControlPrueba4(i,:) = sum(ConteoXPrueba4(i,c4(i)-1:c4(i)),2);
    elseif c4(i)-1 < 1+1
        ControlPrueba4(i,:) = sum(ConteoXPrueba4(i,c4(i):c4(i)+1),2);
    else
    ControlPrueba4(i,:) = sum(ConteoXPrueba4(i,c4(i)-1:c4(i)+1),2);
    end
   end

    for i=1:2001
    if c5(i)+1 > nbins-1 
        ControlPrueba5(i,:) = sum(ConteoXPrueba5(i,c5(i)-1:c5(i)),2);
    elseif c5(i)-1 < 1+1
        ControlPrueba5(i,:) = sum(ConteoXPrueba5(i,c5(i):c5(i)+1),2);
    else
    ControlPrueba5(i,:) = sum(ConteoXPrueba5(i,c5(i)-1:c5(i)+1),2);
    end
end


figure
subplot(3,3,1)
plot(Prueba5(:,1:1000))
xlim([0,2000])
%title('Opiniones vs t, Prueba 1')
xlabel('t')
ylabel('Opinion')
hold on
plider = plot(Prueba5(:,1001),'-.b','LineWidth',2);
legend([plider],{'Leader'},'FontSize',6,'Location','northwest')
title(legend,'Particular scenario 1')


subplot(3,3,2)
plot(Prueba2(:,1:1000))
xlim([0,2000])
%title('Opiniones vs t, Prueba 2')
xlabel('t')
ylabel('Opinion')
hold on
plider2=plot(Prueba2(:,1001),'-.b','LineWidth',2);
legend([plider2],{'Leader'},'FontSize',6,'Location','northwest')
title(legend,'Particular scenario 2')

subplot(3,3,3)
plot(Prueba3(:,1:1000))
xlim([0,2000])
%title('Opiniones vs t, Prueba 3')
xlabel('t')
ylabel('Opinion')
hold on
plider3=plot(Prueba3(:,1001),'-.b','LineWidth',2);
legend([plider3],{'Leader'},'FontSize',6,'Location','northwest')
title(legend,'Particular scenario 3')

subplot(3,3,4)
histogram(Prueba5(2000,:), nbins)
xlabel('Opinion')
ylabel('Number of agents')
xlim([-1.1,1.1])
ylim([0,1000])

subplot(3,3,5)
histogram(Prueba2(2000,:), nbins)
xlabel('Opinion')
ylabel('Number of agents')
xlim([-1.1,1.1])
ylim([0,1000])

subplot(3,3,6)
histogram(Prueba3(2000,:), nbins)
xlabel('Opinion')
ylabel('Number of agents')
xlim([-1.1,1.1])
ylim([0,1000])

subplot(3,3,7)
plot(ControlPrueba5)
xlim([0,2000])
xlabel('t')
ylabel('Number of agents')
ylim([0,1000])

subplot(3,3,8)
plot(ControlPrueba2)
xlim([0,2000])
xlabel('t')
ylabel('Number of agents')
ylim([0,1000])

subplot(3,3,9)
plot(ControlPrueba3)
xlim([0,2000])
xlabel('t')
ylabel('Number of agents')
ylim([0,1000])






% subplot(2,3,4)
% plot(Prueba4(:,1:1000))
% xlim([0,2000])
% %title('Opiniones vs t, Prueba 4')
% xlabel('t')
% ylabel('Opinion')
% hold on
% plider4=plot(Prueba4(:,1001),'-.b','LineWidth',2);
% legend([plider4],{'Leader'},'FontSize',6,'Location','northwest')
% title(legend,'Particular scenario 4')
% 
% subplot(2,3,5)
% plot(Prueba5(:,1:1000))
% xlim([0,2000])
% %title('Opiniones vs t, Prueba 5')
% xlabel('t')
% ylabel('Opinion')
% hold on
% plider5=plot(Prueba5(:,1001),'-.b','LineWidth',2);
% legend([plider5],{'Leader'},'FontSize',6,'Location','northwest')
% title(legend,'Particular scenario 5')
% 
% subplot(2,3,6)
% imagesc([-1:0.1:1],[0.2:0.01:1.0],BifurcacionesX)
% colorbar
% axis xy
% % title('Bifurcaciones Opiniones')
%  xlabel('Opinion')
 % ylabel('U')

end

function VistaLiderInc %Funcion para comparar 5 corridas individuales y el diagrama de bifurcaciones de cierto p

load('IncPruebaInd1conU2yMod10dl2conp0.mat')
Prueba1=Evol_inc;
load('IncPruebaInd2conU2yMod10dl2conp0.mat')
Prueba2=Evol_inc;
load('IncPruebaInd3conU2yMod10dl2conp0.mat')
Prueba3=Evol_inc;
load('IncPruebaInd4conU2yMod10dl2conp0.mat')
Prueba4=Evol_inc;
load('IncPruebaInd5conU2yMod10dl2conp0.mat')
Prueba5=Evol_inc;

  load('SMBifurcacionesULiderdl2L2Mod10xl2p0.mat')


figure
subplot(2,3,1)
plot(Prueba1(:,1:1000))
xlim([0,2000])
title('Tolerancias vs t, Prueba 1')
xlabel('t')
ylabel('Tolerancia')
hold on
plot(Prueba1(:,1001),'-.b','LineWidth',2)

subplot(2,3,2)
plot(Prueba2(:,1:1000))
xlim([0,2000])
title('Tolerancias vs t, Prueba 2')
xlabel('t')
ylabel('Tolerancia')
hold on
plot(Prueba2(:,1001),'-.b','LineWidth',2)

subplot(2,3,3)
plot(Prueba3(:,1:1000))
xlim([0,2000])
title('Tolerancias vs t, Prueba 3')
xlabel('t')
ylabel('Tolerancia')
hold on
plot(Prueba3(:,1001),'-.b','LineWidth',2)

subplot(2,3,4)
plot(Prueba4(:,1:1000))
xlim([0,2000])
title('Tolerancias vs t, Prueba 4')
xlabel('t')
ylabel('Tolerancia')
hold on
plot(Prueba4(:,1001),'-.b','LineWidth',2)

subplot(2,3,5)
plot(Prueba5(:,1:1000))
xlim([0,2000])
title('Tolerancias vs t, Prueba 5')
xlabel('t')
ylabel('Tolerancia')
hold on
plot(Prueba5(:,1001),'-.b','LineWidth',2)

subplot(2,3,6)
imagesc([0:0.1:1],[0.2:0.01:1.0],BifurcacionesULider)
colorbar
axis xy
 title('Bifurcaciones Tolerancias')
 xlabel('Opiniones')
 ylabel('Uprom')



end

function LiderAgentes  %Función para comparar los diagramas de bifurcación del líder y el grupo de agentes


load('SMBifurcacionesXLiderdl8L2Mod20xl2p10.mat')
DiagramaLider=BifurcacionesXLider;
load('SMBifurcacionesXdl8L2Mod20xl2p10.mat')
DiagramaAgentes=BifurcacionesX;

figure
subplot(1,2,1)
imagesc([-1:0.1:1],[0.2:0.01:1.0],DiagramaLider)
colorbar
axis xy
 title('Bifurcación de opiniones del lider')
 xlabel('Opiniones')
 ylabel('Uprom')

 subplot(1,2,2)
imagesc([-1:0.1:1],[0.2:0.01:1.0],DiagramaAgentes)
colorbar
axis xy
 title('Bifurcación de opiniones de agentes')
 xlabel('Opiniones')
 ylabel('Uprom')
end

