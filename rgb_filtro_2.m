% Carica l'immagine
close all;
name = 'MonaLisa';
img = imread([name, '.jpg']);
dim=32;
uno_if_toroidale=0;
uno_if_mirr= 0;
% inserire il padding se 0 o 255
padding=0;

% Riduci l'immagine ad una dimensione di 32x32 pixel
resized_image = imresize(img, [dim,dim]);
img_32x32=resized_image;
subplot(2,2,1), imshow(resized_image), title('Immagine 32 x 32') 
% Carica l'immagine filtrata dal circuito
path_behav = 'C:\Users\raffy\Documents\Vivado_projects\V4\project_pix\project_pix.sim\sim_1\behav\xsim\';
path_impl = 'C:\Users\raffy\Documents\Vivado_projects\V4\project_pix\project_pix.sim\sim_1\impl\timing\xsim\';

% Definisci il kernel personalizzato
w_r = 10;
wl_r = -1;
wc_r = -1;
w_g = 10;
wl_g = -1;
wc_g = -1;
w_b = 10;
wl_b = -1;
wc_b = -1;

% w_r = 1;
% wl_r = 0;
% wc_r = 0;
% w_g = 1;
% wl_g = 0;
% wc_g = 0;
% w_b = 1;
% wl_b = 0;
% wc_b = 0;


% kernel_r = [wc_r, wl_r, wc_r; wl_r, w_r, wl_r; wc_r, wl_r, wc_r]; %kernel personalizzato
kernel_g = [wc_g, wl_g, wc_g; wl_g, w_g, wl_g; wc_g, wl_g, wc_g]; %kernel personalizzato
kernel_b = [wc_b, wl_b, wc_b; wl_b, w_b, wl_b; wc_b, wl_b, wc_b]; %kernel personalizzato

kernel_r = [0,0,0]; %kernel personalizzato

% Estrae i canali rosso, verde e blu
red = resized_image(:,:,1);
green = resized_image(:,:,2);
blue = resized_image(:,:,3);

Rout_resultb = readmatrix([path_behav, 'Routput_results.txt']);
Gout_resultb = readmatrix([path_behav, 'Goutput_results.txt']);
Bout_resultb = readmatrix([path_behav, 'Boutput_results.txt']);

Rout_result = readmatrix([path_impl, 'Routput_results.txt']);
Gout_result = readmatrix([path_impl, 'Goutput_results.txt']);
Bout_result = readmatrix([path_impl, 'Boutput_results.txt']);

img_padded = uint8(zeros(34, 34, size(img_32x32, 3)));

% Posiziona l'immagine 32x32 all'interno dell'immagine 34x34
img_padded(2:33, 2:33, :) = img_32x32;

% Copia gli angoli dell'immagine 32x32 negli angoli dell'immagine 34x34
img_padded(1, 1, :) = img_32x32(2, 2, :);                                         % Angolo in alto a sinistra
img_padded(1, end, :) = img_32x32(2, end-1, :);                                     % Angolo in alto a destra
img_padded(end, 1, :) = img_32x32(end-1, 2, :);                                     % Angolo in basso a sinistra
img_padded(end, end, :) = img_32x32(end-1, end-1, :);                                 % Angolo in basso a destra

% Replicazione delle righe e colonne necessarie per la completa costruzione
img_padded(1, 2:end-1, :) = img_32x32(2, :, :);                                   % Prima riga
img_padded(2:end-1, 1, :) = img_32x32(:, 2, :);                                   % Prima colonna
img_padded(end, 2:end-1, :) = img_32x32(end-1, :, :);                               % Ultima riga
img_padded(2:end-1, end, :) = img_32x32(:, end-1, :);                               % Ultima colonna

red_mir = img_padded(:,:,1);
green_mir = img_padded(:,:,2);
blue_mir = img_padded(:,:,3);

mir_R = imfilter(red_mir, kernel_r);
mir_G = imfilter(green_mir, kernel_g);
mir_B = imfilter(blue_mir, kernel_b);

% Unisce i colori
filtered_image_mir = cat(3, mir_R, mir_G, mir_B);
filtered_image_mir = filtered_image_mir(2:end-1, 2:end-1, :);

% Reshape i dati in una matrice 32x32
Rdata = reshape(Rout_result, [dim,dim]);
Gdata = reshape(Gout_result, [dim,dim]);
Bdata = reshape(Bout_result, [dim,dim]);

