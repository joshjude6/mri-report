function [Mn, params, M0, Kn, K0]=phantom_parallel(I,coils,Sigma,rho)

% PHANTOM_PARALLEL: Simulates a multiple coil adquisition of a synthetic MR image
%
% INPUTS:
%	    I:        Input image. If I=0, the default image is used
%		      (A noise free MR slice from BrainWeb)
%		      Recomended Size 256x256	
%	    coils:    Number of acquisition coils
%           Sigma:    Coils covariance matrix
%	              if size(Sigma)=1x1  Sigma=variance of noise
%                     if size(Sigma)=(coils)x(coils) Sigma=covariance matrix
%           rho:      correlation coefficient between coils [0-1]
%                     If size(Sigma)>1 rho it is not used.
%                     otherwise:
%                           Covariance Matrix=Sigma*(eye(coils) +rho*(1-eye(coils))
%           
% OUTPUT
%             Mn:       Composite magnitude image (noisy)
%             M0:       Composite Magnitude image (non noisy, non accelerated)
%             Kn:       Original k space (noisy)
%             K0:       Original k space (non noisy, non accelerated)
%             params:   Other parameters
%                       params.Sigma:  covariance matrix
% Modified from S.Aja-Fernandez, LPI, only for teaching purpose

addpath common

if length(I)==1
	I=double(imread('mri.png'));
	I=I(2:end-1,2:end-1); %We force size 256x256
end

%1-- Simulation of coil sensitivity ----

[Mx,My]=size(I);	
MapW=sensitivity_map([Mx,My],coils); %Sensitivity Map
It=repmat(I,[1,1,coils]).*MapW;



%2 Gaussian Noise in each coil---------------------------------
corr=0;
if (length(Sigma)>1)||(rho>0)
   corr=1;
end

if corr==0
	%No correlation between coils
	sigma=sqrt(Sigma); %Sigma: varianza of noise (sigma^2)
	Int=It+sigma.*(randn(size(It))+j.*randn(size(It)));
        params.Sigma=Sigma.*eye(coils);
else
	%correlation between coils
        if length(Sigma)==1
	  s1=Sigma; %s1=sigma^2
	  Sigma=s1.*(eye(coils)+rho.*(ones(coils)-eye(coils)));  % Matriz de covarianza
        end
	Nc=randn([Mx,My,coils])+j.*randn([Mx,My,coils]);	
   	[V,D] = eig(Sigma);
   	W = V*sqrt(D);
   	for ii=1:Mx
   	for jj=1:My
		Nc2(ii,jj,:)=W*(squeeze(Nc(ii,jj,:)));
   	end
   	end
        params.Sigma=Sigma;
        [params.Leff,params.s2_eff]=effec_params_NCCHI(It,params.Sigma);
	Int=It+Nc2;
end

ML=sos(Int); 	%Noisy Composite Magnitude Signal
ML0=sos(It); 	%Noise-free Composite Magnitude Signal

%3- K Space------------------------------------------

SN=x2k(Int); %Fully sampled noisy
S0=x2k(It);  %Fully sampled without noise
Mn=ML; %Non Parallel output
Kn=SN;
K0=S0;
M0=ML0;




