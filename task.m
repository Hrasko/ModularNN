
%Adicionando todas as subpastas no path
addpath(genpath(cd));


IN.C(:,:,1) = FF;
IN.C(:,:,2) = FFDBN;
IN.C(:,:,3) = ELM;
IN.C(:,:,4) = ELMDBN;
IN.result = real;
%G = [0.3782 0.2076 0.5748]
%G = [0.33 0.33 0.33];
G = [0.3509 0.6541 0.1389 0.6033];
ag = agregaEntradas (G,IN.C);

opt.tipo = 0;
opt.intervalInit = [0 1];
opt.maxIter = 100;
opt.IN = IN;

%resultado = DEvolution (15,4,opt);
