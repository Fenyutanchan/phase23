#!/usr/bin/env wolframscript
(* ::Package:: *)


SetDirectory @ If[$FrontEnd === Null, DirectoryName[$InputFileName], NotebookDirectory[]];


<< AMFlow`


SetReductionOptions["IBPReducer" -> "FiniteFlow+LiteRed"]
AMFlowInfo["Family"] = phase28;
AMFlowInfo["Loop"] = {k1, k2};
AMFlowInfo["Leg"] = {pa, pb};
AMFlowInfo["Conservation"] = {};
AMFlowInfo["Replacement"] = {pa^2 -> 0, pb^2 -> 0, (pa + pb)^2 -> s};
AMFlowInfo["Propagator"] = {(k1)^2 - 0, (k2)^2 - 0, (k1 + k2 - pa - pb)^2 - 0, (k1 + k2)^2 - 0, (k1 + k2 - pa)^2 - 0, (k2 - pb)^2 - 0, (k2 - pa - pb)^2 - 0};
AMFlowInfo["Numeric"] = {s -> 100};
AMFlowInfo["NThread"] = 4;
AMFlowInfo["Prescription"] = {0, 0};
AMFlowInfo["Cut"] = {1, 1, 1, 0, 0, 0, 0};


integrals = {j[phase28, 1, 1, 1, 1, 0, 1, 1], j[phase28, 1, 1, 1, 1, 1, 1, 1], j[phase28, 1, 1, 1, 0, 0, 1, 2], j[phase28, 1, 1, 1, 0, 0, 2, 2]};
precision = 20;
epsOrder = 4;
sol = SolveIntegrals[integrals, precision, epsOrder];


Export["phase28.txt", sol];
Exit[];

