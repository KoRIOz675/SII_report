clear
close all
clc

% Data visualization

%% Question 1
load("data-proj.mat")
whos

%% Question 2
figure(1)
plot(t, omega)
grid on
hold on
xlabel('Time [sec]')
ylabel('Angular speed [rad/sec]')



%% Analog filtering

%% Question 3
Te1 = t(2)-t(1);

% Question 4
Te2= 0.05; 
Fe2=1/Te2;
Tf=t(end);
N=Tf/Te2 ;

f1=-Fe2*(N/2-1)/N:Fe2/N:0;
f2=Fe2/N:Fe2/N:(N/2)*Fe2/N;
f = [f2,f1];
w= zeros(N,1);
for m=1:N
  for k=1:N
    w(m)=w(m)+omega(k)*exp(-1i*2*pi*m*k/N);
  
  end
end

figure(2)
stem(f,abs(w)/N)
grid on
hold on
xlim([-2 2])
xlabel('f [Hz]')
ylabel('DFT(\omega (t))')


%% Question 6
% filter design
t1=0:Te2:t(end)-Te2;
fc1=2;
H1=tf(1,[1/(2*pi*fc1)  1]);
wf=lsim(H1,w,t1);

% plot of filtered signal
figure(1);
plot(t1,wf,'r')
grid on
legend(' \omega(t) unfiltered','\omega_{f}(t) filtered','Fontsize',14)


%% Question 7
figure(2)
stem(f,abs(wf)/N, 'r')
grid on
xlim([-2 2])
legend(' DFT of \omega(t)','DFT of \omega_{f}(t)','Fontsize',14)



% Sampling

%% Question 8
temp1 = 1:round(Te2/Te1):length(wf);
we=wf(temp1);

%% Question 