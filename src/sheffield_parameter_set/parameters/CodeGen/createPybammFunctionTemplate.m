function createPybammFunctionTemplate(file, funcName, inputStruct)
    
inputParams = inputStruct.(funcName);

if length(inputParams) == 1
    fprintf(file, "def %s(%s):\n", funcName,inputParams);
    fprintf(file, "    name, (x, y) = %s_data\n",funcName);
    fprintf(file, "    return pybamm.Interpolant(x, y, %s, name)\n\n", inputParams);
end

if length(inputParams) == 2
    fprintf(file, "def %s(%s, %s):\n", funcName,inputParams(1), inputParams(2));
    fprintf(file, "    name, (x, y) = %s_data\n",funcName);
    fprintf(file, "    return pybamm.Interpolant(x, y, [%s, %s], name)\n\n", inputParams(1), inputParams(2));
end

if length(inputParams) == 3
    fprintf(file, "def %s(%s, %s, %s):\n", funcName,inputParams(1), inputParams(2), inputParams(3));
    fprintf(file, "    name, (x, y) = %s_data\n",funcName);
    fprintf(file, "    return pybamm.Interpolant(x, y, [%s, %s, %s], name)\n\n", inputParams(1), inputParams(2), inputParams(3));
end

end