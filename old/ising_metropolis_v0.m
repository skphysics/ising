%% Doruk Efe G?kmen -- 15/02/2018 -- Ankara
%% The simulation of 2D Ising model using the Metropolis algorithm
%Physical parameters:
J=1; %exchange constant (joules) 
temp=0.45; %k*T/J (unitless temperature)
T=2*J / log(1+sqrt(2));%J*temp; %k*temperature (joules)
%System size:
N=64; %NxN square grid
time=100000; %number of time steps

p=0.7; %initial Boltzmann factor
S=-1*ones(N,N); %initial spin matrix (all spins down)
for i=2:N-1
    for j=2:N-1
        %calculate the initial energy
        E_t=E_t-J*(S(i,j)*S(i+1,j)+S(i,j)*S(i-1,j)...
            +S(i,j)*S(i,j+1)+S(i,j)*S(i,j-1)); %nearest neighbour interaction
    end
end

for t=1:time
    E=E_t; %update the energy
    E_t=0; %reset the energy
    %generate two random numbers ii & jj here to swap (ii,jj)'th random spin
    r=randi(N-1,2,2);
   for i=2:N-1
       for j=2:N-1
           %(periodic boundaries here ?)
           St=S(r(1),r(2)); %choose the random spin
           S(r(1),r(2))=-St; %flip the random spin
           %calculate the new energy
           E_t=E_t-J*(S(i,j)*S(i+1,j)+S(i,j)*S(i-1,j)...
               +S(i,j)*S(i,j+1)+S(i,j)*S(i,j-1)); %nearest neighbour interaction
       end
   end
   for i=2:N-1
       for j=2:N-1
           if E_t<E
               %keep the spin flipped if that lowers the energy
               S(r(1),r(2))=-St;
           else
               delta_E=E_t-E;
               p=exp(-delta_E/T); %update Boltzmann factor (probability)
               %if that increases the energy, then flip the spin with probability,
               %supressed by the corresponding boltzmann factor p=exp(-delta_E/T)
               x=rand;
               if x<p
                   S(r(1),r(2))=St;
               else
                   S(r(1),r(2))=-St;
               end
           end
           %calculate the new energy
           E_t=E_t-J*(S(i,j)*S(i+1,j)+S(i,j)*S(i-1,j)...
               +S(i,j)*S(i,j+1)+S(i,j)*S(i,j-1));
       end
   end 
   %Plot the current spin grid
   pause(0.0001)
   [r, c] = size(S);                          % Get the matrix size
   clf;
   imagesc((1:c)+0.5, (1:r)+0.5, S)        % Plot the image
   colormap(gray);                              % Use a gray colormap
   axis equal                                   % Make axes grid sizes equal
   set(gca, 'XTick', 1:(c+1), 'YTick', 1:(r+1), ...  % Change some axes properties
       'XLim', [1 c+1], 'YLim', [1 r+1], ...
       'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');
end