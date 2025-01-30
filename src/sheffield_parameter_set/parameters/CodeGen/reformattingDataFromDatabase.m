function reformattingDataFromDatabase(data, idx, namingConvention) 
%idx = 1; % INCLUDE THIS AS FUNCITON INPUT TO SELECT WHICH BATTERY DATA TO READ

% Non-array/matrix type data [MAYBE HANDLE THIS ELSEWHERE]
chemistry = data(idx).chemistry;
capacity = data(idx).capacity; %Double check if it is Q or capacity variable
r0_const = data(idx).R0;
r1_const = data(idx).R1;
c1_const = data(idx).C1;
const = [capacity; r0_const; r1_const; c1_const];



% Load the data from the database and convert to matrix
r0_data = data(idx).R0_SOC; % ADD TEMP AND CURRENT
r1_data = data(idx).R1_SOC; % ADD TEMP AND CURRENT
c1_data = data(idx).C1_SOC; % ADD TEMP AND CURRENT
c2_data = data(idx).C2_SOC;
ocv_data = data(idx).OCV_points;
ocv_coeff_data = data(idx).OCV_coeff'; %Transposing to a column matrix for csv format

% Create a new folder to put all the data into
newFolderDirectoryName = "data";
newDataDirectoryName = namingConvention(idx);
% batt_id = int2str(idx);
% newDataDirectory = append(newFolderDirectoryName, "/", newDataDirectoryName, batt_id);
newDataDirectory = append(newFolderDirectoryName, "/", newDataDirectoryName);
[status, msg] = mkdir(newDataDirectory);

if status == 0
    fprintf("\n %s \n", msg) % currently doesn't throw an error maybe use assert?
end

% Create file names with the path for writing data into them 
r0_path = append(newDataDirectory, "/r0_data.csv");
r1_path = append(newDataDirectory, "/r1_data.csv");
c1_path = append(newDataDirectory, "/c1_data.csv");
c2_path = append(newDataDirectory, "/c2_data.csv");
ocv_path = append(newDataDirectory, "/ocv_data.csv");
ocv_coeff_path = append(newDataDirectory, "/ocv_coeff_data.csv");
const_path = append(newDataDirectory, "/constants.csv");

writematrix(const, const_path);
% Write the data into csv files using writematrix 
if istable(r0_data)
    writetable(r0_data,r0_path);
end
if istable(r1_data)
    writetable(r1_data,r1_path);
end
if istable(c1_data)
    writetable(c1_data,c1_path);
end
if istable(c2_data)
    writetable(c2_data,c2_path);
end
if istable(ocv_data)
    writetable(ocv_data,ocv_path);
end
if ismatrix(ocv_coeff_path) 
    writematrix(ocv_coeff_data,ocv_coeff_path); %remember: writematrix does not have col headers
end



end