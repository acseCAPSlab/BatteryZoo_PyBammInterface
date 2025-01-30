import pybamm
import os




def ocv_interp_func(soc, T, selected_battery):
    path, _ = os.path.split(os.path.abspath(__file__))
    data_file_path = "../data/" + selected_battery + "/ocv_data.csv"
    ocv_data = pybamm.parameters.process_1D_data(data_file_path, path=path)
    theta = ocv_data[:, 0]
    U = ocv_data[:, 1]

    return pybamm.Interpolant(theta, U, soc, name="OCV", entries_string="OCV")

def get_parameter_values(selected_battery):
    path, _ = os.path.split(os.path.abspath(__file__))
    data_file_path = "../data/" + selected_battery + "/constants.csv"
    constants = pybamm.parameters.process_1D_data(data_file_path, path=path)
    capacity = constants[0]
    R0 = constants[1]
    R1 = constants[2]
    C1 = constants[3]
    parameter_values = pybamm.ParameterValues(
        {
            "Nominal cell capacity [A.h]": capacity,
            "Initial SOC [%]": 100,
            "Initial temperature [K]": 298.15,
            "Ambient temperature [K]": 298.15,
            "Open-circuit voltage [V]": ocv_interp_func(selected_battery=selected_battery),
            "Lower voltage cut-off [V]": 2.5,
            "Upper voltage cut-off [V]": 4.2,
            "Heat transfer coefficient [W.m-2.K-1]": 100,
            "Surface area [m2]": 1,
            "Mass [kg]": 1,
            "Specific heat capacity [J.kg-1.K-1]": 1000,
            "R0 [Ohm]": R0,
            "R1 [Ohm]": R1,
            "C1 [F]": C1,
            "Current function [A]": 1,
            # These parameters are not used in the model, but are required by PyBaMM
            # because of the way experiments are defined
            "Number of electrodes connected in parallel to make a cell": 1,
            "Number of cells connected in series to make a battery": 1,
            "Electrode width [m]": 1,
            "Electrode height [m]": 1,
        }
    )

    return parameter_values
