; 19 constraints

(define (problem roverprob3726)
(:domain rover)
(:objects general - lander colour - mode high_res - mode low_res - mode
rover0 - rover rover1 - rover rover0store - store rover1store - store
waypoint0 - waypoint waypoint1 - waypoint waypoint2 - waypoint
waypoint3 - waypoint camera0 - camera camera1 - camera objective0 -
objective objective1 - objective)
(:init (visible waypoint0 waypoint1) (visible waypoint1 waypoint0)
(visible waypoint0 waypoint3) (visible waypoint3 waypoint0)
(visible waypoint1 waypoint2) (visible waypoint2 waypoint1)
(visible waypoint1 waypoint3) (visible waypoint3 waypoint1)
(visible waypoint2 waypoint0) (visible waypoint0 waypoint2)
(visible waypoint3 waypoint2) (visible waypoint2 waypoint3)
(at_rock_sample waypoint0) (at_rock_sample waypoint1)
(at_soil_sample waypoint2) (at_rock_sample waypoint2)
(at_lander general waypoint0) (channel_free general)
(at rover0 waypoint1) (available rover0) (store_of rover0store rover0)
(empty rover0store) (equipped_for_soil_analysis rover0)
(equipped_for_rock_analysis rover0) (equipped_for_imaging rover0)
(can_traverse rover0 waypoint1 waypoint0)
(can_traverse rover0 waypoint0 waypoint1)
(can_traverse rover0 waypoint1 waypoint3)
(can_traverse rover0 waypoint3 waypoint1) (at rover1 waypoint3)
(available rover1) (store_of rover1store rover1) (empty rover1store)
(equipped_for_soil_analysis rover1)
(equipped_for_rock_analysis rover1) (equipped_for_imaging rover1)
(can_traverse rover1 waypoint3 waypoint0)
(can_traverse rover1 waypoint0 waypoint3)
(can_traverse rover1 waypoint3 waypoint2)
(can_traverse rover1 waypoint2 waypoint3)
(can_traverse rover1 waypoint0 waypoint1)
(can_traverse rover1 waypoint1 waypoint0) (on_board camera0 rover0)
(calibration_target camera0 objective1) (supports camera0 low_res)
(on_board camera1 rover1) (calibration_target camera1 objective0)
(supports camera1 colour) (supports camera1 high_res)
(supports camera1 low_res) (visible_from objective0 waypoint0)
(visible_from objective0 waypoint1)
(visible_from objective1 waypoint0)
(visible_from objective1 waypoint1))
(:goal
(and (communicated_soil_data waypoint2)
(communicated_rock_data waypoint0)
(communicated_image_data objective0 colour)))

(:constraints (and
(sometime-before (have_image rover1 objective0 colour) (at rover1 waypoint0))
(sometime-before (have_soil_analysis rover1 waypoint2) (full rover0store))
(sometime-before (have_image rover1 objective0 colour) (calibrated camera1 rover1))
(sometime (full rover1store))
(sometime (full rover0store))
(sometime-before (at rover1 waypoint2) (have_rock_analysis rover0 waypoint0))
(sometime-before (have_rock_analysis rover0 waypoint0) (full rover1store))
(sometime-before (at rover1 waypoint2) (full rover0store))
(sometime (calibrated camera1 rover1))
(sometime-before (have_image rover1 objective0 colour) (have_rock_analysis rover0 waypoint0))
(sometime-before (have_image rover1 objective0 colour) (full rover1store))
(at-most-once (empty rover0store))
(sometime (at rover1 waypoint1))
(sometime-before (have_rock_analysis rover0 waypoint0) (at rover1 waypoint0))
(sometime-before (have_rock_analysis rover0 waypoint0) (have_soil_analysis rover1 waypoint2))
(sometime-before (at rover1 waypoint2) (at rover0 waypoint0))
(sometime-before (have_soil_analysis rover1 waypoint2) (have_image rover1 objective0 colour))
(at-most-once (at rover1 waypoint3))
(sometime (at rover1 waypoint0))
))
)
