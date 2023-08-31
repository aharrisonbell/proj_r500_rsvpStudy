function plx500_project2_fft

figure
im=imread('C:\Documents and Settings\Andrew Bell\Desktop\m2.bmp');
im=im(:,:,1); % reduce to one channel (all the same)
subplot(1,4,1)
imshow(im)
% conduct fast-fourier transform of the image
imfft=fft2(im);
imfft2=abs(imfft);
subplot(1,4,2)
imshow(imfft2,[],'InitialMagnification','fit')

% conduct fast-fourier transform of the image
imfft=fft2(im);
imfft2=abs(imfft);
subplot(1,4,3)
imshow(log(1+imfft2),[])

inimfft=ifft2(imfft);
subplot(1,4,4)
imshow(inimfft)






footBall=imread('C:\Documents and Settings\Andrew Bell\Desktop\m2.bmp');
footBall=footBall(:,:,1); % Grab only the Red component to fake gray scaling
imshow(footBall)
PQ = paddedsize(size(footBall));
D0 = 0.05*PQ(1);
H = lpfilter('gaussian', PQ(1), PQ(2), D0); % Calculate the LPF
F=fft2(double(footBall),size(H,1),size(H,2)); % Calculate the discrete Fourier transform of the image
LPF_football=real(ifft2(H.*F)); % multiply the Fourier spectrum by the LPF and apply the inverse, discrete Fourier transform
LPF_football=LPF_football(1:size(footBall,1), 1:size(footBall,2)); % Resize the image to undo padding
figure, imshow(LPF_football, [])
% Display the Fourier Spectrum
Fc=fftshift(F); % move the origin of the transform to the center of the frequency rectangle
S2=log(1+abs(Fc)); % use abs to compute the magnitude (handling imaginary) and use log to brighten display
figure, imshow(S2,[])


