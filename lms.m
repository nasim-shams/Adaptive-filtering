%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% LEAST MEAN SQUARES (LMS) ALGORITHM & EQUALIZATION %
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %
% %
% AUTHOR : NASIM SHAMS %
%
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
nvari = 0.5; % Noise variance
dvari = 1; % Input data variance
taps = zeros(1,forder); % Initializing the tap weight counter
for trys = 1:trials % Loop for No. of trials
u = zeros(1,forder); % intialization of tap I/p for time < 1
a = zeros(1,forder-1); % intialization of data i/p for time < 1
% for j = 1:forder
% w(forder,j) = 0; % intializing tapweight vector w(0) = 0
% end
w = zeros(1,forder);
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
    w = w + mu*e(n)*u;
end
%% Calculating the error square for each trial & adding it up
eSquare = eSquare + e.^2;
 
end %%% Loop for number of trials (try variable)
%% Calculating the Mean square error (ie total err at instant i / # of trials)
error = eSquare./trials;
%% Plotting the Learning Curve
 figure(1);
 %hold on
  semilogy(error,'red');
  grid on
 figure(2);
 stem(w);
 figure(3);
 combine= conv(h,w);
 stem(combine);
 
 
%%%%% Plotting the channel responses %%%%
%%%%% Plotting the equalizer responses %%%%
%%%%% Plotting the combined responses %%%%%
