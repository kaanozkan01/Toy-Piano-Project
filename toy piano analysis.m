% -------------------------------------------------------------------------
% Module Project III - Toy Piano Analysis
% Group 15: Kaan Özkan, Erkut Doğan, Furkan Hatipoğulları
% -------------------------------------------------------------------------
% Description: 
% This script models the behavior of the 555 timer square wave generator 
% and compares theoretical frequencies with the resistor ladder design.
% -------------------------------------------------------------------------

clear
clc
close all

%% 1. Component Values and Definitions
RA = 1e3;           % Fixed resistor R1 (Ohm)
C  = 100e-9;        % Timing capacitor (Farad)
Rseries = 10e3;     % Base series resistor (Ohm)

% Musical Note Names
noteNames = {'Do','Re','Mi','Fa','Sol','La','Si','Do_high'};

% Resistor values added for each step (The Ladder)
R_note = [2200 2200 1000 2200 1500 1500 680];

%% 2. Calculate Effective Resistances and Frequencies
RB_ladder = zeros(size(R_note));

% Calculate cumulative resistance for the ladder
for i = 1:length(R_note)
    RB_ladder(i) = sum(R_note(i:end));
end

% Total R2 for each button press
RB_eff = Rseries + RB_ladder;

% 555 Timer Astable Frequency Formula: f = 1.44 / ((RA + 2*RB) * C)
f7 = 1.44 ./ ((RA + 2 .* RB_eff) .* C);

% Adding the high octave Do (approx 2x frequency of the first note for viz)
f_theory = [f7 2*f7(1)]; 
RB_report = [RB_eff NaN]; % Padding for table display

%% 3. Display Theoretical Results
disp('------------------------------------------------')
disp('      Theoretical Frequency Calculations        ')
disp('------------------------------------------------')
disp(table(noteNames', RB_report', f_theory', ...
    'VariableNames', {'Note','RB_effective_ohm','f_theoretical_Hz'}))

%% 4. Signal Generation and Simulation Plot
% Select a note to simulate (k=1 corresponds to the first note in the array)
k = 1; 
f0 = f_theory(k);

% 555 Timer Output Levels (Approximate)
V_low  = 0.15;  % Low state voltage
V_high = 8.70;  % High state voltage (Assuming Vcc=9V with drops)

% Duty Cycle Calculation
if k <= 7
    duty_theory = (RA + RB_eff(k)) / (RA + 2*RB_eff(k));
else
    duty_theory = 0.5;
end

% Simulation Parameters
fs = 5e6;              % Sampling frequency (high for resolution)
t_div = 200e-6;        % Oscilloscope time division
v_div = 2;             % Voltage division
t_scope = 10 * t_div;  % Total time to plot
T0 = 1/f0;             % Period
t_total_calc = max(3.2*T0, t_scope);
t = 0:1/fs:t_total_calc;

% Generate Ideal Square Wave
x01 = mod(t * f0, 1) < duty_theory;
x = V_low + (V_high - V_low) .* x01;

% Add Slew Rate (Transient effect simulation)
tr = 3e-6; % Rise time
tf = 3e-6; % Fall time
Ntr = max(1, round(tr * fs));
Ntf = max(1, round(tf * fs));
x = filter(ones(1,Ntr)/Ntr, 1, x);
x = filter(ones(1,Ntf)/Ntf, 1, x);

% Add Noise (Simulating real-world conditions)
noise_rms = 0.03;
x = x + noise_rms .* randn(size(x));

% Estimate Frequency from Generated Signal
edges = find(diff(x01) == 1);
if length(edges) >= 3
    periods = diff(t(edges));
    f_est = 1 / mean(periods(1:end));
elseif length(edges) >= 2
    f_est = 1 / (t(edges(2)) - t(edges(1)));
else
    f_est = NaN;
end

% Calculate Signal Properties
Vpp = max(x) - min(x);
duty_est = mean(x01);
Vmid = (V_high + V_low) / 2;
x_centered = x - Vmid;
Vpp_centered = max(x_centered) - min(x_centered);

% Print Estimated Values
fprintf('\n--- Simulation Results for Note: %s ---\n', noteNames{k});
fprintf('Theoretical frequency: %.2f Hz\n', f0);
fprintf('Estimated frequency:   %.2f Hz\n', f_est);
fprintf('Vpp (DC):              %.2f V\n', Vpp);
fprintf('Duty Cycle (Theory):   %.2f %%\n', duty_theory*100);

%% 5. Plotting (Oscilloscope View)
t_plot = t(t <= t_scope);
x_plot = x(t <= t_scope);
xc_plot = x_centered(t <= t_scope);

% Figure 1: DC Coupled Scope View
figure
plot(t_plot*1e3, x_plot, 'LineWidth', 1.2, 'Color', [0 0.4470 0.7410])
grid on
xlabel('Time (ms)')
ylabel('Voltage (V)')
title(['Scope-scaled waveform (DC) - ' noteNames{k}])
xlim([0 t_scope*1e3])
xticks((0:t_div:t_scope)*1e3)
yticks(-2:v_div:12)
ylim([-2 12])

% Figure 2: Centered (AC Coupled equivalent) View
figure
plot(t_plot*1e3, xc_plot, 'LineWidth', 1.2, 'Color', [0.8500 0.3250 0.0980])
grid on
xlabel('Time (ms)')
ylabel('Voltage (V)')
title(['Scope-scaled waveform (Centered) - ' noteNames{k}])
xlim([0 t_scope*1e3])
xticks((0:t_div:t_scope)*1e3)
yticks(-6:v_div:6)
ylim([-6 6])

% Display Stats on Plot
text(0.60*t_scope*1e3, 4.5, ...
    sprintf('f = %.2f Hz\nVpp = %.2f V\nDuty = %.2f %%', ...
    f_est, Vpp_centered, duty_est*100), ...
    'BackgroundColor','w','EdgeColor','k');
