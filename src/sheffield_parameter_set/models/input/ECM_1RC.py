"""
This code is adopted from the PyBaMM project under the BSD-3-Clause

Copyright (c) 2018-2024, the PyBaMM team.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"""


#
# Basic Reservoir Model
#
import pybamm

import numpy as np
import pybamm


# Helper functions
def OCV_func(soc, T):
    u_ref = pybamm.FunctionParameter(
        "Open-circuit voltage [V]", {"State of charge": soc, "Temperature [K]": T}
    )
    return u_ref


def T_amb_func(t):
    return pybamm.FunctionParameter("Ambient temperature [K]", {"Time [s]": t})


def I_app_func(t):
    return pybamm.FunctionParameter("Current function [A]", {"Time [s]": t})


def R0_func(soc, I, T):
    return pybamm.FunctionParameter(
        "R0 [Ohm]",
        {"State of charge": soc, "Current [A]": I, "Temperature [K]": T},
    )


def R1_func(soc, I, T):
    return pybamm.FunctionParameter(
        "R1 [Ohm]",
        {"State of charge": soc, "Current [A]": I, "Temperature [K]": T},
    )


def C1_func(soc, I, T):
    return pybamm.FunctionParameter(
        "C1 [F]",
        {"State of charge": soc, "Current [A]": I, "Temperature [K]": T},
    )


class ECM_1RC(pybamm.BaseModel):
    """
    Equivalent Circuit Model with 1 RC pair and lumped thermal model
    """

    def __init__(self):
        super().__init__(
            "Equivalent Circuit Model with 1 RC pair and lumped thermal model"
        )

        # Parameters
        self.param = pybamm.LithiumIonParameters()
        self.summary_variables = []

        # Variables
        soc = pybamm.Variable("State of charge")
        v1 = pybamm.Variable("First RC pair voltage [V]")
        T = pybamm.Variable("Temperature [K]")

        # Parameters
        t = pybamm.t
        I_app = I_app_func(t)
        OCV = OCV_func(soc, T)
        R0 = R0_func(soc, I_app, T)
        R1 = R1_func(soc, I_app, T)
        C1 = C1_func(soc, I_app, T)
        T_amb = T_amb_func(t)
        Q = pybamm.Parameter("Nominal cell capacity [A.h]")
        h = pybamm.Parameter("Heat transfer coefficient [W.m-2.K-1]")
        A = pybamm.Parameter("Surface area [m2]")
        m = pybamm.Parameter("Mass [kg]")
        c_p = pybamm.Parameter("Specific heat capacity [J.kg-1.K-1]")

        # State equations
        dsoc_dt = -I_app / (Q * 3600)
        dv1_dt = (I_app * R1 - v1) / (R1 * C1)
        dT_dt = (I_app**2 * R0 - h * A * (T - T_amb)) / (m * c_p)

        # Voltage equation
        V = OCV - I_app * R0 - v1

        # Add to model
        self.rhs = {soc: dsoc_dt, v1: dv1_dt, T: dT_dt}

        # Initial conditions
        soc_init = pybamm.Parameter("Initial SOC [%]")
        T_init = pybamm.Parameter("Initial temperature [K]")
        self.initial_conditions = {soc: soc_init / 100, v1: 0, T: T_init}

        # Variables
        self.variables = {
            "State of charge [%]": soc * 100,
            "Voltage [V]": V,
            "Current [A]": I_app,
            "Temperature [K]": T,
            "Open-circuit voltage [V]": OCV,
            "Series resistance voltage drop [V]": I_app * R0,
            "First RC pair voltage [V]": v1,
            # These variables are required by PyBaMM for experiments to work
            "State of charge": soc,
            "Current variable [A]": I_app,
            "Battery voltage [V]": V,
        }

        # Events
        self.events.append(
            pybamm.Event(
                "Minimum voltage [V]", V - pybamm.Parameter("Lower voltage cut-off [V]")
            )
        )
        self.events.append(
            pybamm.Event(
                "Maximum voltage [V]", pybamm.Parameter("Upper voltage cut-off [V]") - V
            )
        )


