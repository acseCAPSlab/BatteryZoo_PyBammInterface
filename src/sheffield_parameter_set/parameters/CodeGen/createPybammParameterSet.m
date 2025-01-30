function createPybammParameterSet(data, idx, namingConvention)

% Create a new folder to put all the parameter set files into
newFolderDirectoryName = "parameterSetPybamm";
[status, msg] = mkdir(newFolderDirectoryName);
if status == 0
    fprintf("\n %s \n", msg) % currently doesn't throw an error maybe use assert?
end

newFileName = namingConvention(idx);
% batt_id = int2str(idx);
% newFilePath = append(newFolderDirectoryName, "/", newFileName, batt_id, ".py");
newFilePath = append(newFolderDirectoryName, "/", newFileName, ".py");

% list of functions need to be created 
simpleFuncNameList = ["ocv", "r0", "r1", "c1", "dUdT"];

funcInputStruct.(simpleFuncNameList(1)) = "sto";
funcInputStruct.(simpleFuncNameList(2)) = ["T_cell", "current", "soc"];
funcInputStruct.(simpleFuncNameList(3)) = ["T_cell", "current", "soc"];
funcInputStruct.(simpleFuncNameList(4)) = ["T_cell", "current", "soc"];
funcInputStruct.(simpleFuncNameList(5)) = ["ocv","T_cell"];

file = fopen(newFilePath, "w");
createPybammSetupCode(file, []);
for i = 1:length(simpleFuncNameList)
    createPybammFunctionTemplate(file, simpleFuncNameList(i), funcInputStruct);
end
fprintf(file, "\n\n");
createPybammParameterValueFunction(file,data,idx);
fclose(file);

end