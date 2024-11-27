#!/usr/bin/env wolframscript
(* ::Package:: *)


SetDirectory @ If[$FrontEnd === Null, DirectoryName[$InputFileName], NotebookDirectory[]];


<< AMFlow`


SetReductionOptions["IBPReducer" -> "FiniteFlow+LiteRed"]
AMFlowInfo["Family"] = phase17;
AMFlowInfo["Loop"] = {k1, k2};
AMFlowInfo["Leg"] = {pa, pb};
AMFlowInfo["Conservation"] = {};
AMFlowInfo["Replacement"] = {pa^2 -> msqr, pb^2 -> msqr, (pa + pb)^2 -> s};
AMFlowInfo["Propagator"] = {(k1)^2 - msqr, (k2)^2 - msqr, (k1 + k2 - pa - pb)^2 - msqr, (k1 + k2 - pb)^2 - msqr, (k1 - pb)^2 - msqr, (k1 - pa - pb)^2 - msqr, (k2 - pb)^2 - msqr};
AMFlowInfo["Numeric"] = {s -> 100, msqr -> 1};
AMFlowInfo["NThread"] = 16;
AMFlowInfo["Prescription"] = {0, 0};
AMFlowInfo["Cut"] = {1, 1, 1, 0, 0, 0, 0};


integrals = {j[phase17, 1, 1, 1, 0, 1, 1, 1], j[phase17, 1, 1, 1, 1, 1, 1, 1]};
precision = 20;
epsOrder = 4;
sol = SolveIntegrals[integrals, precision, epsOrder];


Export["phase17.txt", sol];
Exit[];

