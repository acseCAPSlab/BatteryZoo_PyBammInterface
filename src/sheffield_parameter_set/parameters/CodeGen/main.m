%{
Code generation for PyBamm templates using the database
%}

clear;



%% MAKE SURE TO DELETE THE DATA FOLDER BEFORE RUNNING FOR NOW
% testing data reformattting code 
load("data.mat")

namingConvention = strings(size(data));
trackNames = strings;
trackIdx = [0];
for i=1:length(namingConvention)
    
    name = data(i).chemistry;
    if isempty(trackNames)
        namingConvention(i) = sprintf("%s_1",name);
        trackNames = [trackNames, name];
        trackIdx = [trackIdx, 1];
    elseif ~ismember(name, trackNames)
        namingConvention(i) = sprintf("%s_1",name);
        trackNames = [trackNames, name];
        trackIdx = [trackIdx, 1];            
    else
        idx = find(name==trackNames,1);
        trackIdx(idx) = trackIdx(idx) + 1;
        namingConvention(i) = sprintf("%s_%d",name,trackIdx(idx));

    end
end

for idx = 1:max(size(data))
    reformattingDataFromDatabase(data, idx , namingConvention)
end

%% File creation test
for idx = 1:max(size(data))
    createPybammParameterSet(data,idx, namingConvention)
end

fclose("all"); % need this to free the created files from MATLAB though I call close inside the fucntion