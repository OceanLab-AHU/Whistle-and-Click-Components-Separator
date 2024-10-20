clear;
close all;
clc;

fs = 48000;
N = 48000;
t= 0:1/fs:1;
%% Simulate Sig
Sig1 = exp(-1i*10000*pi*t+1i*1700*sin(2*pi*t));
Sig2 = exp(-1i*20000*pi*t+1i*3600*sin(2*pi*t)) ; 
Sig3 = exp(-1i*30000*pi*t+1i*3500*sin(2*pi*t)) ;
Sig = Sig1+ Sig2+Sig3;
Sig = Sig/max(Sig);
% add clicks
num_clicks = 6; 
click_interval = length(t)/ num_clicks; 
click_times = round((1:num_clicks-1) * click_interval); 
click_magnitude = 0.00061*fs;
Sig(click_times) = Sig(click_times) + click_magnitude; 
Sig = fliplr(Sig);
Sig = awgn(Sig, -1, 'measured') ;%add -1dB noise

%% Whale Sig
% [signal, ~] = audioread('WhaleSig1.mp3');
% signal1 = signal(360000:410000,1);
% [signal, fs] = audioread('WhaleSig2.mp3');
% signal2 = signal(1:50001,1);
% Sig = signal1 + signal2;

[~, f, t, ReRidges, SpecSet] = OWCS(Sig, fs);

disp_band = [min(t) max(t) 0 fs/2];

%%Click
SP1 =ReRidges(1,1).energys;
temp1 = max(SP1, [], 2);
SP1(SP1<0.13*temp1) =0;
Spec = abs(max(log(abs(SP1)+10),-10));
figure;
set(gcf,'Position',[20 100 338 230]);
set(gcf,'Color','w');  
mesh(t,f,Spec);
ylabel('Frequency [Hz]');
xlabel('Time [s]');
axis xy;
axis(disp_band);
set(gca,'FontName','Times New Roman');
set(gca,'FontSize',12);
colormap(viridis); 
shading interp;
view(0,90);
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig','-depsc');

%whistle
SP2 =ReRidges(3,2).energys;
temp2 =max( max(SP2, [], 2));
SP2(SP2<0.01*temp2) =0;
Spec = abs(max(log(abs(SP2)+10),-10));

figure;
set(gcf,'Position',[20 100 338 230]);
set(gcf,'Color','w');  
mesh(t,f,Spec);
ylabel('Frequency [Hz]');
xlabel('Time [s]');
axis xy;
axis(disp_band);
set(gca,'FontName','Times New Roman');
set(gca,'FontSize',12);
colormap(viridis); 
shading interp;
view(0,90);
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'fig','-depsc');