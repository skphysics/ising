%% Doruk Efe Gokmen -- 18/02/2018 -- Ankara
%% The simulation of 2D Ising model using the Metropolis algorithm
%System parameters:
N=2^10; %NxN square grid
time=10^8; %number of time steps

%Physical parameters:
J=1; %exchange constant (joules)
kTc=2*2*J/log(1+sqrt(2)); %the critical temperature (Curie temperature)
kT=3*kTc;%high initial temperature (joules)
%reduced temperature (kT) is in units of the exchange constant (joule)

p=0.5; %initial Boltzmann factor
%S=-1*ones(N,N); %initial spin matrix (all spins down)
S=sign(p-rand(N,N)); %"random" initial spin matrix (according to p)

%Metropolis algorithm:
for t=1:time
    %generate two random numbers ii & jj here to swap (ii,jj)'th random spin
    r=randi(N,1,2); %2 random integers between 1 & N
    ii=r(1); jj=r(2); %save column (ii) and row (jj) indices
    %find its nearest neighbors (periodic boundary conditions)
    above = mod(jj - 1 - 1, size(S,1)) + 1;
    below = mod(jj + 1 - 1, size(S,1)) + 1;
    left  = mod(ii - 1 - 1, size(S,2)) + 1;
    right = mod(ii + 1 - 1, size(S,2)) + 1;  
    St=S(ii,jj); %choose a random spin    
    %calculate the energy component if that spin is flipped
    E_t=-J*(-St)*(S(right,jj)+S(left,jj)...
        +S(ii,above)+S(ii,below));
    if E_t<0
        %flip the spin if that reduces the energy
        S(ii,jj)=-St;
    else
        %if that increases the energy, then flip the spin with probability,
        %supressed by the corresponding boltzmann factor p=exp(-delta_E/T)
        delta_E=2*E_t; %energy change due to the flip
        p=exp(-delta_E/kT); %update Boltzmann factor (probability)
        x=rand; %uniform random variable
        if x<p
            S(ii,jj)=-St;
        else
            S(ii,jj)=St;
        end
    end
    %Plot the current spin grid:
    if rem(t,200)==0 %plot each 10 frame
        pause(0.0001)
        [r,c]=size(S); %get the matrix size
        clf; %clear figure to reset previous image for efficiency
        imagesc((1:c)+0.5,(1:r)+0.5,S) %plot the image
        colormap(gray); %use a gray colormap
        axis equal %make axes grid sizes equal
        set(gca, 'XTick',1:(c+1),'YTick',1:(r+1), ...
            'XLim',[1 c+1],'YLim',[1 r+1], ...
            'GridLineStyle','-','XGrid','on','YGrid','on');
        x0=300; %lateral canvas location on screen
        y0=400; %vertical canvas location on screen
        width=700; %lateral canvas size
        height=700; %vertical canvas size
        set(gcf,'units','points','position',[x0,y0,width,height]);
        
        %Quenching around the critical point (to see the phase transition):
        if t==3000
            kT=kTc; %abruptly reduce the temperature to the critical value
        elseif t==8000
            kT=0.2*kT; %afterwards, abruptly reduce the it even further
        end
    end
end