% Mastralexi Christina Maria
% AEM 9284
% Genetic Algorithm Based PID Controller Tuning
% Main script
%%
clc;
clf;
close all;
clear all;

numberOfVariables = 6;
PopSize = 100;
MaxGenerations = 200;

options = optimoptions('ga','PopulationSize',PopSize,'MaxGenerations',MaxGenerations,'PlotFcn', @gaplotbestf,'MaxStallGenerations',inf,'FunctionTolerance',0);
% K = [99; 99; 9; 9; 99; 99;];
[x,fval] = ga(@(K)fitness_function(K),numberOfVariables,[],[],[],[],zeros(6,1),[99;99;9;9;99;99],[],options)