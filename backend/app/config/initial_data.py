INITIAL_DATA = {
    'country': [
        {'id': 1, 'name': 'Morocco'},
        {'id': 2, 'name': 'Mozambique'},
        {'id': 3, 'name': 'Niger Basin'}
    ],
    'energy_source': [
        {'id': 1, 'name': 'Solar', 'description': 'Solar energy', 'is_renewable': 1, 'emission_factor': 0.0, 'unit': 'kWh'},
        {'id': 2, 'name': 'Wind', 'description': 'Wind energy', 'is_renewable': 1, 'emission_factor': 0.0, 'unit': 'kWh'},
        {'id': 3, 'name': 'Hydro', 'description': 'Hydropower', 'is_renewable': 1, 'emission_factor': 0.01, 'unit': 'kWh'},
        {'id': 4, 'name': 'Natural Gas', 'description': 'Natural gas', 'is_renewable': 0, 'emission_factor': 0.45, 'unit': 'kWh'},
        {'id': 5, 'name': 'Coal', 'description': 'Coal energy', 'is_renewable': 0, 'emission_factor': 0.95, 'unit': 'kWh'}
    ],
    'energy_type': [
        {'id': 1, 'name': 'Renewable', 'description': 'Clean sources', 'category': 'Sustainable'},
        {'id': 2, 'name': 'Non-Renewable', 'description': 'Fossil fuels', 'category': 'Conventional'}
    ],
    'cost_type': [
        {'id': 1, 'name': 'Fixed', 'description': 'Fixed cost', 'category': 'Economics'},
        {'id': 2, 'name': 'Variable', 'description': 'Variable cost', 'category': 'Economics'}
    ],
    'sector_type': [
        {'id': 1, 'name': 'Residential', 'description': 'Homes and apartments', 'category': 'Private'},
        {'id': 2, 'name': 'Commercial', 'description': 'Shops, offices', 'category': 'Business'},
        {'id': 3, 'name': 'Industrial', 'description': 'Factories, plants', 'category': 'Manufacturing'}
    ],
    'technology_type': [
        {'id': 1, 'name': 'Solar PV', 'description': 'Photovoltaic panels', 'category': 'Renewable', 'efficiency': 18.5},
        {'id': 2, 'name': 'Wind Turbine', 'description': 'Wind energy converter', 'category': 'Renewable', 'efficiency': 35.0},
        {'id': 3, 'name': 'Hydro Plant', 'description': 'Hydroelectric generation', 'category': 'Renewable', 'efficiency': 90.0}
    ],
    'consumption_type': [
        {'id': 1, 'name': 'Electricity', 'description': 'Electric energy use', 'category': 'Utility'},
        {'id': 2, 'name': 'Heating', 'description': 'Thermal energy', 'category': 'Utility'},
        {'id': 3, 'name': 'Cooling', 'description': 'Air conditioning', 'category': 'Utility'}
    ],
    'energy_flow_type': [
        {'id': 1, 'name': 'Generation', 'description': 'Energy production', 'direction': 'out'},
        {'id': 2, 'name': 'Consumption', 'description': 'Energy usage', 'direction': 'in'},
        {'id': 3, 'name': 'Storage', 'description': 'Energy storage', 'direction': 'neutral'}
    ]
}
