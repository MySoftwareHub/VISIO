v = VideoReader('video1.mp4') ; %Ouverture de la vid�o.
j = v.NumberOfFrames ; %Calcul du nombre d'image dans la vid�o.

i = 1 ; %Variable de boucle.

%Boucle d'extration des images. Extraction d'une image sur 24.
while (i+24<j)
    
	video = read(v,i) ; %Lecture d'une image.
	str = "image"+i+".png" ; %Cr�ation d'un nom de fichier.
	imwrite(video,str) ; %Cr�ation d'un fichier.
	imshow(video) ; %Affichage de l'image gard�e.
	i = i + 24 ; %Incr�mentation de la boucle
    
end

close all ; %Fermeture de la fen�tre. 