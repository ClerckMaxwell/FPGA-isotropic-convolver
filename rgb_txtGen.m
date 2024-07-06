% Legge l'immagine RGB
name = 'MonaLisa';
dim = 32;
img_rgb = imread([name, '.jpg']);

% Riduci l'immagine ad una dimensione di 32x32 pixel
res_img = imresize(img_rgb, [dim, dim]);

% Estrae i canali rosso, verde e blu
red = res_img(:,:,1);
green = res_img(:,:,2);
blue = res_img(:,:,3);

% Apri i file in modalità di scrittura
fileID_r = fopen(['R', name, '.txt'], 'w');
fileID_g = fopen(['G', name, '.txt'], 'w');
fileID_b = fopen(['B', name, '.txt'], 'w');

% Scrivi i valori dei pixel nei file
for i = 1:dim
    for j = 1:dim
        fprintf(fileID_r, '%d,\n', red(i, j));
        fprintf(fileID_g, '%d,\n', green(i, j));
        fprintf(fileID_b, '%d,\n', blue(i, j));
    end
end

% Chiudi i file
fclose(fileID_r);
fclose(fileID_g);
fclose(fileID_b);
