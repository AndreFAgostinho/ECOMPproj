
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name Calculadora -dir "E:/EComp/Calculadora/ISE/planAhead_run_3" -part xc3s100ecp132-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "E:/EComp/Calculadora/ISE/xtop.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {E:/EComp/Calculadora/ISE} }
set_property target_constrs_file "E:/EComp/Calculadora/Code/xilinx/14.7/picoversat/xtop.ucf" [current_fileset -constrset]
add_files [list {E:/EComp/Calculadora/Code/xilinx/14.7/picoversat/xtop.ucf}] -fileset [get_property constrset [current_run]]
link_design
