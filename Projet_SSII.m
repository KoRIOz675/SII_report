clear
close all
clc

%% Data visualization

% Question 1
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

% Question 3
Te1 = t(2)-t(1);

%% Question 4
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

t_temp = t';
omega = omega';
data = [t_temp,omega];


%% Question 7
figure(2)
stem(f,abs(wf)/N, 'r')
grid on
xlim([-2 2])
legend(' DFT of \omega(t)','DFT of \omega_{f}(t)','Fontsize',14)



%% Sampling

% Question 8
temp1 = 1:round(Te2/Te1):length(wf);
we=wf(temp1);

%% Question 10
Te = (0:length(we)-1) * Te2;

%% Question 11
figure(3)
plot(t1,wf)
xlim([10 12])
xlabel('Time [sec]')
ylabel('Angular Velocity [rad/sec]')
grid on
hold on
stem(Te,abs(we), 'r')
legend(' \omega_{f}(t)','\omega_{e}(t)','Fontsize',14)

%% Question 12
we_dft = fft(we);

figure(4)
stem(f,abs(w)/N)
hold on
stem(f,abs(wf)/N, 'r')
stem(Te,abs(we_dft)/N, 'g')
xlabel('Frequency [Hz]')
ylabel('Amplitude')
legend({'ω(t)', 'ωf(t)', 'ωe(t)'})
xlim([-1 1])

%% Questions 13  
wd=zeros(8,1);
j=0;

TeM=Te';

wd(1)=(we(1))/TeM(1);
for i=2:7
    wd(i)=(we(i)-we(i-1))/(2*TeM(i));
end
wd(8)=(we(8)-we(7))/TeM(8);

%theta=Te*sigma(we(i))

theta=zeros(8,1);
sum=0;

for i=1:8
    sum=sum+we(i);
    theta(i)=TeM(i)*sum;
end

%% Question 14
figure(5)
plot(Te, theta)
xlabel('Time [sec]')
ylabel('Position')
grid on

figure(6)
plot(Te,wd)
xlabel('Time [sec]')
ylabel('Acceleration')
grid on

%% Question 15
theta_dft = fft(theta);
wd_dft = fft(wd);

figure(7)
stem(Te,abs(theta_dft)/N)
grid on
xlabel('Frequency [Hz]')
ylabel('DFT of theta')

figure(8)
stem(Te,wd_dft)
grid on
xlabel('Frequency [Hz]')
ylabel('DFT of omega dot')