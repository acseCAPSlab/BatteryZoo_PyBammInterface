function createPybammParameterValueFunction(file, data, idx)
chem = sprintf("""%s""", data(1).chemistry);
init_SOC = sprintf("%f", table2array(data(idx).OCV_points(1,1)));
init_temp = 25 + 273.15;
cell_capacity = data(idx).capacity;
nominal_capacity = cell_capacity;


params.("chem") = ["chemistry", chem];
params.("init_SOC") = ["Initial SoC", init_SOC];
% EVERY OTHER VALUE MUST BE AMENDED
params.("init_temp") = ["Initial temperature [K]","25 + 273.15"];
params.("cell_capacity" ) = ["Cell capacity [A.h]","cell_capacity"];
params.("nominal_capacity") = ["Nominal cell capacity [A.h]","cell_capacity"];
params.("ambient_temp") = ["Ambient temperature [K]","25 + 273.15"];
params.("current_function") = ["Current function [A]","100"];
params.("UpperVoltageCutoff") = ["Upper voltage cut-off [V]","4.2"];
params.("LowerVoltageCutoff") = ["Lower voltage cut-off [V]","3.2"];
params.("Cellthermalmass") = ["Cell thermal mass [J/K]","1000"];
params.("Celljigheattransfercoefficient") = ["Cell-jig heat transfer coefficient [W/K]","10"];
params.("Jigthermalmass") = ["Jig thermal mass [J/K]","500"];
params.("Jigairheattransfercoefficient") = ["Jig-air heat transfer coefficient [W/K]","10"];
params.("Opencircuitvoltage") = ["Open-circuit voltage [V]","ocv"];
params.("R0") = ["R0 [Ohm]","r0"];
params.("Element1initialoverpotential") = ["Element-1 initial overpotential [V]","0"];
params.("R1") = ["R1 [Ohm]","r1"];
params.("C1") = ["C1 [F]","c1"];
params.("Entropicchange") = ["Entropic change [V/K]","dUdT"];
params.("RCRlookuplimit") = ["RCR lookup limit [A]","340"];


% 
% ambient_temp = 25+273.15;
% current_function = 100;
% UpperVoltageCutoff= 4.2;
% LowerVoltageCutoff= 3.2;
% Cellthermalmass= 1000;
% Celljigheattransfercoefficient= 10;
% Jigthermalmass= 500;
% Jigairheattransfercoefficien=10;
% Opencircuitvoltage = "ocv";
% R0 = "r0";
% Element1initialoverpotential= 0;
% R1 ="r1";
% C1 ="c1";
% Entropicchange = "dUdT";
% RCRlookuplimit= 340;

fprintf(file, "\ndef get_parameter_value():\n");
fprintf(file, "    values = {\n");
fields = fieldnames(params);
for i = 1:length(fields)-1
    fprintf(file, "        ""%s"" : %s,\n", params.(fields{i})(1), params.(fields{i})(2));
end
fprintf(file, "        ""%s"" : %s\n", params.(fields{end})(1), params.(fields{end})(2));
fprintf(file, "    }\n\n");
fprintf(file, "    return values");
end