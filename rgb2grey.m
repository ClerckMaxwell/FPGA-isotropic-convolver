% Carica l'immagine
close all;
name = 'MonaLisa';
img = imread([name, '.jpg']);
dim=32;
padding=0;
% Riduci l'immagine ad una dimensione di 32x32 pixel
resized_image = imresize(img, [32, 32]);
h=resized_image;
subplot(2,2,1), imshow(resized_image), title('Originale Matlab')
hold on
% Estrae i canali rosso, verde e blu


% Carica l'immagine filtrata dal circuito
path_behav = 'C:\Users\raffy\Documents\Vivado_projects\V4\project_pix\project_pix.sim\sim_1\behav\xsim\';
path_impl = 'C:\Users\raffy\Documents\Vivado_projects\V4\project_pix\project_pix.sim\sim_1\impl\timing\xsim\';
Rout_result_impl = readmatrix([path_impl, 'Routput_results.txt']);

Rout_result = readmatrix([path_behav, 'Routput_results.txt']);

gray_image=rgb2gray(resized_image);
% Convertire i valori a interi (arrotondare all'intero più vicino)
gray_image = uint8(gray_image);
red = gray_image(:,:,1);

% Visualizzare l'immagine in scala di grigi
% Reshape i dati in una matrice 32x32
Rdata = reshape(Rout_result, [32, 32]);
Rdata_impl=reshape(Rout_result_impl, [32, 32]);
% Convert binary matrix to decimal matrix
Rmyfilt_image = zeros(32,32);
Rmyfilt_image_impl = zeros(32,32);
for i = 1:32
    for j = 1:32 % Clip image borders
    % Convert each row of binary numbers to decimal
    Rmyfilt_image(i,j) = bin2dec(num2str(Rdata(j,i)));
    Rmyfilt_image_impl(i,j) = bin2dec(num2str(Rdata_impl(j,i)));
    end
end

Rmyfilt_image = uint8(Rmyfilt_image);
Rmyfilt_image_impl=uint8(Rmyfilt_image_impl);
% Unisce i tre colori in un'unica immagine
% Definisci il kernel personalizzato
% w_r = 11;
% wl_r = -1;
% wc_r = -1;


w_r =1;
wl_r = 0;
wc_r = 0;


kernel_r = [wc_r, wl_r, wc_r; wl_r, w_r, wl_r; wc_r, wl_r, wc_r]; %kernel personalizzato

% Normalizza il kernel
%kernel_r = kernel_r / sum(kernel_r, 'all');
%kernel_g = kernel_g / sum(kernel_g, 'all');
%kernel_b = kernel_b / sum(kernel_b, 'all');

% Applica il filtro
r_image = imfilter(red, kernel_r,'symmetric');
subplot(2,2,2), imshow(r_image), title('matlab filter gray')
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
%non gestione
num_pixel_diversi = 0;
for i = 1:32
    for j = 1:32
        gray_pixel_value = double(r_image(i, j));
        filtered_pixel_value = double(Rmyfilt_image(i, j));
        A = gray_pixel_value - filtered_pixel_value;        
        if abs(A) > 0 % Use abs to check for both positive and negative differences
      num_pixel_diversi = num_pixel_diversi + 1;
        end
    end
end
fprintf('Il numero di pixel diversi tra le due immagini è: %d\n', num_pixel_diversi);
ref = reshape(double(r_image), 1, []);
I_behav = reshape(double(Rmyfilt_image), 1, []);
I_impl=reshape(double(Rmyfilt_image_impl),1,[]);
mse = norm((ref-I_behav))^2/(dim^2);
mse_impl=norm((ref-I_impl))^2/(dim^2);
psnr=20*log10(255/sqrt(mse));
psnr_impl=20*log10(255/sqrt(mse_impl));

caption_behav = sprintf('Filtro FPGA "behavioral"\nMSE = %f', mse);
caption_impl = sprintf('Filtro FPGA "post timing implementation"\nMSE = %f', mse_impl);

subplot(2,2,3), imshow(Rmyfilt_image), title(caption_behav);
subplot(2,2,4), imshow(Rmyfilt_image_impl), title(caption_impl);
