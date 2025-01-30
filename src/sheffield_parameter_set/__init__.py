"""
Copyright (c) 2025 Nikilesh Ramesh. All rights reserved.

SheffieldParameterSet: ECM parameter set from University of Sheffield
"""
from __future__ import annotations
from importlib.metadata import version

__version__ = version("SheffieldParameterSet")

import pybamm
from sheffield_parameter_set.entry_point import Model, parameter_sets, models

__all__: list[str] = [
    "__version__",
    "pybamm",
    "parameter_sets",
    "Model",
    "models",
]
