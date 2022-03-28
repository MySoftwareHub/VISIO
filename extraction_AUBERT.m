v = VideoReader('video1.mp4') ; %Ouverture de la vidéo.
j = v.NumberOfFrames ; %Calcul du nombre d'image dans la vidéo.

i = 1 ; %Variable de boucle.

%Boucle d'extration des images. Extraction d'une image sur 24.
while (i+24<j)
    
	video = read(v,i) ; %Lecture d'une image.
	str = "image"+i+".png" ; %Création d'un nom de fichier.
	imwrite(video,str) ; %Création d'un fichier.
	imshow(video) ; %Affichage de l'image gardée.
	i = i + 24 ; %Incrémentation de la boucle
    
end

close all ; %Fermeture de la fenêtre. 