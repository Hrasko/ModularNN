%Australia monthly production of electricity.
%Jan 1956 - August 1995
%Data are given in gigawatt hours (GWh)
energy_aus = dlmread ('energy_aus.txt');

% The North Atlantic Oscillation (NAO) is a large scale oscillation in atmospheric mass between the subtropical high presure and the polar low presure. The corresponding index varies from year to year, but also exhibits a tendency to remain in one phase for intervals lasting several years. This index is  traditionally defined as the normalized pressure difference between a station on the Azores and one on Iceland
% The positive phase of the NAO reflects below-normal pressure across the high latitudes of the North Atlantic and above-normal pressure over the central North Atlantic, the eastern United States and western Europe. The negative phase reflects an opposite pattern of pressure anomalies over these regions. Both phases of the NAO are associated with basin-wide changes in the intensity and location of the North Atlantic jet stream and storm track, and in large-scale modulations of the normal patterns of zonal and meridional heat and moisture transport [Hur95], which in turn results in changes in temperature and precipitation patterns often extending from eastern North America to western and central Europe. 
% More information about NAO can be found at:
%North Atlantic Oscillation (NAO)
%Jan 1950 - Jul 2005
NAO = dlmread ('NAO.txt');

%US Dollars per British Pound (libras) rate, taken each month since January 1981 till July 2005
dolar_to_libra = dlmread ('dolar_libra.txt');

%Iris dataset classification
%IN = 4x150 matrix of four attributes of 1000 flowers
%OUT = 3x150 matrix of 1000 associated class vectors
[irisIN irisOUT] = iris_dataset;

%Wine dataset classification
%IN = 13x178 matrix of thirteen attributes of 178 wines
%OUT = 3x178 matrix of 7200 associated class vectors
[wineIN wineOUT] = wine_dataset;

%Cancer dataset classification
%IN = 9x699 matrix defining nine attributes of 699 biopsies
%OUT = 2x966 matrix where each column indicates a correct category
% (1-Benign,2-Malignant)
[cancerIN cancerOUT] = cancer_dataset;


%Carregando a base fictícia
base_ficticia_full = dlmread ('base_ficticia.txt');
base_result = base_ficticia_full (1:3,:);
c1_result = base_ficticia_full (4:6,:);
c2_result = base_ficticia_full (7:9,:);



