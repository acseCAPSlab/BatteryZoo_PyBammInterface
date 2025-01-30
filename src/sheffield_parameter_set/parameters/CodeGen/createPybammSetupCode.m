function createPybammSetupCode(file, dataFileNames)
fprintf(file, "import pybamm \n");
fprintf(file, "import os \n\n");
fprintf(file, "path, _ = os.path.split(os.path.abspath(__file__))\n\n");
fprintf(file, "ocv_data = pybamm.parameters.process_1D_data(""ecm_example_ocv.csv"", path=path)\n\n");
fprintf(file, "r0_data = pybamm.parameters.process_3D_data_csv(""ecm_example_r0.csv"", path=path)\n");
fprintf(file, "r1_data = pybamm.parameters.process_3D_data_csv(""ecm_example_r1.csv"", path=path)\n");
fprintf(file, "c1_data = pybamm.parameters.process_3D_data_csv(""ecm_example_c1.csv"", path=path)\n\n");
fprintf(file, "dUdT_data = pybamm.parameters.process_2D_data_csv(""ecm_example_dudt.csv"", path=path)\n\n");
end