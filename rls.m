

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% RLS ALGORITHM & EQUALIZATION %
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
% %
% AUTHOR : NASIM SHAMS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% Assumptions for Channel Capacity W, No. of Samples, No. of trials %%
eSquare = zeros (1,709);
mu = 0.07;
W = 3.2; % Channel Capacity
alp = 2; % alpha
forder = 7; % filter order
tsamples = 700; % total # of samples
delay = 4; % delay for desired response
trials = 500; % No. of independent trials
de = zeros(1,tsamples); % Intializing the squared error
nvari = 0.001; % Noise variance
dvari = 1; % Input data variance
taps = zeros(1,forder); % Initializing the tap weight counter
for trys = 1:trials % Loop for No. of trials
u = zeros(1,forder); % intialization of tap I/p for time < 1
a = zeros(1,forder-1); % intialization of data i/p for time < 1
% for j = 1:forder
% w(forder,j) = 0; % intializing tapweight vector w(0) = 0
% end
w = zeros(1,forder);
p = eye(forder).*2;
 
 
%%%%%%%%%% MODULE 1 %%%%%%%%%%%%%%%%
for sampgen = forder : tsamples+forder %% Generates Random data & desired resp
a(sampgen) = fix(rand+0.5)*2-1;
end
d = [zeros(1,delay) a];
for sampgen = forder : tsamples+forder %% Generates Random noise
v(sampgen) = fix(rand+0.5)*2*sqrt(nvari)-sqrt(nvari);
end
 
%% Impulse Response of the Channel for given W %%
for k = 1:3
h(k) = 1/2*(1+cos(2*pi/W*(k-2)));
end;
%% Mu
%muu = ; %%% Fill the appropriate mu
%%%%%%% MODULE 2 : UPDATING THE WEIGHTS & PLOTTING THE LEARNING CURVE %%%%%%%
%% Output from Channel
cop = conv(h,a);
 
%% Input to the equalizer (Channel o/p + Random Noise)
copn = cop + [v 0 0];
copn_size = size(copn);
%% Finding the Estimate
%% Calculating the Error (desired resp - estimate)
%% Updating the tap weights
for n = forder : copn_size(2)
    u = copn(n-forder+1:n);
    y(n) = w*u';
    e(n) = d(n) - y(n);
    alpha(n) = d(n)-w*u';
    k = (p*u')./(1+u*p*u');
    p = p-k*u*p;
    w = w+(k*alpha(n))';
end
%% Calculating the error square for each trial & adding it up
eSquare = eSquare + e.^2;
 
end %%% Loop for number of trials (try variable)
%% Calculating the Mean square error (ie total err at instant i / # of trials)
error = eSquare./trials;
%% Plotting the Learning Curve
figure(1);
%hold on
semilogy(error,'b');
grid on
figure(2);
stem(w);
figure(3);
combine= conv(h,w);
stem(combine);
figure;
plot(abs(fft(combine)));
ylim ([0 10]);
%%%%% Plotting the channel responses %%%%
%%%%% Plotting the equalizer responses %%%%
%%%%% Plotting the combined responses %%%%%
