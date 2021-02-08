%% This is the application resource file (.app file) for the 'base'
%% application.
{application, balcony_hw_unit_test,
[{description, "balcony_hw_unit_test  " },
{vsn, "1.0.0" },
{modules, 
	  [balcony_hw_unit_test_app,balcony_hw_unit_test_sup,balcony_hw_unit_test]},
{registered,[balcony_hw_unit_test]},
{applications, [kernel,stdlib]},
{mod, {balcony_hw_unit_test_app,[]}},
{start_phases, []}
]}.