Rdatab = reshape(Rout_resultb, [dim,dim]);
Gdatab = reshape(Gout_resultb, [dim,dim]);
Bdatab = reshape(Bout_resultb, [dim,dim]);

% Convert binary matrix to decimal matrix
Rmyfilt_image = zeros(dim,dim);
Gmyfilt_image = zeros(dim,dim);
Bmyfilt_image = zeros(dim,dim);
Rmyfilt_imageb = zeros(dim,dim);
Gmyfilt_imageb = zeros(dim,dim);
Bmyfilt_imageb = zeros(dim,dim);
for i = 1:dim
    for j = 1:dim % Clip image borders
    % Convert each row of binary numbers to decimal
    Rmyfilt_image(i,j) = bin2dec(num2str(Rdata(j,i)));
    Gmyfilt_image(i,j) = bin2dec(num2str(Gdata(j,i)));
    Bmyfilt_image(i,j) = bin2dec(num2str(Bdata(j,i)));
    Rmyfilt_imageb(i,j) = bin2dec(num2str(Rdatab(j,i)));
    Gmyfilt_imageb(i,j) = bin2dec(num2str(Gdatab(j,i)));
    Bmyfilt_imageb(i,j) = bin2dec(num2str(Bdatab(j,i)));
    end
end

Rmyfilt_image = uint8(Rmyfilt_image);
Gmyfilt_image = uint8(Gmyfilt_image);
Bmyfilt_image = uint8(Bmyfilt_image);

Rmyfilt_imageb = uint8(Rmyfilt_imageb);
Gmyfilt_imageb = uint8(Gmyfilt_imageb);
Bmyfilt_imageb = uint8(Bmyfilt_imageb);

% Unisce i tre colori in un'unica immagine
myfilt_image = cat(3, Rmyfilt_image, Gmyfilt_image, Bmyfilt_image);
myfilt_imageb = cat(3, Rmyfilt_imageb, Gmyfilt_imageb, Bmyfilt_imageb);

% Applica il filtro
r_image = imfilter(red, kernel_r,padding);
g_image = imfilter(green, kernel_g,padding);
b_image = imfilter(blue, kernel_b,padding);


% Unisce i colori
filtered_image = cat(3, r_image, g_image, b_image);
% Visualizza l'immagine originale e l'immagine filtrata

if uno_if_toroidale == 1
filtered_image_tor=filtered_image(2:end-1,2:end-1,:);
myfilt_image_impl_tor=myfilt_image(2:end-1,2:end-1,:);
myfilt_image_behav_tor=myfilt_imageb(2:end-1,2:end-1,:);
elseif uno_if_mirr==1  
filtered_image_tor=filtered_image_mir;
filtered_image=filtered_image_mir;
myfilt_image_impl_tor=myfilt_image;
myfilt_image_behav_tor=myfilt_imageb;
else
filtered_image_tor=filtered_image;
myfilt_image_impl_tor=myfilt_image;
myfilt_image_behav_tor=myfilt_imageb;
end

ref = reshape(double(filtered_image_tor), 1, []);
I_impl = reshape(double(myfilt_image_impl_tor), 1, []);
I_behav = reshape(double(myfilt_image_behav_tor), 1, []);

mse_behav = norm((ref-I_behav))^2/(3*dim^2);
mse_impl = norm((ref-I_impl))^2/(3*dim^2);
mse = norm((I_behav-I_impl))^2/(3*dim^2);

caption_behav = sprintf('Filtro FPGA "behavioral"\nMSE = %f', mse_behav);
caption_impl = sprintf('Filtro FPGA "post timing implementation"\nMSE = %f', mse_impl);

subplot(2,2,2), imshow(filtered_image), title('Filtro Matlab')
subplot(2,2,3), imshow(myfilt_imageb), title(caption_behav)
subplot(2,2,4), imshow(myfilt_image), title(caption_impl)
if mse == 0
    fprintf("La post implementazione è la stessa della behav\n");
end

% Inizializza il contatore dei pixel diversi
% num_pixel_diversi = 0;
% Confronta le immagini pixel per pixel
%con gestione bordo
% for i = 1:32
%     for j = 1:32
%         for k= 1:3
%         if filtered_image(i,j,k) ~= myfilt_image(i,j,k)
%             num_pixel_diversi = num_pixel_diversi + 1;
%         end
%         end
%     end
% end
% fprintf('Il numero di pixel diversi tra le due immagini è: %d\n', num_pixel_diversi);