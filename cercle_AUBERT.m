%% Préparation de l'espace de travail.
clc ; %Nettoyage de la console.
clear all ; %Suppression des variables des workspaces.
close all ; %Fermeture de toutes  les fenêtres. 

%% Ouverture de la vidéo.
v = VideoReader('video2.mp4') ; %Ouverture de la vidéo.
j = v.NumberOfFrames ; %Calcul du nombre d'image de la vidéo.
i = 1 ;

%% Acquisition des coordonnées du repère en pixels.
figure ; %Ouverture d'une fenêtre.
im = read(v,1) ; %Lecture de la première image de la vidéo.
imshow(im) ; %Affichage de cette image.
[x,y] = getpts ; %Acquision des points du repère à la souris.

%% Préparation de la caméra.
K = [804.1623 0 0; 0 802.3114 0; 235.6459 425.5116 1]' ; %Matrice des variables intrinsèques de la caméra obtenue par calibration.
Kinv = inv(K) ; %Inverse de cette matrice.

%% Calcul du facteur d'échelle S permettant de passer de pixels à mm.
p0 = Kinv * [x(1);y(1);1] ;
p1 = Kinv * [x(2);y(2);1] ;
p2 = Kinv * [x(3);y(3);1] ;

dmesx = 195 ; %mm
dmesy = 95 ; %mm

s_x = dmesx / norm(p1-p0) ;
s_y = dmesy / norm(p2-p0) ;
s = mean([s_x s_y]) ;

%% Calcul des coordonnées des points O,X et Y en mm dans le repère Caméra (juste pour validation).
P0 = s*Kinv*[x(1);y(1);1] ;
P1 = s*Kinv*[x(2);y(2);1] ;
P2 = s*Kinv*[x(3);y(3);1] ;

%% Détermination de la matrice de rotation.
Rx = (P1-P0)/norm(P1-P0) ; 
Ry = (P2-P0)/norm(P2-P0) ;
Rz = cross(Rx,Ry) ; %Obtention de la norme par produit vectoriel.
R = [Rx Ry Rz] ; %Matrice de rotation.
Rtrans = R' ; %Transposée de cette matrice. 

%% Détermination de la matrice de translation.
T = P0 ; 

%% Passage des points O,X et Y en mm dans le repère World (juste pour validation).
origin = Rtrans*(P0-T) ;
X = Rtrans*(P1-T) ;
Y = Rtrans*(P2-T) ;

%% Boucle de traitement de la vidéo.
while i<j 
    
	J = read(v,i) ; %Lecture d'une image dans la vidéo. 
    
    %Traitement numérique de l'image.
    I = J * 2 ; %Modifications des contrastes de l'image.
    I = I + 5 ; %Modifications des contrastes de l'image.
    I= im2bw(I,0.41) ; %Mise de l'image en noir et blanc ainsi que léger filtrage.
    I = imcomplement(I) ; %Inversion du noir et du blanc sur l'image. 
    I = bwareafilt(I,1) ; %Filtre d'aire pour extraire le cercle, ce filtre sélectionne l'objet le plus massif en pixels. 
    
    stat = regionprops(I,'centroid') ; %Détermine le centre du cercle. 
    
    imshow(J) ; %Affichage de l'image initiale.
    
    hold on ; %Permet la conservation de l'image lors de la modification.
 
    plot(stat(1).Centroid(1),stat(1).Centroid(2),'r+'); %Affichage du centre du cercle sur l'image.
    
    PC = s*Kinv*[stat(1).Centroid(1);stat(1).Centroid(2);1] ; %Calcul des coordonnées en mm dans le repère Caméra.
    center = Rtrans*(PC-T) ; %Passage des coordonnées en mm dans le repère World. 
    
    %Création des chaînes de caractères contenant les valeurs en mm.
    str1 = "x :" + round(center(1)) + "mm";
    str2 = "y :" + round(center(2)) + "mm";
    
    % Gestion des graphismes.
    viscircles([stat(1).Centroid(1) stat(1).Centroid(2)], 40,'Color','r');
    line([stat(1).Centroid(1)+28 stat(1).Centroid(1)+60],[stat(1).Centroid(2)-25 stat(1).Centroid(2)-40],'Color','red')
    line([stat(1).Centroid(1)+60 stat(1).Centroid(1)+80],[stat(1).Centroid(2)-40 stat(1).Centroid(2)-40],'Color','red')
    rectangle('Position',[stat(1).Centroid(1)+80 stat(1).Centroid(2)-40 70 50],'EdgeColor','r');
    text(stat(1).Centroid(1)+85,stat(1).Centroid(2)-50,'Cercle','color','red');
    text(stat(1).Centroid(1)+85,stat(1).Centroid(2)-25,str1,'color','red','FontSize',8);
    text(stat(1).Centroid(1)+85,stat(1).Centroid(2)-5,str2,'color','red','FontSize',8);
    
    % Pause pour optimiser l'affichage. 
    pause(0.0001);
   
    % Variable de boucle pour passer à l'image suivante.
	i = i + 1;
    
end

