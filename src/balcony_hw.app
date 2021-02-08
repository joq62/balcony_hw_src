%% This is the application resource file (.app file) for the 'base'
%% application.
{application, balcony_hw,
[{description, "balcony_hw  " },
{vsn, "1.0.0" },
{modules, 
	  [balcony_hw_app,balcony_hw_sup,balcony_hw,temp,heather]},
{registered,[balcony_hw]},
{applications, [kernel,stdlib]},
{mod, {balcony_hw_app,[]}},
{start_phases, []}
]}.
