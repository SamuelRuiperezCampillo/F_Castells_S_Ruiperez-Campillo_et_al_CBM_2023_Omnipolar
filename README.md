# F_Castells_S_Ruiperez-Campillo_et_al_CBM_2023_Omnipolar
These repository contains the functions that compute the simulations and analysis of the omnipolar electrograms in high density catheters, corresponding to the publication: F. Castells, S. Ruipérez-Campillo et al., Computers in Biology and Medicine, 2023

Any individual benefiting from any of this code must cite the work as: F. Castells, S. Ruiperez-Campillo, I. Segarra, R. Cervig ́on, R. Casado-Arroyo, J. Merino, J. Millet, Performance assessment of electrode configurations for the estimation of omnipolar electrograms from high density arrays, Computers in Biology and Medicine (2023). Please read the description below for usage instructions.

-------------------------------------------------------------------------------
This package has been designed with the following objectives:
1. Generate synthetic plane wavefront propagation.
2. Compute bipolar EGM and propagation angle.
3. Compute omnipolar EGM and its amplitude.
4. Obtain Local Activation Time (LAT)

For each objective, this description and files apply:


Objective 1.

  Brief description: Generate simulations of plane wavefront propagation...

  Step 1. To get synthetic propagtion execute the following function with especified parameters:
      [synthetic_propagation, reference_LATs] = generate_synthetic_propagation(u_egm, vc, propagation_angle, fs, d, n_rows, n_columns, compute_reference_LAT, coordinates, LAT_map)

  Step 2. If you want to cut the egm array, you can specify the aprox duration of a beat.
      [egm_cutted, t_start, t_end] = extract_beat(egm,duration,fs)

  Function files used: generate_synthetic_propagation.m, extract_beat.m




Objective 2.

  Step 1. To get bipolar EGM execute:
      b_egm = compute_b_egm(u_egm,n_rows,n_columns,mode)

  Step 2. To get angle estimation of wave propagation you should use:
      angle_estimation = compute_angle_estimation(b_egm, n_rows, n_columns)

  Function files used: compute_b_egm.m, compute_angle_estimation.m




Objective 3.

  Step 1. To get omnipolar EGM execute:
          o_egm_cross = compute_o_egm(b_egm_cross,angle*ones(1,number_of_cliques),n_rows,n_columns);

  Step 1. To get peak amplitude of omnipolar EGM execute:
          amplitude = compute_amplitude(o_egm_cross, n_rows,n_columns);

  Function files used: compute_o_egm.m, compute_amplitude.m
  



Objective 4.

  Step 1. To get the local activation time (LAT) of recorded signal:
          lats = get_lats_multiple_methods(egm, fs, mode)

  Function files used: compute_b_egm.m, get_lats_multiple_methods.m
