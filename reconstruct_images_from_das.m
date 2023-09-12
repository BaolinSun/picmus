clear;
clc;

addpath(genpath('src'));

%-- Parameters
acquisition_type = 1;       %-- 1 = simulation || 2 = experiments || 3 in_vivo
phantom_type = 1;           %-- 1 = resolution & distorsion || 2 = contrast & speckle quality || carotid_cross || carotid_long
data_type = 2;              %-- 1 = IQ || 2 = RF


%-- Parsing parameter choices
switch acquisition_type    
    case 1
        acquisition = 'simulation';
        acqui = 'simu';
    case 2
        acquisition = 'experiments';
        acqui = 'expe';
    case 3
        acquisition = 'in_vivo';
        acqui = 'expe';
    otherwise       %-- Do deal with bad values
        acquisition = 'simulation';
        acqui = 'simu';        
end
switch phantom_type    
    case 1
        phantom = 'resolution_distorsion';
    case 2
        phantom = 'contrast_speckle';
    case 3
        phantom = 'carotid_cross';
    case 4
        phantom = 'carotid_long';
    otherwise       %-- Do deal with bad values
        phantom = 'resolution';
end
switch data_type    
    case 1
        data = 'iq';
    case 2
        data = 'rf';
    otherwise       %-- Do deal with bad values
        data = 'rf';        
end

%-- Create path to load corresponding files
path_dataset = ['database/',acquisition,'/',phantom,'/',phantom,'_',acqui,'_dataset_',data,'.hdf5'];
path_scan = ['database/',acquisition,'/',phantom,'/',phantom,'_',acqui,'_scan.hdf5'];
path_reconstruted_img = ['reconstructed_image/',acquisition,'/',phantom,'/',phantom,'_',acqui,'_img_from_',data,'.hdf5'];


%-- Read the corresponding dataset and the region where to reconstruct the image
dataset = us_dataset();
dataset.read_file(path_dataset);
scan = linear_scan();
scan.read_file(path_scan);

%-- Indices of plane waves to be used for each reconstruction
% pw_indices{1} = 38;
% pw_indices{2} = round(linspace(1,dataset.firings,3));
% pw_indices{3} = round(linspace(1,dataset.firings,11));
pw_indices{4} = round(1:dataset.firings);               %-- dataset.firings corresponding to the total number of emitted steered plane waves

%-- Reconstruct Bmode images for each pw_indices
disp(['Starting image reconstruction from ',acquisition,' for ',phantom,' using ',data,' dataset'])

image = das_rf(scan,dataset,pw_indices);

disp('Reconstruction Done')
disp(['Result saved in "',path_reconstruted_img,'"'])

%-- Show the corresponding beamformed images
dynamic_range = 60;
image.show(dynamic_range);
